//
//  AHGiftView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/25.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHGiftView : AHBaseView
@property (weak, nonatomic) IBOutlet UIView *giftBackView;

+ (id)shareGiftView;

@property (nonatomic,copy) void (^closeGiftViewBlock)();

@property (nonatomic,copy) void (^senderRedPacketViewBlock)();

@property (nonatomic,copy) void (^rechargeBlock)();//充值

@end
