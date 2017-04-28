//
//  AHMessageCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/29.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"
#import "AHMessageModel.h"
@interface AHMessageCell : AHBaseTableViewCell

/**
 用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 消息message
 */
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic)AHMessageModel *messageModel;

@end
