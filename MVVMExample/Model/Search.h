//
//  Search.h
//  MVVMExample
//
//  Created by QSP on 2018/3/28.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "Services.h"

@interface Search : NSObject

/**
 搜索文字
 */
@property (copy, nonatomic) NSString *searchText;
@property (strong, nonatomic, readonly) Services *services;
@property (strong, nonatomic, readonly) UserModel *userModel;

+ (instancetype)searchWithServices:(Services *)services userModel:(UserModel *)model;
- (instancetype)initWithServices:(Services *)services userModel:(UserModel *)model;

@end
