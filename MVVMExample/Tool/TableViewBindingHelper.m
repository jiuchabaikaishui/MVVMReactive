//
//  TableViewBindingHelper.m
//  MVVMExample
//
//  Created by QSP on 2018/3/21.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "TableViewBindingHelper.h"
#import "FriendTableViewCell.h"

@interface TableViewBindingHelper () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) RACCommand *selection;

@end

@implementation TableViewBindingHelper

+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)selection {
    return [[self alloc] initWithTableView:tableView sourceSignal:source selectionCommand:selection];
}

- (instancetype)initWithTableView:(UITableView *)tableView
                     sourceSignal:(RACSignal *)source
                 selectionCommand:(RACCommand *)selection {
    if (self = [super init]) {
        self.tableView = tableView;
        self.selection = selection;
        @weakify(self)
        [source subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.dataArr = [NSArray arrayWithArray:x];
            [tableView reloadData];
        }];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    
    return self;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource> 代理方法
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FriendTableViewCell friendCell:tableView viewModel:[self.dataArr objectAtIndex:indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.selection execute:@[tableView, indexPath]];
}


@end
