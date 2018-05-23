//
//  FriendTableViewCell.m
//  MVVMExample
//
//  Created by QSP on 2018/3/21.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "FriendTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

#define K_Spcing            8.0

@interface FriendTableViewCell ()

//@property (weak, nonatomic) UIView *backView;
//@property (weak, nonatomic) UIImageView *iconImageView;
//@property (weak, nonatomic) UILabel *nameLabel;
//@property (weak, nonatomic) UILabel *numLabel;

@end

@implementation FriendTableViewCell

+ (instancetype)friendCell:(UITableView *)tableView viewModel:(FriendCellViewModel *)viewModel {
    static NSString *identifier = @"FriendTableViewCell";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    [cell bindViewModel:viewModel];
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
//        UIView *view = [[UIView alloc] init];
//        [self.contentView addSubview:view];
//        self.backView = view;
//
//        UIImageView *imageView = [[UIImageView alloc] init];
//        [self.backView addSubview:imageView];
//        self.iconImageView = imageView;
//
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:16];
//        label.textColor = [UIColor blackColor];
//        label.textAlignment = NSTextAlignmentLeft;
//        [self.backView addSubview:label];
//        self.nameLabel = label;
//
//        label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = [UIColor darkGrayColor];
//        label.textAlignment = NSTextAlignmentLeft;
//        [self.backView addSubview:label];
//        self.numLabel = label;
//
//        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView);
//            make.top.equalTo(self.contentView);
//            make.right.equalTo(self.contentView);
//            make.bottom.equalTo(self.contentView);
//        }];
//        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.backView).offset(K_Spcing);
//            make.top.equalTo(self.backView);
//            make.bottom.equalTo(self.backView);
//            make.width.equalTo(self.iconImageView.mas_height);
//        }];
//        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.iconImageView.mas_right).offset(K_Spcing);
//            make.top.equalTo(self.backView);
//            make.right.equalTo(self.backView).offset(-K_Spcing);
//            make.bottom.equalTo(self.numLabel.mas_top);
//        }];
//        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.iconImageView.mas_right).offset(K_Spcing);
//            make.right.equalTo(self.backView).offset(-K_Spcing);
//            make.bottom.equalTo(self.backView);
//            make.height.equalTo(self.nameLabel);
//        }];
    }
    
    return self;
}
- (void)bindViewModel:(FriendCellViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.textLabel.text = self.viewModel.friendModel.name;
    self.detailTextLabel.text = self.viewModel.friendModel.uin;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.friendModel.img] placeholderImage:[UIImage imageNamed:@"50"]];
    
//    self.nameLabel.text = self.viewModel.friendModel.name;
//    self.numLabel.text = self.viewModel.friendModel.uin;
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.friendModel.img] placeholderImage:[UIImage imageNamed:@"50"]];
}
//- (void)setParallax:(CGFloat)parallax {
//    self.backView.transform = CGAffineTransformMakeTranslation(0, parallax);
//}

@end
