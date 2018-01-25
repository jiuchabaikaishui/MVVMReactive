//
//  QSPErrorConfig.h
//  VCHelper
//
//  Created by QSP on 2017/9/18.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSPNetworkingDefine.h"

@interface QSPErrorConfig : NSObject

/**
 网络错误提示（默认无）
 */
@property (copy, nonatomic) NetworkingErrorBlock networkingErrorPrompt;

/**
 数据错误提示（默认无）
 */
@property (copy, nonatomic) DataErrorBlock dataErrorPrompt;

+ (instancetype)errorConfigWithNetworkingErrorPrompt:(NetworkingErrorBlock)networkingErrorPrompt dataErrorPrompt:(DataErrorBlock)dataErrorPrompt;
- (instancetype)initWithNetworkingErrorPrompt:(NetworkingErrorBlock)networkingErrorPrompt dataErrorPrompt:(DataErrorBlock)dataErrorPrompt;

@end
