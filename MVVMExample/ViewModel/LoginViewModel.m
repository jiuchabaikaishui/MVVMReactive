//
//  LoginViewModel.m
//  MVVMExample
//
//  Created by QSP on 2018/2/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "LoginViewModel.h"
#import "MBProgressHUD.h"
#import "SearchViewModel.h"

@interface LoginViewModel ()

@end

@implementation LoginViewModel

+ (instancetype)loginViewModelWithUser:(User *)user {
    return [[self alloc] initWithUser:user];
}
- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        self.user = user;
        
        //创建有效的用户名密码信号
        @weakify(self)
        RACSignal *validUS = [[RACObserve(self.user.userModel, username) map:^id _Nullable(id  _Nullable value) {
            @strongify(self)
            return @(self.user.isValidOfUsername);
        }] distinctUntilChanged];
        RACSignal *validPS = [[RACObserve(self.user.userModel, password) map:^id _Nullable(id  _Nullable value) {
            @strongify(self)
            return @(self.user.isValidOfPassword);
        }] distinctUntilChanged];
        
        //合并有效的用户名密码信号作为控制登录按钮可用的信号
        RACSignal *validLS = [RACSignal combineLatest:@[validUS, validPS] reduce:^id _Nonnull(id first, id second) {
            return @([first boolValue] && [second boolValue]);
        }];
        
        self.loginCommand = [[RACCommand alloc] initWithEnabled:validLS signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [[self.user loginSignal] logAll];
        }];
    }
    
    return self;
}

@end
