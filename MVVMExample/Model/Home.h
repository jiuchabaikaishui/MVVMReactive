//
//  Home.h
//  MVVMExample
//
//  Created by QSP on 2018/3/29.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Home : NSObject

@property (strong, nonatomic, readonly) User *user;

+ (instancetype)homeWithUser:(User *)user;
- (instancetype)initWithUser:(User *)user;

- (RACSignal *)friendSignalWithPage:(NSInteger)page andCount:(NSInteger)count;
- (RACSignal *)searchSignalWithContent:(NSString *)content page:(NSInteger)page andCount:(NSInteger)count;

@end
