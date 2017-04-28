//
//  GiftBase.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gifts.pbobjc.h"


@interface GiftBase : NSObject
//初始化
+ (GiftBase *)initGiftType;

/*
 *  礼物基础动画（礼物模型,底层视图）
 */
- (void)baseGiftAnimationWithModel:(PushGift *)giftModel backView:(UIView *)giftView;

@end
