//
//  NetworkingTool.m
//  MVVMExample
//
//  Created by QSP on 2018/2/24.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "NetworkingTool.h"
#import <UIKit/UIKit.h>
#import "FMDB.h"

//数据库路径
#define K_DatabaseQueue_Path                [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"FriendDatabase.sqlite"]
//好友表名
#define K_Friend_TableName                  @"t_friend"

@implementation NetworkingTool
static FMDatabaseQueue *_databaseQueue;

+ (void)initialize {
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:K_DatabaseQueue_Path];
    [_databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@;", K_Friend_TableName]]) {
            NSLog(@"Friend表删除成功")
        } else {
            NSLog(@"Friend表删除失败")
        }
        if ([db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (uin integer PRIMARY KEY, name text NOT NULL, index integer not null, chang_pos integer, score integer, special_flag integer, uncare_flag integer, img text);", K_Friend_TableName]]) {
            NSLog(@"Friend表创建成功");
            
            FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT count(*) FROM %@;", K_Friend_TableName]];
            [set next];
            int count = [set intForColumnIndex:0];
            if (count == 0) {
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
                NSError *error = nil;
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                for (NSDictionary *dic in arr) {
                    if (![db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (uin, name, index, chang_pos, score, special_flag, uncare_flag, img) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", K_Friend_TableName], dic[@"uin"], dic[@"name"], dic[@"index"], dic[@"chang_pos"], dic[@"score"], dic[@"special_flag"], dic[@"uncare_flag"], dic[@"img"]]) {
                        NSLog(@"好友数据插入失败: %@", dic);
                    }
                }
            }
        } else {
            NSLog(@"Friend表创建失败");
        }
    }];
}
/**
 模拟一个post网络请求方法
 
 @param path 请求路径
 @param parameters 请求参数
 @param completion 请求完成回调
 */
+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(BOOL success, NSString *message, id responseObject)) completion {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if ([path isEqualToString:K_Service_Login]) {
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
            }
            if ([path isEqualToString:K_Service_Logout]) {
                if ([parameters[@"userName"] isEqualToString:@"Jiuchabaikaishui"]) {
                    completion(YES, @"请求成功", @{@"userName": parameters[@"userName"], @"code": @(0), @"message": @"退出成功"});
                } else {
                    if ([parameters[@"userName"] isEqualToString:@"Jiuchabaikaishu"]) {//用账号Jiuchabaikaishu模拟网络请求失败
                        completion(NO, @"请求失败", nil);
                    } else {
                        completion(YES, @"请求成功", @{@"userName": parameters[@"userName"], @"code": @(1), @"message": @"退出失败"});
                    }
                }
            }
            if ([path isEqualToString:K_Service_GetAllFriends]) {
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
                NSError *error = nil;
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                if (error) {
                    if (completion) {
                        completion(NO, @"好友获取失败！", nil);
                    }
                } else {
                    if (completion) {
                        completion(YES, nil, arr);
                    }
                }
            }
            if ([path isEqualToString:K_Service_SearchFriends]) {
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
                NSError *error = nil;
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
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
            }
        });
    });
}

@end
