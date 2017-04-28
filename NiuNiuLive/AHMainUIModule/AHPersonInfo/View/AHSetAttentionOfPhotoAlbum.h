//
//  AHSetAttentionOfPhotoAlbum.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AHSetAttentionOfPhotoAlbum : UIView

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 简介
 */
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;

/**
 关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *attentionBt;


/**
 用户信息
 */
@property (nonatomic,strong)AHPersonInfoModel *infoModel;

@end
