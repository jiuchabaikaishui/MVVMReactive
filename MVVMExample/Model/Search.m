//
//  Search.m
//  MVVMExample
//
//  Created by QSP on 2018/3/28.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "Search.h"

@implementation Search

+ (instancetype)searchWithServices:(Services *)services userModel:(UserModel *)model {
    return [[self alloc] initWithServices:services userModel:model];
}
- (instancetype)initWithServices:(Services *)services userModel:(UserModel *)model {
    if (self = [super init]) {
        _services = services;
        _userModel = model;
    }
    
    return self;
}

@end
