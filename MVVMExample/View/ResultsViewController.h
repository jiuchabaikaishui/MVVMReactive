//
//  ResultsViewController.h
//  MVVMExample
//
//  Created by QSP on 2018/3/30.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsViewModel.h"

@interface ResultsViewController : UIViewController <UISearchBarDelegate>

+ (instancetype)resultsViewControllerWithViewModel:(ResultsViewModel *)viewModel;
- (instancetype)initWithViewModel:(ResultsViewModel *)viewModel;

@end
