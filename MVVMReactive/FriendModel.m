//
//  friendModel.m
//  MVVMReactive
//
//  Created by QSP on 2018/1/22.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

+ (instancetype)friendModelWithInfo:(NSDictionary *)info {
    return [[self alloc] initWithInfo:info];
}
- (instancetype)initWithInfo:(NSDictionary *)info {
    if (self = [super init]) {
        self.uin = [info[@"uin"] stringValue];
        self.name = info[@"name"];
        self.img = info[@"img"];
    }
    
    return self;
}

@end
