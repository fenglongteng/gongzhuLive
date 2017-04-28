//
//  AHContributionListOtherCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHContributionListOtherCell.h"

@implementation AHContributionListOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_headImageView addCornerRadius:22.5];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
