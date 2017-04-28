//
//  AHBillCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/30.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBillCell.h"
#import "NSObject+AHUntil.h"
@implementation AHBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setLogModel:(AccountsLogResponse_AccountsLog *)logModel{
    _logModel = logModel;
    _timeLabel.text = [NSObject getTimeStringWithTimeStamp:logModel.createTimestamp];
    NSString *type = nil;
    switch (logModel.modifyType) {
        case AccountsLogResponse_AccountsLog_ModifyType_Transfer:
        {
            type = @"转账";
        }
            break;
        case AccountsLogResponse_AccountsLog_ModifyType_RedPackage:
        {
            type = @"红包";
        }
            break;
        case AccountsLogResponse_AccountsLog_ModifyType_FlowText:
        {
            type = @"弹幕";
        }
            break;
        case AccountsLogResponse_AccountsLog_ModifyType_Gift:
        {
            type = @"礼物";
        }
            break;
        case AccountsLogResponse_AccountsLog_ModifyType_Charge:
        {
            type = @"充值";
        }
            break;
        case AccountsLogResponse_AccountsLog_ModifyType_SignedIn:
        {
            type = @"签到";
        }
            break;
        case AccountsLogResponse_AccountsLog_ModifyType_Upgraded :
        {
            type = @"升级";
        }
            break;
        case AccountsLogResponse_AccountsLog_ModifyType_ManualCharge:
        {
            type = @"手动充值";
        }
            break;
            
        default:
            break;
    }
    if (logModel.money != 0) {
        self.moneyDetailLabel.text = [NSString stringWithFormat:@"%@%d元",type,logModel.money];
        if (logModel.money>0) {
            self.moneyNumberLabel.text =  [NSString stringWithFormat:@"+%d元",logModel.money];
        }else{
            self.moneyNumberLabel.text =  [NSString stringWithFormat:@"-%d元",logModel.money];
        }
        
    }else{
        if (logModel.goldCoins>0) {
            self.moneyDetailLabel.text = [NSString stringWithFormat:@"%@",type];
            self.moneyNumberLabel.text =  [NSString stringWithFormat:@"+%lld",logModel.goldCoins];
        }else{
            self.moneyDetailLabel.text = [NSString stringWithFormat:@"%@",type];
            self.moneyNumberLabel.text =  [NSString stringWithFormat:@"-%lld",logModel.goldCoins];
        }
        
    }
    
    
}

@end
