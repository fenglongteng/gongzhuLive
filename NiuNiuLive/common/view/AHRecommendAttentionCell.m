//
//  AHRecommendAttentionCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHRecommendAttentionCell.h"

@implementation AHRecommendAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_sexImageView addCornerRadius:22.5];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)bt_attentionAcion:(UIButton *)sender {
    if (self.attentionBlock) {
        self.attentionBlock(self.index.row,sender);
    }
}

-(void)setOldModel:(id)oldModel{
    FindUser *user = oldModel;
    [_headImageView sd_setImageWithURL:[NSURL URLWithPercentEncodingString:user.avatar] placeholderImage:ImageNamed(image_user_def)];
    _nickNameLabel.text = user.nickName;
    _detailLabel.text = user.brief;
    if (user.gender == 1) {
        _sexImageView.image = [UIImage imageNamed:@"icon_weiwei_woman"];
    }else if (user.gender == 2){
        _sexImageView.image =  [UIImage imageNamed:@"icon_weiwei_man"];
    }
 
   
}


@end
