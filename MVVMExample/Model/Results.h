//
//  Results.h
//  MVVMExample
//
//  Created by QSP on 2018/3/30.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Results : NSObject

@property (strong, nonatomic, readonly) User *user;

+ (instancetype)resultWithUser:(User *)user;
- (instancetype)initWithUser:(User *)user;
- (RACSignal *)searchSignalWithContent:(NSString *)content page:(NSInteger)page andCount:(NSInteger)count;

@end
