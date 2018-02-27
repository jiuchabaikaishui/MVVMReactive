//
//  LoginViewModel.m
//  MVVMExample
//
//  Created by QSP on 2018/2/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "LoginViewModel.h"
#import "MBProgressHUD.h"

@interface LoginViewModel ()

@property (strong, nonatomic) LoginServices *loginServices;

@end

@implementation LoginViewModel

- (instancetype)initWithLoginServices:(LoginServices *)services {
    if (self = [super init]) {
        self.loginServices = services;
        self.userName = @"";
        self.passWord = @"";
        
        //创建有效的用户名密码信号
        @weakify(self)
        RACSignal *validUS = [[RACObserve(self, userName) map:^id _Nullable(id  _Nullable value) {
            @strongify(self)
            return @([self isValid:value]);
        }] distinctUntilChanged];
        RACSignal *validPS = [[RACObserve(self, passWord) map:^id _Nullable(id  _Nullable value) {
            @strongify(self)
            return @([self isValid:value]);
        }] distinctUntilChanged];
        
        //合并有效的用户名密码信号作为控制登录按钮可用的信号
        RACSignal *validLS = [RACSignal combineLatest:@[validUS, validPS] reduce:^id _Nonnull(id first, id second) {
            return @([first boolValue] && [second boolValue]);
        }];
        
        self.loginCommand = [[RACCommand alloc] initWithEnabled:validLS signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[[self.loginServices loginSignal:self.userName passWord:self.passWord] doNext:^(id  _Nullable x) {
                if (x && [x[@"code"] integerValue] == 0) {
                    [self.loginServices gotoSearchViewModel:[[SearchViewModel alloc] init]];
                }
            }] logAll];
        }];
    }
    
    return self;
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
