//
//  AHContributionLiveCell.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/25.
//  Copyright © 2017年 AH. All rights reserved.
// 直播贡献榜cell

#import "AHContributionLiveCell.h"

@interface AHContributionLiveCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageViwe;
@property (weak, nonatomic) IBOutlet UILabel *contributeLb;
@property (weak, nonatomic) IBOutlet UILabel *ranking;

@end

@implementation AHContributionLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImageViwe.layer.cornerRadius = self.userImageViwe.height *0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
