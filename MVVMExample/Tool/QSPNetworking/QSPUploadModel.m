//
//  QSPUploadModel.m
//  VCHelper
//
//  Created by QSP on 2017/9/19.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "QSPUploadModel.h"

@implementation QSPUploadModel

+ (instancetype)uploadModelWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    return [[self alloc] initWithData:data name:name fileName:fileName mimeType:mimeType];
}
- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    if (self = [super init]) {
        self.data = data;
        self.name = name;
        self.fileName = fileName;
        self.mimeType = mimeType;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"p: %p, fileName: %@", &self, self.fileName];
}

@end
