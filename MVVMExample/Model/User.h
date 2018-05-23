//
//  User.h
//  MVVMExample
//
//  Created by QSP on 2018/3/22.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "ResultModel.h"
#import <ReactiveObjC.h>
#import "Services.h"

@interface User : NSObject

@property (strong, nonatomic, readonly) Services *services;
@property (strong, nonatomic) UserModel *userModel;
@property (assign, nonatomic, readonly, getter=isValidOfUsername) BOOL validOfUsername;
@property (assign, nonatomic, readonly, getter=isValidOfPassword) BOOL validOfPassword;

+ (instancetype)userWithServices:(Services *)services userModel:(UserModel *)model;
- (instancetype)initWithServices:(Services *)services userModel:(UserModel *)model;

- (RACSignal *)loginSignal;
- (RACSignal *)logoutSignal;

@end
