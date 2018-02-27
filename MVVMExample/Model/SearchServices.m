//
//  SearchModel.m
//  MVVMExample
//
//  Created by QSP on 2018/2/24.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "SearchServices.h"
#import "FriendModel.h"
#import "NetworkingTool.h"

@interface SearchServices ()

@end

@implementation SearchServices

- (RACSignal *)searchSignal:(NSString *)searchText {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_SearchFriends parameters:@{@"searchText": searchText} completion:^(BOOL success, NSString *message, id responseObject) {
            if (success) {
                NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *dic in responseObject) {
                    [mArr addObject:[FriendModel friendModelWithInfo:dic]];
                }
                [subscriber sendNext:mArr];
            } else {
                [subscriber sendNext:nil];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //完成后清理不需要的资源
        }];
    }];
}

@end
