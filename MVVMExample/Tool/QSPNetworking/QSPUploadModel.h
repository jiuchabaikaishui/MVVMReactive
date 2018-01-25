//
//  QSPUploadModel.h
//  VCHelper
//
//  Created by QSP on 2017/9/19.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSPUploadModel : NSObject

@property (copy, nonatomic) NSData *data;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *mimeType;

+ (instancetype)uploadModelWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;
- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
