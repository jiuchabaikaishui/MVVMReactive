//
//  LoadingTool.h
//  MVVMExample
//
//  Created by QSP on 2018/2/28.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingTool : NSObject

+ (void)showTo:(UIView *)view;
+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)hideFrom:(UIView *)view;

@end
