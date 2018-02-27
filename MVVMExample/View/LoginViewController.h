//
//  ViewController.h
//  MVVMExample
//
//  Created by QSP on 2018/1/6.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"

@interface LoginViewController : UIViewController

- (instancetype)initWithLoginViewModel:(LoginViewModel *)viewModel;

@end

