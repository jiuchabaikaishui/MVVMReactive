//
//  QSPNetworkingManager.h
//  QSPNetworkingDemo
//
//  Created by QSP on 2017/8/14.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSPNetworkingDefine.h"
#import "QSPParameterConfig.h"
#import "QSPErrorConfig.h"
#import "QSPLoadConfig.h"

@class QSPNetworkingObject;
@interface QSPNetworkingManager : NSObject

/**
 配置对象
 */
@property (strong, nonatomic) QSPNetworkingConfig *config;

/**
 错误配置对象
 */
@property (strong, nonatomic) QSPErrorConfig *errorConfig;

/**
 加载配置对象
 */
@property (strong, nonatomic) QSPLoadConfig *loadConfig;

/**
 成功的条件（如果不设置，只要网络请求成功，就认为是成功）
 */
@property (copy, nonatomic) ConditionOfSuccessBolck conditionOfSuccess;

/**
 配置框架
 
 @param networkingConfig 网络配置
 @param errorConfig 错误配置
 @param loadConfig 加载配置
 @param condictionOfSuccess 成功的条件（如果不设置，只要网络请求成功，就认为是成功）
 */
+ (void)configWithNetworkingConfig:(QSPNetworkingConfig *)networkingConfig errorConfig:(QSPErrorConfig *)errorConfig loadConfig:(QSPLoadConfig *)loadConfig condictionOfSuccess:(ConditionOfSuccessBolck)condictionOfSuccess;

/**
 单例方法
 */
+ (instancetype)manager;

/**
 默认调用

 @param apiPath api
 @param parameters 参数
 @param dependence 依赖对象
 @param completion 完成的回调
 @return NSURLSessionTask对象
 */
+ (NSURLSessionTask *)defaultCall:(NSString *)apiPath parameters:(NSDictionary *)parameters   cancelDependence:(id)dependence controller:(UIViewController *)controller completion:(CompletionBlock)completion;

/**
 使用配置对象调用

 @param parameterConfig 配置对象
 @return NSURLSessionTask对象
 */
+ (NSURLSessionTask *)callWithParameterConfig:(QSPParameterConfig *)parameterConfig;

/**
 取消网络请求

 @param task 网络任务
 */
+ (void)cancelWithTask:(NSURLSessionTask *)task;

@end


/**
 网络请求对象
 */
@interface QSPNetworkingObject : NSObject

@property (strong, nonatomic, readonly) NSURLSessionTask *task;

+ (instancetype)networkingObjectWithTask:(NSURLSessionTask *)task autoCancel:(BOOL)autoCancel;
- (instancetype)initWithTask:(NSURLSessionTask *)task autoCancel:(BOOL)autoCancel;

/**
 取消请求
 */
- (void)cancel;

@end
