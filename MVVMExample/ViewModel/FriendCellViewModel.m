//
//  FriendCellViewModel.m
//  MVVMExample
//
//  Created by QSP on 2018/3/21.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "FriendCellViewModel.h"

@implementation FriendCellViewModel

- (instancetype)initWithFriendModel:(FriendModel *)model {
    if (self = [super init]) {
        self.friendModel = model;
    }
    
    return self;
}
+ (instancetype)friendCellViewModel:(FriendModel *)model {
    return [[self alloc] initWithFriendModel:model];
}

@end
