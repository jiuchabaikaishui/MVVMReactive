//
//  QSPParameterConfig.m
//  QSPNetworkingDemo
//
//  Created by QSP on 2017/9/13.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "QSPParameterConfig.h"

@implementation QSPParameterConfig

+ (instancetype)parameterConfigWithParameters:(NSDictionary *)parameters apiPath:(NSString *)apiPath cancelDependence:(id)cancelDependence controller:(UIViewController *)controller  completion:(CompletionBlock)completion
{
    return [[self alloc] initWithParameters:parameters apiPath:apiPath cancelDependence:cancelDependence controller:controller completion:completion];
}
- (instancetype)initWithParameters:(NSDictionary *)parameters apiPath:(NSString *)apiPath cancelDependence:(id)cancelDependence controller:(UIViewController *)controller  completion:(CompletionBlock)completion
{
    if (self = [super init]) {
        self.parameters = parameters;
        self.apiPath = apiPath;
        self.cancelDependence = cancelDependence;
        self.controller = controller;
        self.completion = completion;
        
        self.type = QSPNetworkingTypePOST;
        self.autoCancel = YES;
        self.showError = YES;
        self.showLoad = YES;
        self.executeConditionOfSuccess = YES;
    }
    
    return self;
}

@end
