//
//  AHRechargeView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHRechargeView : AHBaseView

+ (id)rechargeShareView;

@property (nonatomic,assign) int64_t goldCoin;

- (void)dismissRecharge;

@property (nonatomic,copy) void (^closeRecherView)();

@end
