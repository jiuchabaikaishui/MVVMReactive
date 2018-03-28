//
//  UserModel.h
//  MVVMExample
//
//  Created by QSP on 2018/3/22.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (assign, nonatomic, getter=isLogined) BOOL logined;

@end
