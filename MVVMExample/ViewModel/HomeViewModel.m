//
//  HomeViewModel.m
//  MVVMExample
//
//  Created by QSP on 2018/3/29.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "HomeViewModel.h"
#import "LinqToObjectiveC.h"

@implementation HomeViewModel
@synthesize resultsViewModel = _resultsViewModel;

- (instancetype)initWithHome:(Home *)home {
    if (self = [super init]) {
        self.title = @"首页";
        _page = 0;
        _pageCount = 20;
        
        _home = home;
        _logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(ResultModel *model) {
            return [[self.home.user logoutSignal] logAll];
        }];
    }
    
    return self;
}
- (ResultsViewModel *)resultsViewModel {
    if (_resultsViewModel == nil) {
        _resultsViewModel = [ResultsViewModel resultsViewModelWithResults:[Results resultWithUser:self.home.user]];
    }
    
    return _resultsViewModel;
}

- (RACSignal *)pageSignal:(BOOL)isFirst {
    return [[[self.home friendSignalWithPage:isFirst ? 0 : self.page andCount:self.pageCount] map:^id _Nullable(ResultModel *model) {
        return [ResultModel resultWithSuccess:model.success message:model.message dataModel:[model.dataModel linq_select:^id(id item) {
            //转换为viewModel数据
            return [FriendCellViewModel friendCellViewModel:item];
        }]];
    }] doNext:^(ResultModel *model) {
        if (isFirst) {
            self.dataArr = model.dataModel;
            _page = 1;
        } else {
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.dataArr];
            [mArr addObjectsFromArray:model.dataModel];
            self.dataArr = [NSArray arrayWithArray:mArr];
            _page++;
        }
    }];
}

@end
