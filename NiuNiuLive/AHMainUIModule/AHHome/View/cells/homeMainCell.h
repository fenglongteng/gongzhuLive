//
//  homeMainCell.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rooms.pbobjc.h"

@interface homeMainCell : UITableViewCell
/*
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/*
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
/*
 *  人气标签
 */
@property (weak, nonatomic) IBOutlet UILabel *sentimentLbl;
/*
 *  游戏中或者直播中贴图
 */
@property (weak, nonatomic) IBOutlet UIImageView *InGame;
/*
 * 背景底图
 */
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
//标签
@property (weak, nonatomic) IBOutlet UILabel *labelText;
//城市名
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

//是否显示距离
@property (assign, nonatomic) BOOL isLocation;
@property (weak, nonatomic) IBOutlet UILabel *locatDisanceLb;//距离

@property (weak, nonatomic) IBOutlet UIView *locationView;

- (void)setHomeCell:(Room *)room;

@end
