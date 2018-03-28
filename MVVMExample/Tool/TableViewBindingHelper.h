//
//  TableViewBindingHelper.h
//  MVVMExample
//
//  Created by QSP on 2018/3/21.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface TableViewBindingHelper : NSObject

+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                      sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)selection;

- (instancetype)initWithTableView:(UITableView *)tableView
                     sourceSignal:(RACSignal *)source
                 selectionCommand:(RACCommand *)selection;

@end
