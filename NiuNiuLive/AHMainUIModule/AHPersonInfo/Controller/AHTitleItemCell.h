//
//  AHTitleItemCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"

@interface AHTitleItemCell : AHBaseTableViewCell
//title的左边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftConstraint;
//标题label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabel;
//副标题label
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;

@end
