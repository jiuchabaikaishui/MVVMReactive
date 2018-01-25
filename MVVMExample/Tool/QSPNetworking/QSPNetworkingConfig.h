//
//  QSPNetworkingConfig.h
//  QSPNetworkingDemo
//
//  Created by QSP on 2017/9/13.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface QSPNetworkingConfig : NSObject

/**
 超时时间
 */
@property (assign, nonatomic) NSTimeInterval timeoutInterval;

/**
 服务器地址
 */
@property (copy, nonatomic) NSString *basePath;

/**
 验证模式
 */
@property (nonatomic, assign) AFSSLPinningMode SSLPinningMode;

/**
 本地绑定的证书
 */
@property (nonatomic, strong) NSSet <NSData *> *pinnedCertificates;

/**
 是否允许无效证书
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 是否验证域名
 */
@property (nonatomic, assign) BOOL validatesDomainName;

/**
 数据解析格式
 */
@property (copy, nonatomic) NSSet<NSString *> *acceptableContentTypes;

/**
 请求头设置字典
 */
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *HTTPHeaderDictionary;

/**
 以默认值创建一个配置实例

 @param basePath 服务器地址
 */
+ (instancetype)networkingConfigWithBasePath:(NSString *)basePath;

@end
