//
//  AHTaskItemCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"

@interface AHTaskItemCell : AHBaseTableViewCell

/**
 签到bt
 */
@property (weak, nonatomic) IBOutlet UIButton *signInBt;

/**
 签到小红点
 */
@property (weak, nonatomic) IBOutlet UIView *signRedot;

/**
 任务中心bt
 */
@property (weak, nonatomic) IBOutlet UIButton *taskCenterBt;

/**
 任务中心小红点
 */
@property (weak, nonatomic) IBOutlet UIView *taskRedot;

/**
 等级
 */
@property (weak, nonatomic) IBOutlet UIButton *MyGradeBt;

/**
 等级小红点
 */
@property (weak, nonatomic) IBOutlet UIView *gradeRedot;

//签到信息
@property (strong, nonatomic)UsersGetSignedInInfoResponse *signedInInfoResponse;

-(void)setUpView;
@end
