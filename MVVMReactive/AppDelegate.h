//
//  AppDelegate.h
//  MVVMReactive
//
//  Created by QSP on 2017/9/28.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)gotoLoginViewController;
- (void)gotoMainViewController;

@end

