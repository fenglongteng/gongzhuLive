//
//  AHReportListCell.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPersonModel.h"
typedef void (^Invitation) (PPPersonModel*);
@interface AHReportListCell : UITableViewCell

/**
 要求或者关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 详情
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/**
 邀请按钮block回调
 */
@property(nonatomic,copy)Invitation invitationBlock;

/**
 联系人模型
 */
@property(nonatomic,strong) PPPersonModel *people;
@end
