//
//  focusCell.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "focusCell.h"

@implementation focusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImage.layer.cornerRadius = self.headImage.bounds.size.height/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
