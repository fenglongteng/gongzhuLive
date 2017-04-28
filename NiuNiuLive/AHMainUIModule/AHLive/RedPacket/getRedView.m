    //
//  getRedView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "getRedView.h"
#import "Gifts.pbobjc.h"
#import "NSString+Tool.h"

@interface getRedView()

@property(nonatomic,assign)int64_t getCoins;

@end

@implementation getRedView

- (void)showSendRedView{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithInteger:0.5];
    animation.toValue = [NSNumber numberWithInteger:1.0];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    [self.backView.layer addAnimation:animation forKey:@"startAnimation"];
}

- (void)setRedMessage:(PushGift *)redMessage{
    _redMessage = redMessage;
    self.nameLbl.text = redMessage.nickName;
    self.redPacketTitle.text = redMessage.gift.name;
    [self.headImage sd_setImageWithURL:[NSString getImageUrlString:redMessage.avatar] placeholderImage:[UIImage imageNamed:@"logo_500.jpg"]];
}

- (IBAction)closeRedPacketView:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)openRedPacket:(id)sender {
    if (self.detailBlock) {
        [self removeFromSuperview];
        GrabRedPackagesRequest *gradRedReques = [[GrabRedPackagesRequest alloc]init];
        gradRedReques.giftUuid = self.redMessage.gift.uuid;
        [[AHTcpApi shareInstance] requsetMessage:gradRedReques classSite:GiftsClassName completion:^(id response, NSString *error) {
            GrabRedPackagesResponse *redRespose = response;
            if (redRespose.result == 0) {
                self.getCoins = redRespose.goldCoins;
                self.detailBlock(NO,redRespose.goldCoins,self.redMessage.gift.uuid);
                self.isRedPacket = NO;
                
            }else{
                //[SVProgressHUD showInfoWithStatus:@"很抱歉，没有抢到红包"];
                self.openBtn.hidden = YES;
                self.redPacketTitle.text = @"红包已被其他玩家抢光啦！";
                self.checkBtn.hidden = NO;
                self.isRedPacket = YES;
            }
        }];
    }
}

- (void)setRedViewMessage{
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [[AppDelegate getAppdelegateWindow] addSubview:self];
    [self showSendRedView];
    
}
- (IBAction)checkRedPacketMessage:(id)sender {
    if (self.detailBlock) {
        [self removeFromSuperview];
        self.detailBlock(self.isRedPacket,self.getCoins,self.redMessage.gift.uuid);
    }
}

@end
