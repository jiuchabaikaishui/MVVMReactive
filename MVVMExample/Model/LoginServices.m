//
//  LoginServices.m
//  MVVMExample
//
//  Created by QSP on 2018/2/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "LoginServices.h"
#import "NetworkingTool.h"
#import "MBProgressHUD.h"
#import "SearchViewController.h"
#import "LoadingTool.h"

@interface LoginServices ()

@property (weak, nonatomic) UIWindow *window;

@end

@implementation LoginServices

- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        self.window = window;
    }
    
    return self;
}

- (RACSignal *)loginSignal:(NSString *)userName passWord:(NSString *)passWord {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_Login parameters:@{@"userName": userName, @"passWord": passWord} completion:^(BOOL success, NSString *message, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //完成后清理不需要的资源
        }];
    }];
}
- (void)gotoSearchViewModel {
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SearchViewController alloc] initWithViewModel:[[SearchViewModel alloc] initWithSearchServices:[[SearchServices alloc] initWithWindow:self.window]]]];
    [self.window makeKeyAndVisible];
}
- (void)showLoading {
    [LoadingTool showTo:self.window.rootViewController.view];
}
- (void)hideLoading {
    [LoadingTool hideFrom:self.window.rootViewController.view];
}
- (void)showMessage:(NSString *)message {
    [LoadingTool showMessage:message toView:self.window.rootViewController.view];
}

@end
