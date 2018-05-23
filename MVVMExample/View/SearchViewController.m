//
//  MainViewController.m
//  MVVMExample
//
//  Created by QSP on 2018/1/8.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "SearchViewController.h"
#import "Masonry.h"
#import <ReactiveObjC.h>
#import "UIImageView+WebCache.h"
#import "TableViewBindingHelper.h"
#import "FriendTableViewCell.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource>

/**
 这是一个弱引用
 */
@property (weak, nonatomic) SearchViewModel *viewModel;
@property (weak, nonatomic) UITextField *searchTextField;
@property (weak, nonatomic) UIButton *leftButton;
@property (weak, nonatomic) UIButton *rightButton;
@property (weak, nonatomic) UIView *loadingView;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TableViewBindingHelper *helper;

@end

@implementation SearchViewController

#pragma mark - 属性方法

#pragma mark - 控制器周期
+ (instancetype)searchViewControllerWithViewModel:(SearchViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}
- (instancetype)initWithViewModel:(SearchViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUi];
    [self bindViewModel];
}

#pragma mark - 自定义方法
- (void)bindViewModel {
    self.title = self.viewModel.title;
    RAC(self.viewModel.search, searchText) = self.searchTextField.rac_textSignal;
    RAC(self.loadingView, hidden) = [self.viewModel.searchCommand.executing not];
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = self.viewModel.logoutCommand.executing;
    
    self.rightButton.rac_command = self.viewModel.searchCommand;
    self.leftButton.rac_command = self.viewModel.logoutCommand;
    
    [self.viewModel.searchCommand.executionSignals subscribeNext:^(id  _Nullable x) {
        [self.searchTextField resignFirstResponder];
    }];
    
    [RACObserve(self.viewModel, results) subscribeNext:^(id  _Nullable x) {
        [self.tableView reloadData];
    }];
    
//    self.helper = [TableViewBindingHelper bindingHelperForTableView:self.tableView sourceSignal:RACObserve(self.viewModel, results) selectionCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            [subscriber sendCompleted];
//
//            return [RACDisposable disposableWithBlock:^{
//                //完成后清理不需要的资源
//            }];
//        }];
//    }]];
}
- (void)settingUi {
    //设置UI
    self.title = @"首页";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setTitle:@"退出" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.leftButton = leftButton;
    
    UITextField *textField = [[UITextField alloc] init];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    textField.placeholder = @"搜索好友…";
    [textField becomeFirstResponder];
    self.navigationItem.titleView = textField;
    self.searchTextField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@(0));
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width - 110));
        make.height.equalTo(@(30));
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    self.loadingView = rightView;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.hidden = YES;
    indicatorView.center = CGPointMake(15, 15);
    [indicatorView startAnimating];
    [rightView addSubview:indicatorView];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightButton = rightButton;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.results.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FriendTableViewCell friendCell:tableView viewModel:[self.viewModel.results objectAtIndex:indexPath.row]];
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
