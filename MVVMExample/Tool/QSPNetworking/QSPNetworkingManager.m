//
//  QSPNetworkingManager.m
//  QSPNetworkingDemo
//
//  Created by QSP on 2017/8/14.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "QSPNetworkingManager.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <objc/runtime.h>

static QSPNetworkingManager *_shareInstance;

@interface QSPNetworkingManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation QSPNetworkingManager
@synthesize config = _config;

- (QSPNetworkingConfig *)config
{
    if (_config == nil) {
        _config = [QSPNetworkingConfig networkingConfigWithBasePath:nil];
    }
    
    return _config;
}
- (void)setConfig:(QSPNetworkingConfig *)config
{
    _config = config;
    self.sessionManager = [self sessionManagerWithNetworkingConfig:config];
}
- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [self sessionManagerWithNetworkingConfig:self.config];
    }
    
    return _sessionManager;
}
- (AFHTTPSessionManager *)sessionManagerWithNetworkingConfig:(QSPNetworkingConfig *)config
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:config.basePath]];
    sessionManager.requestSerializer.timeoutInterval = config.timeoutInterval;
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    sessionManager.responseSerializer = serializer;
    [config.HTTPHeaderDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [sessionManager.requestSerializer setValue:key forHTTPHeaderField:obj];
    }];
    sessionManager.responseSerializer.acceptableContentTypes = config.acceptableContentTypes;
    sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:config.SSLPinningMode];
    sessionManager.securityPolicy.allowInvalidCertificates = config.allowInvalidCertificates;//忽略https证书
    sessionManager.securityPolicy.validatesDomainName = config.validatesDomainName;//是否验证域名
    
    return sessionManager;
}

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    
    return _shareInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [super allocWithZone:zone];
    });
    
    return _shareInstance;
}

+ (void)configWithNetworkingConfig:(QSPNetworkingConfig *)networkingConfig errorConfig:(QSPErrorConfig *)errorConfig loadConfig:(QSPLoadConfig *)loadConfig condictionOfSuccess:(ConditionOfSuccessBolck)condictionOfSuccess
{
    QSPNetworkingManager *manager = [self manager];
    manager.config = networkingConfig;
    manager.errorConfig = errorConfig;
    manager.loadConfig = loadConfig;
    manager.conditionOfSuccess = condictionOfSuccess;
}
+ (NSURLSessionTask *)defaultCall:(NSString *)apiPath parameters:(NSDictionary *)parameters cancelDependence:(id)dependence controller:(UIViewController *)controller completion:(CompletionBlock)completion
{
    QSPParameterConfig *parameterConfig = [QSPParameterConfig parameterConfigWithParameters:parameters apiPath:apiPath cancelDependence:dependence controller:controller completion:completion];
    return [self callWithParameterConfig:parameterConfig];
}
+ (NSURLSessionTask *)callWithParameterConfig:(QSPParameterConfig *)config
{
    return [[self manager] callWithParameterConfig:config];
}
- (NSURLSessionDataTask * _Nullable)extracted:(QSPParameterConfig *)parameterConfig sessionManager:(AFHTTPSessionManager *)sessionManager weakSelf:(QSPNetworkingManager *const __weak)weakSelf {
    return [sessionManager POST:parameterConfig.apiPath parameters:parameterConfig.parameters constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        for (QSPUploadModel *uploadModel in parameterConfig.uploadModels) {
            [formData appendPartWithFileData:uploadModel.data name:uploadModel.name fileName:uploadModel.fileName mimeType:uploadModel.mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (parameterConfig.progress) {
            parameterConfig.progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf susseccWithParameterConfig:parameterConfig task:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf failureWithParameterConfig:parameterConfig task:task error:error];
    }];
}

- (NSURLSessionTask *)callWithParameterConfig:(QSPParameterConfig *)parameterConfig
{
    AFHTTPSessionManager *sessionManager = parameterConfig.networkingConfig ? [self sessionManagerWithNetworkingConfig:parameterConfig.networkingConfig] : self.sessionManager;
    [self showLoad:parameterConfig];
    QSPNetworking_weakSelf
    if (parameterConfig.type == QSPNetworkingTypeGET) {
        NSURLSessionTask *task = [sessionManager GET:parameterConfig.apiPath parameters:parameterConfig.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            if (parameterConfig.progress) {
                parameterConfig.progress(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf susseccWithParameterConfig:parameterConfig task:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf failureWithParameterConfig:parameterConfig task:task error:error];
        }];
        
        [self addDependence:parameterConfig andTask:task];
        return task;
    }
    else
    {
        NSURLSessionDataTask *task = [self extracted:parameterConfig sessionManager:sessionManager weakSelf:weakSelf];
        
        [self addDependence:parameterConfig andTask:task];
        return task;
    }
}

+ (void)cancelWithTask:(NSURLSessionTask *)task;
{
    if (task.state != NSURLSessionTaskStateCompleted && task.state != NSURLSessionTaskStateCanceling) {
        [task cancel];
    }
}

- (void)susseccWithParameterConfig:(QSPParameterConfig *)parameterConfig task:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    QSPNetworkingLog(@"\n接口地址：%@\n接口参数：%@\n上传文件：%@\n接口返回：%@", task.currentRequest.URL.absoluteString, parameterConfig.parameters, parameterConfig.uploadModels, responseObject);
    
    [self removeDependence:parameterConfig andTask:task];
    [self removeLoad:parameterConfig];
    
    if (parameterConfig.showError) {
        QSPErrorConfig *errorConfig = parameterConfig.errorConfig ? parameterConfig.errorConfig : self.errorConfig;
        if (errorConfig.dataErrorPrompt) {
            errorConfig.dataErrorPrompt(responseObject, parameterConfig.controller);
        }
    }
    
    if (parameterConfig.executeConditionOfSuccess) {
        if (self.conditionOfSuccess) {
            if (self.conditionOfSuccess(responseObject)) {
                if (parameterConfig.completion) {
                    parameterConfig.completion(YES, responseObject, nil);
                }
            }
            else
            {
                if (parameterConfig.completion) {
                    parameterConfig.completion(NO, responseObject, nil);
                }
            }
        }
        else
        {
            if (parameterConfig.completion) {
                parameterConfig.completion(YES, responseObject, nil);
            }
        }
    }
    else
    {
        if (parameterConfig.completion) {
            parameterConfig.completion(YES, responseObject, nil);
        }
    }
}
- (void)failureWithParameterConfig:(QSPParameterConfig *)parameterConfig task:(NSURLSessionDataTask *)task error:(NSError *)error
{
    QSPNetworkingLog(@"\n接口地址：%@\n接口参数：%@\n上传文件：%@\n\n错误信息：%@", task.currentRequest.URL.absoluteString, parameterConfig.parameters, parameterConfig.uploadModels, error);
    
    [self removeDependence:parameterConfig andTask:task];
    [self removeLoad:parameterConfig];
    
    if (parameterConfig.showError) {
        QSPErrorConfig *errorConfig = parameterConfig.errorConfig ? parameterConfig.errorConfig : self.errorConfig;
        if (errorConfig.networkingErrorPrompt) {
            errorConfig.networkingErrorPrompt(error, parameterConfig.controller);
        }
    }
    
    if (parameterConfig.completion) {
        parameterConfig.completion(NO, nil, error);
    }
}

