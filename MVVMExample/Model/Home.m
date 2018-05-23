//
//  Home.m
//  MVVMExample
//
//  Created by QSP on 2018/3/29.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "Home.h"
#import "LinqToObjectiveC.h"
#import "FriendModel.h"

@implementation Home

+ (instancetype)homeWithUser:(User *)user {
    return [[self alloc] initWithUser:user];
}
- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        _user = user;
    }
    
    return self;
}

- (RACSignal *)friendSignalWithPage:(NSInteger)page andCount:(NSInteger)count {
    return [[self.user.services friendSignalWithPage:page andCount:count] map:^id _Nullable(Result *result) {
        //转换为模型数据
        return [ResultModel resultWithSuccess:result.success message:result.message dataModel:[result.responseObject linq_select:^id(id item) {
            return [FriendModel friendModelWithInfo:item];
        }]];
    }];
}
- (RACSignal *)searchSignalWithContent:(NSString *)content page:(NSInteger)page andCount:(NSInteger)count {
    return [[self.user.services searchSignalWithContent:content page:page andCount:count] map:^id _Nullable(Result *result) {
        //转换为模型数据
        return [ResultModel resultWithSuccess:result.success message:result.message dataModel:[result.responseObject linq_select:^id(id item) {
            return [FriendModel friendModelWithInfo:item];
        }]];
    }];
}

@end
