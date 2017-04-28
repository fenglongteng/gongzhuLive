//
//  AHRecommendAttentionCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"
#import "Users.pbobjc.h"
typedef void (^AttentionBlock)(NSInteger ,UIButton*);

@interface AHRecommendAttentionCell : AHBaseTableViewCell

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 简介详情
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/**
 性别图片 高亮男 默认正常 女
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

/**
 选中按钮 默认不选中 
 */
@property (weak, nonatomic) IBOutlet UIButton *seletBt;

/**
 关注block
 */
@property(nonatomic,copy)AttentionBlock attentionBlock;

/**
 位置
 */
@property(nonatomic,strong)NSIndexPath *index;
@end
