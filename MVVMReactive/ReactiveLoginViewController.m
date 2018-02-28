//
//  ViewController.m
//  MVVMReactive
//
//  Created by QSP on 2017/9/28.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "ReactiveLoginViewController.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <RACEXTScope.h>

@interface ReactiveLoginViewController ()

@end

@implementation ReactiveLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建界面元素
    UITextField *userNameTextField = [[UITextField alloc] init];
    userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    userNameTextField.placeholder = @"请输入用户名…";
    [userNameTextField becomeFirstResponder];
    [self.view addSubview:userNameTextField];
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.placeholder = @"请输入密码…";
    passwordTextField.secureTextEntry =  YES;
    [self.view addSubview:passwordTextField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
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
    
    
    //1.创建有效的账号和密码信号
    @weakify(self)
    RACSignal *validUserNameSignal = [userNameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self)
        return @([self isValid:value]);
    }];
    RACSignal *validPasswordSignal = [passwordTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self)
        return @([self isValid:value]);
    }];
    
    //2.将信号的输出值赋值给文本输入框的backgroundColor属性
    RAC(userNameTextField, backgroundColor) = [validUserNameSignal map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? [UIColor clearColor] : [UIColor groupTableViewBackgroundColor];
    }];
    RAC(passwordTextField, backgroundColor) = [validPasswordSignal map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? [UIColor clearColor] : [UIColor groupTableViewBackgroundColor];
    }];
    
    //3.组合信号并设置登录按钮是否可用
    [[RACSignal combineLatest:@[validUserNameSignal, validPasswordSignal] reduce:^id _Nonnull(id first, id second){
        return @([first boolValue] && [second boolValue]);
    }] subscribeNext:^(id  _Nullable x) {
        loginButton.enabled = [x boolValue];
    }];
    
    //4.创建一个登录信号
    RACSignal *loginSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        [self loginWithUserName:userNameTextField.text password:passwordTextField.text comletion:^(bool success, NSDictionary *responseDic) {
            if (success) {
                NSLog(@"%@", responseDic[@"message"]);
                if ([responseDic[@"code"] integerValue] == 0) {
                    [subscriber sendNext:@{@"success": @(YES), @"message": responseDic[@"message"]}];
                } else {
                    [subscriber sendNext:@{@"success": @(NO), @"message": responseDic[@"message"]}];
                }
            } else {
                NSString *message = @"请求失败";
                NSLog(@"%@", message);
                [subscriber sendNext:@{@"success": @(NO), @"message": message}];
            }
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    
    //5.响应按钮点击事件
    [[[[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [self.view endEditing:YES];
        loginButton.enabled = NO;
    }] flattenMap:^id _Nullable(__kindof UIControl * _Nullable value) {
        return loginSignal;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        loginButton.enabled = YES;
        if (![x[@"success"] boolValue]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = x[@"message"];
            hud.label.numberOfLines = 0;
            hud.userInteractionEnabled = YES;
            [hud hideAnimated:YES afterDelay:3];
        }
        if ([self.delegate respondsToSelector:@selector(login:message:)]) {
            [self.delegate login:[x[@"success"] boolValue] message:x[@"message"]];
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        loginButton.enabled = YES;
    }];
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password comletion:(void (^)(bool success, NSDictionary *responseDic))comletion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([userName isEqualToString:@"Jiuchabaikaishui"]) {
                if ([password isEqualToString:@"123456"]) {
                    comletion(YES, @{@"userName": userName, @"password": password, @"code": @(0), @"message": @"登录成功"});
                } else {
                    comletion(YES, @{@"userName": userName, @"password": password, @"code": @(1), @"message": @"密码错误"});
                }
            } else {
                if ([userName isEqualToString:@"Jiuchabaikaishu"]) {//用账号Jiuchabaikaishu模拟网络请求失败
                    comletion(NO, nil);
                } else {
                    comletion(YES, @{@"userName": userName, @"password": password, @"code": @(2), @"message": @"账号不存在"});
                }
            }
        });
    });
}
- (BOOL)isValid:(NSString *)str {
    /*
     给密码定一个规则：由字母、数字和_组成的6-16位字符串
     */
    NSString *regularStr = @"[a-zA-Z0-9_]{6,16}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", regularStr];
    return [predicate evaluateWithObject:str];
}

@end
