//
//  AHAttentionCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"
typedef void (^SpecialAttentionBlock)(UIButton*);
@interface AHAttentionCell : AHBaseTableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//简介
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
//坐下家图片
@property (weak, nonatomic) IBOutlet UIImageView *leftBottomImageView;
//右下角图片
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;

/**
 关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *attentionBt;

//特别关注回调
@property(nonatomic,copy)SpecialAttentionBlock specialAttentionBlock;

@property(nonatomic,strong)UsersGetMeLikeUserInfoResponse_MeLikeUser *meLikeUserInfoModel;
@property(nonatomic,strong)UsersGetLikeMeUserInfoResponse_LikeMeUser * likeMeUserInfoModel;
@end
