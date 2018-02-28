//
//  SearchModel.h
//  MVVMExample
//
//  Created by QSP on 2018/2/24.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@protocol SearchDelegate <NSObject>

- (RACSignal *)searchSignal:(NSString *)searchText;
- (RACSignal *)logoutSignal:(NSString *)userName;
- (void)gotoLoginViewModel;

@end

@interface SearchServices : NSObject <SearchDelegate>

- (instancetype)initWithWindow:(UIWindow *)window;

@end
