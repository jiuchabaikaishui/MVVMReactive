//
//  QSPLoadConfig.h
//  VCHelper
//
//  Created by QSP on 2017/9/18.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSPNetworkingDefine.h"

@interface QSPLoadConfig : NSObject

@property (copy, nonatomic) LoadBlock loadBegin;
@property (copy, nonatomic) LoadBlock loadEnd;

+ (instancetype)loadConfigWithLoadBegin:(LoadBlock)loadBegin loadEnd:(LoadBlock)loadEnd;
- (instancetype)initWithLoadBegin:(LoadBlock)loadBegin loadEnd:(LoadBlock)loadEnd;

@end
