//
//  LoadingTool.m
//  MVVMExample
//
//  Created by QSP on 2018/2/28.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "LoadingTool.h"
#import "MBProgressHUD.h"

@implementation LoadingTool

+ (void)showTo:(UIView *)view {
    [MBProgressHUD showHUDAddedTo:view animated:NO];
}
+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.userInteractionEnabled = YES;
    [hud hideAnimated:YES afterDelay:3];
}
+ (void)hideFrom:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:NO];
}

@end
