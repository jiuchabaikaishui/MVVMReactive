//
//  QSPParameterConfig.h
//  QSPNetworkingDemo
//
//  Created by QSP on 2017/9/13.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSPNetworkingDefine.h"
#import "QSPNetworkingConfig.h"
#import "QSPErrorConfig.h"
#import "QSPLoadConfig.h"
#import "QSPUploadModel.h"

@interface QSPParameterConfig : NSObject

/**
 请求参数
 */
@property (copy, nonatomic) NSDictionary *parameters;

/**
 请求类型（默认为POST）
 */
@property (assign, nonatomic) QSPNetworkingType type;

/**
 上传文件数组
 */
@property (copy, nonatomic) NSArray<QSPUploadModel *> *uploadModels;

/**
 请求api
 */
@property (copy, nonatomic) NSString *apiPath;

/**
 是否自动取消
 */
@property (assign, nonatomic) BOOL autoCancel;

/**
 自动取消操作的依赖对象（此对象一销毁，就执行取消操作，所以autoCancel设置为YES的时候必须设置此参数）
 */
@property (weak, nonatomic) id cancelDependence;

/**
 网络请求发生的控制器
 */
@property (weak, nonatomic) UIViewController *controller;

/**
 是否处理错误
 */
@property (assign, nonatomic) BOOL showError;

/**
 是否显示加载
 */
@property (assign, nonatomic) BOOL showLoad;

/**
 是否执行成功的条件(默认为YES，如果为NO，只要网络请求成功就表示成功)
 */
@property (assign, nonatomic) BOOL executeConditionOfSuccess;

/**
 网络配置对象
 */
@property (strong, nonatomic) QSPNetworkingConfig *networkingConfig;

/**
 错误配置对象
 */
@property (strong, nonatomic) QSPErrorConfig *errorConfig;

/**
 加载配置对象
 */
@property (strong, nonatomic) QSPLoadConfig *lodaConfig;

/**
 进度回调
 */
@property (copy, nonatomic) ProgressBolck progress;

/**
 请求完成回调
 */
@property (copy, nonatomic) CompletionBlock completion;

+ (instancetype)parameterConfigWithParameters:(NSDictionary *)parameters apiPath:(NSString *)apiPath cancelDependence:(id)cancelDependence controller:(UIViewController *)controller completion:(CompletionBlock)completion;
- (instancetype)initWithParameters:(NSDictionary *)parameters apiPath:(NSString *)apiPath cancelDependence:(id)cancelDependence controller:(UIViewController *)controller completion:(CompletionBlock)completion;

@end
