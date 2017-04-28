//
//  AHAttentionCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHAttentionCell.h"
#import "UIView+ST.h"
#import "UIImage+extension.h"
@implementation AHAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //这里不完善要用切割图片的方法，这里暂时用这个看看效果而已
    [_headImageView  addCornerRadius:22.5];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setMeLikeUserInfoModel:(UsersGetMeLikeUserInfoResponse_MeLikeUser *)meLikeUserInfoModel{
    _meLikeUserInfoModel = meLikeUserInfoModel;
    self.nickNameLabel.text = meLikeUserInfoModel.nickName;
    [self.headImageView sd_setImageWithURL:[NSString getImageUrlString:meLikeUserInfoModel.avatar] placeholderImage:DefaultHeadImage];
    self.detailLabel.text = meLikeUserInfoModel.brief;
    UIImage *imageAttention =  meLikeUserInfoModel.state == 0?[UIImage imageNamed:@"btn_me_gz0"]:[UIImage imageNamed:@"btn_me_gz1"];
    [self.attentionBt setImage:imageAttention forState:UIControlStateNormal];
    UIImage *image = [UIImage  imageNamed:[NSString stringWithFormat:@"icon_grad%d",meLikeUserInfoModel.userLevel.level]];
    if (meLikeUserInfoModel.isToHao) {
        self.leftBottomImageView.hidden = NO;
        self.leftBottomImageView.image = image;
        self.rightBottomImageView.image = [UIImage imageNamed:@"icon_user_dhao0"];
    }else{
        self.leftBottomImageView.hidden = YES;
        self.rightBottomImageView.image = image;
    }
}

-(void)setLikeMeUserInfoModel:(UsersGetLikeMeUserInfoResponse_LikeMeUser *)likeMeUserInfoModel{
    _likeMeUserInfoModel = likeMeUserInfoModel;
    self.nickNameLabel.text = likeMeUserInfoModel.nickName;
    [self.headImageView sd_setImageWithURL:[NSString getImageUrlString:likeMeUserInfoModel.avatar] placeholderImage:DefaultHeadImage];
    UIImage *imageAttention =  likeMeUserInfoModel.state == 0?[UIImage imageNamed:@"btn_me_gz0"]:[UIImage imageNamed:@"btn_me_gz1"];
    [self.attentionBt setImage:imageAttention forState:UIControlStateNormal];
    self.detailLabel.text = likeMeUserInfoModel.brief;
    UIImage *image = [UIImage  imageNamed:[NSString stringWithFormat:@"icon_grad%d",likeMeUserInfoModel.userLevel.level]];
    if (likeMeUserInfoModel.isToHao) {
        self.leftBottomImageView.hidden = NO;
        self.leftBottomImageView.image = image;
        self.rightBottomImageView.image = [UIImage imageNamed:@"icon_user_dhao0"];
    }else{
        self.leftBottomImageView.hidden = YES;
        self.rightBottomImageView.image = image;
    }
}

- (IBAction)bt_changeAttentionStatus:(UIButton *)sender {
    if (self.specialAttentionBlock) {
        self.specialAttentionBlock(sender);
    }
    
}

@end
