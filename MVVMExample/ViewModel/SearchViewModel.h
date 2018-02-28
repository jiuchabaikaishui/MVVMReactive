//
//  SearchViewModel.h
//  MVVMExample
//
//  Created by QSP on 2018/1/26.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "SearchServices.h"

@interface SearchViewModel : NSObject

/**
 控制器标题
 */
@property (copy, nonatomic) NSString *title;

/**
 搜索文字
 */
@property (copy, nonatomic) NSString *searchText;
@property (strong, nonatomic) RACCommand *searchCommand;
@property (strong, nonatomic) RACCommand *logoutCommand;

- (instancetype)initWithSearchServices:(SearchServices *)services;

@end
