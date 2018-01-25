//
//  MainViewController.h
//  MVVMReactive
//
//  Created by QSP on 2018/1/12.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewControllerDelegate <NSObject>

@optional
- (void)logout:(BOOL)seccuss message:(NSString *)message;

@end

@interface MainViewController : UIViewController
@property (weak, nonatomic) id<MainViewControllerDelegate> delegate;

@end
