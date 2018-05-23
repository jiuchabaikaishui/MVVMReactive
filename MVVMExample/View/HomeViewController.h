//
//  HomeViewController.h
//  MVVMExample
//
//  Created by QSP on 2018/3/29.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"

@interface HomeViewController : UIViewController

+ (instancetype)homeViewControllerWithViewModel:(HomeViewModel *)viewModel;
- (instancetype)initWithViewModel:(HomeViewModel *)viewModel;

@end
