//
//  NetworkingTool.m
//  MVVMExample
//
//  Created by QSP on 2018/2/24.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "NetworkingTool.h"

@implementation NetworkingTool

/**
 模拟一个post网络请求方法
 
 @param path 请求路径
 @param parameters 请求参数
 @param completion 请求完成回调
 */
+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(BOOL success, NSString *message, id responseObject)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([path isEqualToString:K_Service_Login]) {
            [NSThread sleepForTimeInterval:3];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([parameters[@"userName"] isEqualToString:@"Jiuchabaikaishui"]) {
                    if ([parameters[@"passWord"] isEqualToString:@"123456"]) {
                        completion(YES, @"请求成功", @{@"userName": parameters[@"userName"], @"passWord": parameters[@"passWord"], @"code": @(0), @"message": @"登录成功"});
                    } else {
                        completion(YES, @"请求成功", @{@"userName": parameters[@"userName"], @"passWord": parameters[@"passWord"], @"code": @(1), @"message": @"密码错误"});
                    }
                } else {
                    if ([parameters[@"userName"] isEqualToString:@"Jiuchabaikaishu"]) {//用账号Jiuchabaikaishu模拟网络请求失败
                        completion(NO, @"请求失败", nil);
                    } else {
                        completion(YES, @"请求成功", @{@"userName": parameters[@"userName"], @"passWord": parameters[@"passWord"], @"code": @(2), @"message": @"账号不存在"});
                    }
                }
            });
        }
        
        if ([path isEqualToString:K_Service_GetAllFriends]) {
            NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
            NSError *error = nil;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            [NSThread sleepForTimeInterval:3];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (completion) {
                        completion(NO, @"好友获取失败！", nil);
                    }
                } else {
                    if (completion) {
                        completion(YES, nil, arr);
                    }
                }
            });
        }
        if ([path isEqualToString:K_Service_SearchFriends]) {
            NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
            NSError *error = nil;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            [NSThread sleepForTimeInterval:3];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (completion) {
                        completion(NO, @"好友获取失败！", nil);
                    }
                } else {
                    if (arr.count > 0) {
                        if (completion) {
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF like '*%@*'", parameters[@"searchText"]]];//name beginswith[c] %@
                            NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:1];
                            for (NSDictionary *dic in arr) {
                                if ([predicate evaluateWithObject:dic[@"name"]] || [predicate evaluateWithObject:[dic[@"uin"] stringValue]]) {
                                    [mArr addObject:dic];
                                }
                            }
                            completion(YES, nil, [NSArray arrayWithArray:mArr]);
                        }
                    } else {
                        if (completion) {
                            completion(NO, @"未搜索到好友！", nil);
                        }
                    }
                }
            });
        }
    });
}

@end
