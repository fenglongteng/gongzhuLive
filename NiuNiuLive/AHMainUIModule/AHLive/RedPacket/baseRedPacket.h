//
//  baseRedPacket.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gifts.pbobjc.h"

@class sendRedView;
@class getRedView;

@interface baseRedPacket : NSObject
//发红包View初始化调用
+ (sendRedView *)initWithSendRed;

//抢红包 传入得到的红包 信息
+ (getRedView *) initWithGetRed:(PushGift *)redMessage;

@end
