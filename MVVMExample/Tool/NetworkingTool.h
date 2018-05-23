//
//  NetworkingTool.h
//  MVVMExample
//
//  Created by QSP on 2018/2/24.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_Service_Login                                     @"https://www.qsp/login"
#define K_Service_Logout                                    @"https://www.qsp/logout"
#define K_Service_GetAllFriends                             @"https://www.qsp/getAllFriends"
#define K_Service_PageFriends                               @"https://www.qsp/pageFriends"
#define K_Service_SearchFriends                             @"https://www.qsp/searchFriends"

@interface NetworkingTool : NSObject
/**
 模拟一个post网络请求方法
 
 @param path 请求路径
 @param parameters 请求参数
 @param completion 请求完成回调
 */
+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(BOOL success, NSString *message, id responseObject)) completion;

@end
