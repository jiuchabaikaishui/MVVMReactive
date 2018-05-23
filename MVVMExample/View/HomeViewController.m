//
//  HomeViewController.m
//  MVVMExample
//
//  Created by QSP on 2018/3/29.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "HomeViewController.h"
#import "FriendTableViewCell.h"
#import "LoadingTool.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "ResultsViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) HomeViewModel *viewModel;
@property (weak, nonatomic) UIButton *leftButton;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchCtr;

@end

@implementation HomeViewController

#pragma mark - 控制器方法
+ (instancetype)homeViewControllerWithViewModel:(HomeViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}
- (instancetype)initWithViewModel:(HomeViewModel *)viewModel {
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
    
    self.leftButton.rac_command = self.viewModel.logoutCommand;
    @weakify(self)
    [self.viewModel.logoutCommand.executing subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        BOOL end = [x boolValue];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = end;
        if (end) {
            [LoadingTool showTo:self.view];
        } else {
            [LoadingTool hideFrom:self.view];
        }
    }];
    [self.viewModel.logoutCommand.executionSignals subscribeNext:^(RACSignal *signal) {
        @strongify(self)
        [signal subscribeNext:^(ResultModel *model) {
            if (model.success) {
                LoginViewController *loginCtr = [[LoginViewController alloc] initWithLoginViewModel:[LoginViewModel loginViewModelWithUser:model.dataModel]];
                UIWindow *window = [UIApplication sharedApplication].delegate.window;
                window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginCtr];
                [window makeKeyWindow];
            } else {
                [LoadingTool showMessage:model.message toView:self.view];
            }
        }];
    }];
    [RACObserve(self.viewModel, dataArr) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadTableView:YES];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadTableView:NO];
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}
/**
 加载tableView

 @param isDown 是否为下拉加载
 */
- (void)loadTableView:(BOOL)isDown {
    @weakify(self)
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[self.viewModel pageSignal:isDown] subscribeNext:^(ResultModel *model) {
        @strongify(self)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (model.success) {
            if (model.dataModel == nil || [(NSArray *)model.dataModel count] == 0) {
                [LoadingTool showMessage:isDown ? @"没有数据" : @"没有跟多数据" toView:self.view];
            }
        } else {
            [LoadingTool showMessage:model.message toView:self.view];
        }
        if (isDown) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
- (void)settingUi {
    //设置UI
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setTitle:@"退出" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.leftButton = leftButton;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    ResultsViewController *resultsCtr = [ResultsViewController resultsViewControllerWithViewModel:self.viewModel.resultsViewModel];
    UISearchController *searchCtr = [[UISearchController alloc] initWithSearchResultsController:resultsCtr];
    searchCtr.searchBar.delegate = resultsCtr;
    searchCtr.searchResultsUpdater = self;
    self.searchCtr = searchCtr;
    UIView *view = [[UIView alloc] initWithFrame:searchCtr.searchBar.frame];
    [view addSubview:searchCtr.searchBar];
    self.tableView.tableHeaderView = view;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.dataArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FriendTableViewCell friendCell:tableView viewModel:[self.viewModel.dataArr objectAtIndex:indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - <UISearchResultsUpdating>代理方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.viewModel.resultsViewModel.searchContent = searchController.searchBar.text;
}

@end
