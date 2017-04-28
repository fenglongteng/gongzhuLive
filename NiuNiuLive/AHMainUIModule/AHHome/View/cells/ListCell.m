//
//  ListCell.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.headImage.layer.borderWidth = 2.0f;
    self.headImage.layer.borderColor = BYColor(64, 152, 216).CGColor;
    self.headImage.layer.cornerRadius = self.headImage.width/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
