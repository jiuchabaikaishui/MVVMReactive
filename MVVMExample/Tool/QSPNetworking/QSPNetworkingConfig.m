//
//  QSPNetworkingConfig.m
//  QSPNetworkingDemo
//
//  Created by QSP on 2017/9/13.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "QSPNetworkingConfig.h"

@implementation QSPNetworkingConfig

+ (instancetype)networkingConfigWithBasePath:(NSString *)basePath
{
    QSPNetworkingConfig *config = [[QSPNetworkingConfig alloc] init];
    config.basePath = basePath;
    
    config.timeoutInterval = 15;
    config.SSLPinningMode = AFSSLPinningModeNone;
    config.allowInvalidCertificates = YES;
    config.validatesDomainName = NO;
    
    config.acceptableContentTypes = [NSSet setWithObjects:@"application/json",  @"text/json", @"text/javascript",@"text/html", nil];
    config.HTTPHeaderDictionary = [NSDictionary dictionaryWithObject:@"ios" forKey:@"request-type"];
    
    return config;
}

@end
