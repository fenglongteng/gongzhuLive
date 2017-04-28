//
//  redPacketCell.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "redPacketCell.h"
#import "NSString+Tool.h"

@interface redPacketCell()
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageV;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UILabel *redGoldLb;

@end

@implementation redPacketCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)setRedPackResList:(GetGrabRedPackagesResultResponse_GrabRedPackagesResult *)redPackResList{
    _redPackResList = redPackResList;
    self.userNickName.text = redPackResList.nickName;
    self.redGoldLb.text = [NSString stringWithFormat:@"%lld",redPackResList.goldCoins] ;
    [self.userHeadImageV sd_setImageWithURL:[NSString getImageUrlString:redPackResList.avatar] placeholderImage:[UIImage imageNamed:@"logo_500.jpg"]];
}

@end
