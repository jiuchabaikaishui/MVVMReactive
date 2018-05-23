//
//  LoginServices.m
//  MVVMExample
//
//  Created by QSP on 2018/2/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "Services.h"
#import "NetworkingTool.h"

@implementation Result

+ (instancetype)resultWithSuccess:(BOOL)success message:(NSString *)message responseObject:(id)responseObject {
    return [[self alloc] initWithSuccess:success message:message responseObject:responseObject];
}
- (instancetype)initWithSuccess:(BOOL)success message:(NSString *)message responseObject:(id)responseObject {
    if (self = [super init]) {
        self.success = success;
        self.message = message;
        self.responseObject = responseObject;
    }
    
    return self;
}

@end

@interface Services ()

@property (weak, nonatomic) UIWindow *window;

@end

@implementation Services

- (RACSignal *)loginSignal:(NSString *)userName passWord:(NSString *)passWord {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_Login parameters:@{@"userName": userName, @"passWord": passWord} completion:^(BOOL success, NSString *message, id responseObject) {
            [subscriber sendNext:[Result resultWithSuccess:success message:message responseObject:responseObject]];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //完成后清理不需要的资源
        }];
    }];
}
- (RACSignal *)logoutSignal:(NSString *)userName passWord:(NSString *)passWord {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_Logout parameters:@{@"userName": userName, @"passWord": passWord} completion:^(BOOL success, NSString *message, id responseObject) {
            [subscriber sendNext:[Result resultWithSuccess:success message:message responseObject:responseObject]];
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

- (RACSignal *)searchSignal:(NSString *)searchText {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_SearchFriends parameters:@{@"searchText": searchText} completion:^(BOOL success, NSString *message, id responseObject) {
            [subscriber sendNext:[Result resultWithSuccess:success message:message responseObject:responseObject]];
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //完成后清理不需要的资源
        }];
    }];
}
- (RACSignal *)allFriendsSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_GetAllFriends parameters:nil completion:^(BOOL success, NSString *message, id responseObject) {
            [subscriber sendNext:[Result resultWithSuccess:success message:message responseObject:responseObject]];
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //完成后清理不需要的资源
        }];
    }];
}
- (RACSignal *)friendSignalWithPage:(NSInteger)page andCount:(NSInteger)count {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_PageFriends parameters:@{@"page": @(page), @"count": @(count)} completion:^(BOOL success, NSString *message, id responseObject) {
            [subscriber sendNext:[Result resultWithSuccess:success message:message responseObject:responseObject]];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //完成后清理不需要的资源
        }];
    }];
}
- (RACSignal *)searchSignalWithContent:(NSString *)content page:(NSInteger)page andCount:(NSInteger)count {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_SearchFriends parameters:@{@"searchContent": content, @"page": @(page), @"count": @(count)} completion:^(BOOL success, NSString *message, id responseObject) {
            [subscriber sendNext:[Result resultWithSuccess:success message:message responseObject:responseObject]];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //完成后清理不需要的资源
        }];
    }];
}

@end
