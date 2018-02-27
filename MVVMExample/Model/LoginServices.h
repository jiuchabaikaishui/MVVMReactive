//
//  LoginServices.h
//  MVVMExample
//
//  Created by QSP on 2018/2/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchViewModel.h"

@protocol LoginDelegate <NSObject>

- (RACSignal *)loginSignal:(NSString *)userName passWord:(NSString *)passWord;
- (void)gotoSearchViewModel:(SearchViewModel *)viewModel;

@end

@interface LoginServices : NSObject <LoginDelegate>

- (instancetype)initWithWindow:(UIWindow *)window rootViewControlller:(UIViewController *)controller;

@end
