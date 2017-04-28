//
//  AHHeaderViewOfTableView.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHHeaderViewOfTableView : UIView
//顶部Label
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//右边上按钮button
@property (weak, nonatomic) IBOutlet UIButton *rightTopButton;
//右下按钮
@property (weak, nonatomic) IBOutlet UIButton *rightBottomBt;
//简介label
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
//UserId
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
//性别 星座 地址
@property (weak, nonatomic) IBOutlet UILabel *detaiInfoLabel;

/**
头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

/**
顶部试图集合
 */
@property (weak, nonatomic) IBOutlet UIView *topView;

/**
 底部试图集合
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;


/**
 用户信息
 */
@property(nonatomic,strong)AHPersonInfoModel*infoModel;

/**
 用户userid
 */
@property(nonatomic,strong)NSString *showId;
@end