/**
 添加依赖
 */
- (QSPNetworkingObject *)addDependence:(QSPParameterConfig *)parameterConfig andTask:(NSURLSessionTask *)task
{
    if (task) {
        QSPNetworkingObject *obj = [QSPNetworkingObject networkingObjectWithTask:task autoCancel:(parameterConfig.autoCancel && parameterConfig.cancelDependence) ? YES : NO];
        
        if (parameterConfig.autoCancel && parameterConfig.cancelDependence) {
            NSMutableArray *networkingObjects = objc_getAssociatedObject(parameterConfig.cancelDependence, QSPNetworkingObject_arrayName);
            if (networkingObjects == nil) {
                networkingObjects = [NSMutableArray arrayWithCapacity:1];
                objc_setAssociatedObject(parameterConfig.cancelDependence, QSPNetworkingObject_arrayName, networkingObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            
            if (obj) {
                [networkingObjects addObject:obj];
            }
        }
        
        return obj;
    }
    else
    {
        return nil;
    }
}

/**
 移除依赖
 */
- (void)removeDependence:(QSPParameterConfig *)parameterConfig andTask:(NSURLSessionTask *)task
{
    if (parameterConfig.autoCancel && parameterConfig.cancelDependence && task) {
        NSMutableArray *networkingObjects = objc_getAssociatedObject(parameterConfig.cancelDependence, QSPNetworkingObject_arrayName);
        if (networkingObjects) {
            QSPNetworkingObject *netObj;
            for (QSPNetworkingObject *obj in networkingObjects) {
                if (obj.task == task) {
                    netObj = obj;
                    break;
                }
            }
            [networkingObjects removeObject:netObj];
        }
    }
}

/**
 显示加载动画
 */
- (void)showLoad:(QSPParameterConfig *)parameterConfig
{
    if (parameterConfig.showLoad) {
        QSPLoadConfig *loadConfig = parameterConfig.lodaConfig ? parameterConfig.lodaConfig : self.loadConfig;
        if (loadConfig.loadBegin) {
            loadConfig.loadBegin(parameterConfig.controller);
        }
    }
}

/**
 移除加载动画
 */
- (void)removeLoad:(QSPParameterConfig *)parameterConfig
{
    if (parameterConfig.showLoad) {
        QSPLoadConfig *loadConfig = parameterConfig.lodaConfig ? parameterConfig.lodaConfig : self.loadConfig;
        if (loadConfig.loadEnd) {
            loadConfig.loadEnd(parameterConfig.controller);
        }
    }
}


@end

@interface QSPNetworkingObject ()

@property (assign, nonatomic, readonly) BOOL autoCancel;

@end

@implementation QSPNetworkingObject

- (void)dealloc
{
//    QSPNetworkingLog(@"%@取消啦---------------------------------------------------", self.task.currentRequest.URL.absoluteString);
    if (self.autoCancel) {
        [self cancel];
    }
}

+ (instancetype)networkingObjectWithTask:(NSURLSessionTask *)task autoCancel:(BOOL)autoCancel
{
    return [[self alloc] initWithTask:task autoCancel:autoCancel];
}
- (instancetype)initWithTask:(NSURLSessionTask *)task autoCancel:(BOOL)autoCancel
{
    if (self = [super init]) {
        _task = task;
        _autoCancel = autoCancel;
    }
    
    return self;
}
- (void)cancel
{
//    QSPNetworkingLog(@"---------------------------------------------------%@%zi", self.task.currentRequest.URL.absoluteString, self.task.state);
    if (self.task.state != NSURLSessionTaskStateCompleted && self.task.state != NSURLSessionTaskStateCanceling) {
        QSPNetworkingLog(@"---------------------------------------------------%@取消啦", self.task.currentRequest.URL.absoluteString);
        [self.task cancel];
    }
}

@end
