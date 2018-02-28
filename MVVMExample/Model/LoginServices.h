//
//  LoginServices.h
//  MVVMExample
//
//  Created by QSP on 2018/2/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@protocol LoginDelegate <NSObject>

- (RACSignal *)loginSignal:(NSString *)userName passWord:(NSString *)passWord;
- (void)gotoSearchViewModel;

- (void)showLoading;
- (void)hideLoading;
- (void)showMessage:(NSString *)message;

@end

@interface LoginServices : NSObject <LoginDelegate>

- (instancetype)initWithWindow:(UIWindow *)window;

@end
