//
//  ResultModel.h
//  MVVMExample
//
//  Created by QSP on 2018/3/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject

@property (assign, nonatomic) BOOL success;
@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) id dataModel;

+ (instancetype)resultWithSuccess:(BOOL)success message:(NSString *)message dataModel:(id)model;
- (instancetype)initWithSuccess:(BOOL)success message:(NSString *)message dataModel:(id)model;

@end
