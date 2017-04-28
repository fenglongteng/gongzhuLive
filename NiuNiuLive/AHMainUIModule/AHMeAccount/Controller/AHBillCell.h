//
//  AHBillCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/30.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"
#import "Accounts.pbobjc.h"
@interface AHBillCell : AHBaseTableViewCell
//钱详情
@property (weak, nonatomic) IBOutlet UILabel *moneyDetailLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//钱数量
@property (weak, nonatomic) IBOutlet UILabel *moneyNumberLabel;
//交易model
@property(nonatomic,strong)AccountsLogResponse_AccountsLog *logModel;
@end
