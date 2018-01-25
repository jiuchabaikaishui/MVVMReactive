//
//  MainViewController.m
//  MVVMExample
//
//  Created by QSP on 2018/1/8.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "MainViewController.h"
#import "Masonry.h"

@interface MainViewController ()

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation MainViewController

#pragma mark - 属性方法
- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUi];
}
- (void)settingUi {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = 
}

@end
