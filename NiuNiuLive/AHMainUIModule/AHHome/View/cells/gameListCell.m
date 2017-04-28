//
//  gameListCell.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "gameListCell.h"

@implementation gameListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.readLbl.layer.cornerRadius = 10.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGameInfo:(GameItem *)gameInfo{
    
}

@end
