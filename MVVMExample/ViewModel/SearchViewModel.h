//
//  SearchViewModel.h
//  MVVMExample
//
//  Created by QSP on 2018/1/26.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "FriendCellViewModel.h"
#import "Services.h"
#import "UserModel.h"
#import "Search.h"

@interface SearchViewModel : NSObject

/**
 控制器标题
 */
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic, readonly) Search *search;
@property (strong, nonatomic, readonly) RACSignal *alffFriendsSignal;
@property (strong, nonatomic, readonly) RACCommand *searchCommand;
@property (strong, nonatomic, readonly) RACCommand *logoutCommand;
@property (copy, nonatomic) NSArray<FriendCellViewModel *> *results;

- (instancetype)initWithSearch:(Search *)search;

@end
