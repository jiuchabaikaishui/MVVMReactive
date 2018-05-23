//
//  HomeViewModel.h
//  MVVMExample
//
//  Created by QSP on 2018/3/29.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "Home.h"
#import "FriendCellViewModel.h"
#import "ResultsViewModel.h"

@interface HomeViewModel : NSObject

/**
 控制器标题
 */
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic, readonly) NSInteger page;
@property (assign, nonatomic, readonly) NSInteger pageCount;
@property (strong, nonatomic, readonly) Home *home;
@property (strong, nonatomic, readonly) RACCommand *logoutCommand;
@property (copy, nonatomic) NSArray<FriendCellViewModel *> *dataArr;
@property (copy, nonatomic) NSArray<FriendCellViewModel *> *searchDataArr;
@property (strong, nonatomic, readonly) ResultsViewModel *resultsViewModel;

- (instancetype)initWithHome:(Home *)home;
- (RACSignal *)pageSignal:(BOOL)isFirst;

@end
