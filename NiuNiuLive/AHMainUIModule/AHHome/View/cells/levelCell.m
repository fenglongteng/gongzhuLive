//
//  levelCell.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "levelCell.h"

@implementation levelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUserLevelModel:(UserLevel *)userLevelModel{
    _levelLabel.text = [NSString stringWithFormat:@"%d",userLevelModel.level];
}
@end
