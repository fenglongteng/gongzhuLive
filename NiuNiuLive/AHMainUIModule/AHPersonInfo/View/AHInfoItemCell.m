//
//  AHInfoItemCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHInfoItemCell.h"

@implementation AHInfoItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)bt_rightAction:(id)sender {
    if (self.rightButtonAction) {
        self.rightButtonAction();
    }
}
- (IBAction)bt_leftAction:(id)sender {
    if (self.leftButtonAction) {
        self.leftButtonAction();
    }
}

@end
