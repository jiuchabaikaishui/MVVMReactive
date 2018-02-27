//
//  friendModel.h
//  MVVMReactive
//
//  Created by QSP on 2018/1/22.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (copy, nonatomic) NSString *uin;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *img;

+ (instancetype)friendModelWithInfo:(NSDictionary *)info;
- (instancetype)initWithInfo:(NSDictionary *)info;

@end
