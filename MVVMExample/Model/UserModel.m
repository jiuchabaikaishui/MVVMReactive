//
//  UserModel.m
//  MVVMExample
//
//  Created by QSP on 2018/3/22.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)userModelWithUsername:(NSString *)username password:(NSString *)password logined:(BOOL)logined {
    return [[self alloc] initWithUsername:username password:password logined:logined];
}
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password logined:(BOOL)logined {
    if (self = [super init]) {
        self.username = username;
        self.password = password;
        self.logined = logined;
    }
    
    return self;
}

@end
