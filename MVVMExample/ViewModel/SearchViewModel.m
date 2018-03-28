//
//  SearchViewModel.m
//  MVVMExample
//
//  Created by QSP on 2018/1/26.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "SearchViewModel.h"

@interface SearchViewModel ()

@property (strong, nonatomic, readonly) Services *services;
@property (copy, nonatomic, readonly) NSArray<FriendModel *> *allFriends;

@end

@implementation SearchViewModel

- (instancetype)initWithSearch:(Search *)search {
    if (self = [super init]) {
        self.title = @"好友";
        //RACObserve宏来从ViewModel的searchText属性创建一个信号。map操作将文本转化为一个true或false值的流。distinctUntilChanges确保信号只有在状态改变时才发出值。
        RACSignal *validSearchS = [[RACObserve(self.search, searchText) map:^id _Nullable(id  _Nullable value) {
            return @(((NSString *)value).length > 0);
        }] distinctUntilChanged];
        [validSearchS subscribeNext:^(id  _Nullable x) {
            NSLog(@"是否能搜索%@", x);
        }];
        _searchCommand = [[RACCommand alloc] initWithEnabled:validSearchS signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[[self.services searchSignal:self.search.searchText] doNext:^(id  _Nullable x) {
                if ([x[@"code"] integerValue] == 0) {
                    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:1];
                    for (FriendModel *model in x[@"data"]) {
                        [mArr addObject:[FriendCellViewModel friendCellViewModel:model]];
                    }
                    self.results = [NSArray arrayWithArray:mArr];
                }
            }] logAll];
        }];
        _logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[[self.services logoutSignal:self.search.userModel.username] doNext:^(id  _Nullable x) {
                if (x && [x[@"code"] integerValue] == 0) {
#warning 导航未完成
//                    [self.searchServices gotoLoginViewModel];
                }
            }] logAll];
        }];
        
//        _alffFriendsSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            if (self.allFriends) {
//                [subscriber sendNext:self.allFriends];
//                [subscriber sendCompleted];
//            } else {
//                [[self.searchServices allFriendsSignal] subscribeNext:^(id  _Nullable x) {
//                    if ([x[@"code"] integerValue] == 0) {
//                        _allFriends = x[@"data"];
//                    }
//
//                    [subscriber sendNext:self.allFriends];
//                    [subscriber sendCompleted];
//                }];
//            }
//
//            return [RACDisposable disposableWithBlock:^{
//
//            }];
//        }];
    }
    
    return self;
}

@end
