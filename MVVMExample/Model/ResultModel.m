//
//  ResultModel.m
//  MVVMExample
//
//  Created by QSP on 2018/3/27.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "ResultModel.h"

@implementation ResultModel

+ (instancetype)resultWithSuccess:(BOOL)success message:(NSString *)message dataModel:(id)model {
    return [[self alloc] initWithSuccess:success message:message dataModel:model];
}
- (instancetype)initWithSuccess:(BOOL)success message:(NSString *)message dataModel:(id)model {
    if (self = [super init]) {
        self.success = success;
        self.message = message;
        self.dataModel = model;
    }
    
    return self;
}

@end
