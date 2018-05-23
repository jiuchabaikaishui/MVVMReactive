//
//  ViewController.m
//  MVVMExample
//
//  Created by QSP on 2018/1/6.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "HomeViewController.h"
#import "LoadingTool.h"

@interface LoginViewController ()

@property (strong, nonatomic) LoginViewModel *viewModel;
@property (weak, nonatomic) UITextField *userNameT;
@property (weak, nonatomic) UITextField *passWordT;
@property (weak, nonatomic) UIButton *loginB;

@end

@implementation LoginViewController

- (instancetype)initWithLoginViewModel:(LoginViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUI];
    [self bindViewModel];
}

#pragma mark - 自定义方法
- (void)bindViewModel {
    self.userNameT.text = self.viewModel.user.userModel.username;
    self.passWordT.text = self.viewModel.user.userModel.password;
    RAC(self.viewModel.user.userModel, username) = self.userNameT.rac_textSignal;
    RAC(self.viewModel.user.userModel, password) = self.passWordT.rac_textSignal;
    self.loginB.rac_command = self.viewModel.loginCommand;
    @weakify(self)
    [self.viewModel.loginCommand.executing subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        BOOL end = [x boolValue];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = end;
        if (end) {
            [LoadingTool showTo:self.view];
        } else {
            [LoadingTool hideFrom:self.view];
        }
    }];
    [self.viewModel.loginCommand.executionSignals subscribeNext:^(RACSignal *signal) {
        @strongify(self)
        [signal subscribeNext:^(ResultModel *model) {
            [self.userNameT resignFirstResponder];
            [self.passWordT resignFirstResponder];
            
            if (model.success) {
                HomeViewController *homeCtr = [HomeViewController homeViewControllerWithViewModel:[[HomeViewModel alloc] initWithHome:[Home homeWithUser:model.dataModel]]];
                [UIApplication sharedApplication].delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeCtr];
                [[UIApplication sharedApplication].delegate.window makeKeyWindow];
            } else {
                [LoadingTool showMessage:model.message toView:self.view];
            }
        }];
    }];
}
- (void)settingUI {
    //创建界面元素
    UITextField *userNameTextField = [[UITextField alloc] init];
    userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    userNameTextField.placeholder = @"请输入用户名…";
    [userNameTextField becomeFirstResponder];
    [self.view addSubview:userNameTextField];
    self.userNameT = userNameTextField;
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.placeholder = @"请输入密码…";
    passwordTextField.secureTextEntry =  YES;
    [self.view addSubview:passwordTextField];
    self.passWordT = passwordTextField;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    self.loginB = loginButton;
    
    //布局界面元素
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.bottom.equalTo(passwordTextField.mas_top).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(30));
    }];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordTextField.mas_left).offset(44);
        make.top.equalTo(passwordTextField.mas_bottom).offset(10);
        make.right.equalTo(passwordTextField.mas_right).offset(-44);
        make.height.equalTo(@(30));
    }];
}

@end
