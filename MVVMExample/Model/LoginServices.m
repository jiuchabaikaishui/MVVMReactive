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

@interface LoginServices ()

@property (weak, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *controller;

@end

@implementation LoginServices

- (instancetype)initWithWindow:(UIWindow *)window rootViewControlller:(UIViewController *)controller {
    if (self = [super init]) {
        self.window = window;
        self.controller = controller;
    }
    
    return self;
}

- (RACSignal *)loginSignal:(NSString *)userName passWord:(NSString *)passWord {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MBProgressHUD showHUDAddedTo:self.window animated:NO];
        [NetworkingTool postWithPath:K_Service_Login parameters:@{@"userName": userName, @"passWord": passWord} completion:^(BOOL success, NSString *message, id responseObject) {
            [MBProgressHUD hideHUDForView:self.window animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.controller.view animated:NO];
            hud.mode = MBProgressHUDModeText;
            if (success) {
                hud.label.text = responseObject[@"message"];
            } else {
                hud.label.text = message;
            }
            hud.label.numberOfLines = 0;
            hud.userInteractionEnabled = YES;
            [hud hideAnimated:YES afterDelay:3];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //完成后清理不需要的资源
        }];
    }];
}
- (void)gotoSearchViewModel:(SearchViewModel *)viewModel {
    self.window.rootViewController = self.controller;
    [self.window makeKeyAndVisible];
}

@end
