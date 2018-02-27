//
//  MainViewController.h
//  MVVMExample
//
//  Created by QSP on 2018/1/8.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewModel.h"

@interface SearchViewController : UIViewController

+ (instancetype)searchViewControllerWithViewModel:(SearchViewModel *)viewModel;
- (instancetype)initWithViewModel:(SearchViewModel *)viewModel;

@end
