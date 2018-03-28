//
//  User.m
//  MVVMExample
//
//  Created by QSP on 2018/3/22.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "User.h"

@interface User ()

@end

@implementation User

+ (instancetype)userWithServices:(Services *)services {
    return [[self alloc] initWithServices:services];
}
- (instancetype)initWithServices:(Services *)services {
    if (self = [self init]) {
        _services = services;
    }
    
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        
        self.userModel = [[UserModel alloc] init];
    }
    
    return self;
}

- (BOOL)isValidOfUsername {
    return [self isValid:self.userModel.username];
}
- (BOOL)isValidOfPassword {
    return [self isValid:self.userModel.password];
}
- (RACSignal *)loginSignal {
    return [[self.services loginSignal:self.userModel.username passWord:self.userModel.password] map:^id _Nullable(id  _Nullable value) {
        Result *result = (Result *)value;
        self.userModel.logined = result.success && [result.responseObject[@"code"] integerValue] == 0;
        return [ResultModel resultWithSuccess:result.success ? [result.responseObject[@"code"] integerValue] == 0 : result.success message:result.success ? result.responseObject[@"message"] : result.message dataModel:self.userModel];
    }];
}
- (RACSignal *)logoutSignal {
    return [[self.services logoutSignal:self.userModel.username] map:^id _Nullable(id  _Nullable value) {
        Result *result = (Result *)value;
        self.userModel.logined = !(result.success && [result.responseObject[@"code"] integerValue] == 0);
        return [ResultModel resultWithSuccess:result.success ? [result.responseObject[@"code"] integerValue] == 0 : result.success message:result.success ? result.responseObject[@"message"] : result.message dataModel:self.userModel];
    }];
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
