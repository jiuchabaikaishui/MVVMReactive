//
//  MainViewController.m
//  MVVMReactive
//
//  Created by QSP on 2018/1/12.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "MainViewController.h"
#import <ReactiveObjC.h>
#import "AppDelegate.h"
#import "FriendModel.h"
#import "Masonry.h"
#import "MBProgressHUD.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *friends;
@property (copy, nonatomic) NSArray *allFriends;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation MainViewController
@synthesize friends = _friends;

#pragma mark - 属性方法
- (NSArray *)friends {
    if (_friends == nil) {
        _friends = [NSArray array];
    }
    
    return _friends;
}
- (void)setFriends:(NSArray *)friends {
    _friends = [friends copy];
    [self.tableView reloadData];
}

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    self.title = @"首页";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setTitle:@"退出" forState:UIControlStateNormal];
    [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([self.delegate respondsToSelector:@selector(logout:message:)]) {
            [self.delegate logout:YES message:nil];
        }
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    UITextField *textField = [[UITextField alloc] init];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    textField.placeholder = @"搜索好友";
    self.navigationItem.titleView = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@(0));
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width - 60));
        make.height.equalTo(@(30));
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //创建RACSignal
    @weakify(self)
    RACSignal *dataSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [self gettingData:^(BOOL success, NSArray *friends) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            if (success) {
                self.allFriends = [NSArray arrayWithArray:friends];
                self.friends = self.allFriends;
                [textField becomeFirstResponder];
                [subscriber sendNext:friends];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"NetError" code:1 userInfo:@{@"message": @"网络请求失败"}]];
            }
        }];
        
        return nil;
    }];
    RACSignal *searchSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        [self searchFriends:textField.text completion:^(BOOL success, NSArray *friends) {
            NSArray *arr;
            if (success) {
                arr = friends;
            } else {
                arr = self.allFriends;
            }
            
            [subscriber sendNext:arr];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    [[[[[[dataSignal then:^RACSignal * _Nonnull{
        return textField.rac_textSignal;
    }] filter:^BOOL(id  _Nullable value) {
        @strongify(self)
        NSString *text = (NSString *)value;
        if (text.length == 0) {
            if (![self.friends isEqual:self.allFriends]) {
                self.friends = self.allFriends;
            }
        }
        return text.length > 0;
    }] throttle:0.5] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return searchSignal;
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.friends = (NSArray *)x;
    }];
}

- (void)gettingData:(void (^)(BOOL success, NSArray *friends))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
        NSError *error = nil;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        [NSThread sleepForTimeInterval:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (completion) {
                    completion(NO, nil);
                }
            } else {
                if (completion) {
                    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:1];
                    for (NSDictionary *dic in arr) {
                        [mArr addObject:[FriendModel friendModelWithInfo:dic]];
                    }
                    completion(YES, mArr);
                }
            }
        });
    });
}
- (void)searchFriends:(NSString *)content completion:(void (^)(BOOL success, NSArray *friends)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.allFriends) {
                if (completion) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name like '*%@*' or uin like '*%@*'", content, content]];//name beginswith[c] %@
                    completion(YES, [self.allFriends filteredArrayUsingPredicate:predicate]);
                } else {
                    if (completion) {
                        completion(NO, nil);
                    }
                }
            }
        });
    });
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.friends ? 1 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    FriendModel *model = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.uin;
    cell.imageView.image = [UIImage imageNamed:@"50"];
    //异步加载图片
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.img]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [subscriber sendNext:data];
            });
        });
        return nil;
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        [cell.imageView setImage:[UIImage imageWithData:x]];
    }];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.navigationItem.titleView isFirstResponder]) {
        [self.navigationItem.titleView endEditing:YES];
    }
}

@end
