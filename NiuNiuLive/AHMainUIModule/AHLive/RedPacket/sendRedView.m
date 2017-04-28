//
//  sendRedView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "sendRedView.h"
#import "AHAlertView.h"
#import "Gifts.pbobjc.h"

#define NUMBERS @"0123456789."
@interface sendRedView()<UITextFieldDelegate>
//红包个数
@property (weak, nonatomic) IBOutlet UITextField *redPacketCount;
//红包金币
@property (weak, nonatomic) IBOutlet UITextField *redPacketCoin;
//红包语言
@property (weak, nonatomic) IBOutlet UITextField *redPacketMessage;
@end

@implementation sendRedView

- (void)showSendRedView{
    
    self.redPacketCount.delegate = self;
    self.redPacketCoin.delegate = self;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithInteger:0.5];
    animation.toValue = [NSNumber numberWithInteger:1.0];
    animation.duration = 0.3;
    animation.repeatCount = 1;
    [self.backView.layer addAnimation:animation forKey:@"startAnimation"];
}

- (IBAction)closeRedPacketView:(id)sender {
    [self removeFromSuperview];
}

- (void)setRedViewMessage{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishEditing)];
    [self addGestureRecognizer:tap];
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.backView.layer.borderColor = [UIColor colorWithRed:232/255.0 green:33/255.0 blue:66/255.0 alpha:1.0].CGColor;
    self.backView.layer.borderWidth = 2.0f;
    [[AppDelegate getAppdelegateWindow] addSubview:self];
    [self showSendRedView];
}

- (void)finishEditing{
    [self endEditing:YES];
}
- (IBAction)sendRedPacket_Event:(id)sender {
    if (self.redPacketCount.text.length <= 0 || self.redPacketCoin.text.length <= 0) {
        AHAlertView * showMess = [[AHAlertView alloc] initAlertViewReminderTitle:@"提示" title:@"红包数量或者金币不能为空" cancelBtnTitle:@"确定" cancelAction:^{
            
        }];
        [showMess showAlert];
    }else{
        //发红包
        Gift *gift = [[Gift alloc]init];
        //            gift.uuid = uuid;// 只有礼物才需要UUId
        gift.type = 1;//0礼物 1红包
        gift.goldCoins = [self.redPacketCoin.text integerValue];
        
        if (self.redPacketMessage.text.length <= 0 ) {
            gift.name = @"恭喜发财，大吉大利";
        }else{
            gift.name = self.redPacketMessage.text;
        }
        SendGiftRequest *sendGiftRequest = [[SendGiftRequest alloc]init];
        sendGiftRequest.gift = gift;
        sendGiftRequest.allowMaxUser = [self.redPacketCount.text intValue];
        [[AHTcpApi shareInstance] requsetMessage:sendGiftRequest classSite:GiftsClassName completion:^(id response, NSString *error) {
            SendGiftResponse *sendGiftRespones = response;
            if (sendGiftRespones.result == 0) {
                AHPersonInfoModel *model = [AHPersonInfoManager manager].getInfoModel;
                model.goldCoins -= gift.goldCoins;
                NSDictionary *dic = [NSDictionary dictionaryWithObject:@(model.goldCoins) forKey:@"userGold"];
                [[NSNotificationCenter defaultCenter]postNotificationName:UserGoldDidChange object:nil userInfo:dic];
                [[AHPersonInfoManager manager] setInfoModel:model];

            }else{
                //[SVProgressHUD showInfoWithStatus:sendGiftRespones.message];
            }
        }];
        
         [self removeFromSuperview];
    }
    
}


@end
