//
//  ResultsViewModel.h
//  MVVMExample
//
//  Created by QSP on 2018/3/30.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Results.h"
#import "FriendCellViewModel.h"

@interface ResultsViewModel : NSObject

@property (strong, nonatomic, readonly) Results *results;
@property (assign, nonatomic, readonly) NSInteger page;
@property (assign, nonatomic, readonly) NSInteger pageCount;
@property (copy, nonatomic) NSString *searchContent;
@property (copy, nonatomic) NSArray<FriendCellViewModel *> *dataArr;

+ (instancetype)resultsViewModelWithResults:(Results *)results;
- (instancetype)initWithResults:(Results *)results;
- (RACSignal *)searchSignal:(BOOL)isFirst;

@end
