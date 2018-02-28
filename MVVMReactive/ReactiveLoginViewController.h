//
//  ViewController.h
//  MVVMReactive
//
//  Created by QSP on 2017/9/28.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

@protocol ReactiveLoginViewControllerDelegate <NSObject>

@optional
- (void)login:(BOOL)success message:(NSString *)message;

@end

@interface ReactiveLoginViewController : UIViewController

@property (weak, nonatomic) RACSignal *loginSignal;
@property (weak, nonatomic) id<ReactiveLoginViewControllerDelegate> delegate;

@end

