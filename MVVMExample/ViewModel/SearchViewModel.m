//
//  SearchViewModel.m
//  MVVMExample
//
//  Created by QSP on 2018/1/26.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchServices.h"

@interface SearchViewModel ()

@property (strong, nonatomic, readonly) SearchServices *searchServices;

@end

@implementation SearchViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"好友";
        self.searchText = @"";
        //RACObserve宏来从ViewModel的searchText属性创建一个信号。map操作将文本转化为一个true或false值的流。distinctUntilChanges确保信号只有在状态改变时才发出值。
        RACSignal *validSearchS = [[RACObserve(self, searchText) map:^id _Nullable(id  _Nullable value) {
            return @(((NSString *)value).length > 0);
        }] distinctUntilChanged];
        [validSearchS subscribeNext:^(id  _Nullable x) {
            NSLog(@"是否能搜索%@", x);
        }];
        self.searchCommand = [[RACCommand alloc] initWithEnabled:validSearchS signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[self.searchServices searchSignal:self.searchText] logAll];
        }];
        
        _searchServices = [[SearchServices alloc] init];
    }
    
    return self;
}

@end
