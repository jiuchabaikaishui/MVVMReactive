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
#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface SearchServices ()

@property (weak, nonatomic) UIWindow *window;

@end

@implementation SearchServices

- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        self.window = window;
    }
    
    return self;
}

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
- (RACSignal *)logoutSignal:(NSString *)userName {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetworkingTool postWithPath:K_Service_Logout parameters:@{@"userName": userName} completion:^(BOOL success, NSString *message, id responseObject) {
            if (success) {
                [subscriber sendNext:responseObject];
            } else {
                [subscriber sendNext:nil];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
- (void)gotoLoginViewModel {
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initWithLoginViewModel:[[LoginViewModel alloc] initWithLoginServices:[[LoginServices alloc] initWithWindow:self.window]]]];
    [self.window makeKeyAndVisible];
}

@end
