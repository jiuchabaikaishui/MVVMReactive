//
//  LoginViewModel.h
//  MVVMExample
//
//  Created by QSP on 2018/2/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "Services.h"
#import "User.h"

    @interface LoginViewModel : NSObject

    @property (strong, nonatomic) User *user;
    @property (strong, nonatomic) RACCommand *loginCommand;

    + (instancetype)loginViewModelWithUser:(User *)user;
    - (instancetype)initWithUser:(User *)user;

@end
