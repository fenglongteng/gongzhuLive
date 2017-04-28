//
//  BigAnimOperation.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BigAnimOperation : NSOperation
//当前收到礼物的时间戳
@property(nonatomic,assign)int64_t time;
//当前礼物的动画View
@property(nonatomic,strong)UIView * animView;

+ (instancetype)initBigAnimationWithAnimationView:(UIView *)animView time:(int64_t)time;

@end
