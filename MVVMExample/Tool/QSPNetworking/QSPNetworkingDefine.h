//
//  QSPNetworkingDefine.h
//  QSPNetworkingDemo
//
//  Created by QSP on 2017/8/14.
//  Copyright © 2017年 QSP. All rights reserved.
//

#ifndef QSPNetworkingDefine_h
#define QSPNetworkingDefine_h
#import <UIKit/UIKit.h>

/**
 *  1.调试阶段，写代码调试错误，需要打印。(系统会自定义一个叫做DEBUG的宏)
 *  2.发布阶段，安装在用户设备上，不需要打印。(系统会删掉这个叫做DEBUG的宏)
 */
#if DEBUG
#define QSPNetworkingLog(FORMAT, ...)    fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String])
#else
#define QSPNetworkingLog(FORMAT, ...)
#endif

#define                 QSPNetworkingObject_arrayName           @"QSPNetworkingObject_array"
#define                 QSPNetworking_weakSelf                  __weak typeof(self) weakSelf = self;

//typedef void (^SuccessBlock)(id responseObject);
//typedef void (^FailureBlock)(NSError *error);
typedef BOOL (^ConditionOfSuccessBolck)(id responseObject);
typedef void (^CompletionBlock)(BOOL success, id responseObject, NSError *error);
typedef void (^ProgressBolck)(NSProgress * uploadProgress);

typedef void (^NetworkingErrorBlock)(NSError *error, UIViewController *controller);
typedef void (^DataErrorBlock)(id responseObject, UIViewController *controller);

typedef void (^LoadBlock)(UIViewController *controller);

typedef NS_ENUM(NSInteger, QSPNetworkingType){
    QSPNetworkingTypePOST = 0,
    QSPNetworkingTypeGET = 1
};

#endif /* QSPNetworkingDefine_h */
