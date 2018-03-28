//
//  FriendTableViewCell.h
//  MVVMExample
//
//  Created by QSP on 2018/3/21.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCellViewModel.h"

@interface FriendTableViewCell : UITableViewCell

@property (strong, nonatomic) FriendCellViewModel *viewModel;

+ (instancetype)friendCell:(UITableView *)tableView viewModel:(FriendCellViewModel *)viewModel;
- (void)setParallax:(CGFloat)parallax;

@end
