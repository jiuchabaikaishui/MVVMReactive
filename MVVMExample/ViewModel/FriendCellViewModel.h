//
//  FriendCellViewModel.h
//  MVVMExample
//
//  Created by QSP on 2018/3/21.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendModel.h"

@interface FriendCellViewModel : NSObject

@property (strong, nonatomic) FriendModel *friendModel;

+ (instancetype)friendCellViewModel:(FriendModel *)model;
- (instancetype)initWithFriendModel:(FriendModel *)model;

@end
