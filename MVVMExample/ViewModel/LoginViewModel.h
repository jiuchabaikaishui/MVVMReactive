//
//  LoginViewModel.h
//  MVVMExample
//
//  Created by QSP on 2018/2/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "LoginServices.h"

@interface LoginViewModel : NSObject

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *passWord;
@property (strong, nonatomic) RACCommand *loginCommand;

- (instancetype)initWithLoginServices:(LoginServices *)services;

@end
