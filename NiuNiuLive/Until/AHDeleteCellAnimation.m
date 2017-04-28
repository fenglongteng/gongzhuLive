//
//  YTAnimation.m
//  
//
//  Created by Mac on 16/5/6.
//  Copyright © 2016年 YinTokey. All rights reserved.
//  

#import "AHDeleteCellAnimation.h"
#import <UIKit/UIKit.h>
@implementation AHDeleteCellAnimation

+(void)vibrateAnimation:(UIView *)AniView {
    CAKeyframeAnimation *rvibrateAni = [CAKeyframeAnimation animation];
    rvibrateAni.keyPath = @"transform.rotation";
    CGFloat angle = M_PI_4/18;
    rvibrateAni.values = @[@(-angle),@(angle),@(-angle)];
    rvibrateAni.repeatCount = MAXFLOAT;
    [AniView.layer addAnimation:rvibrateAni forKey:@"shake"];
}




+ (void)toMiniAnimation:(UIView *)AniView {
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = AniView;
    CABasicAnimation *rotationAni = [CABasicAnimation animation];
    rotationAni.keyPath = @"transform.rotation";
    rotationAni.toValue = @(M_PI_2*3);

    CABasicAnimation *scaleAni = [CABasicAnimation animation];
    scaleAni.keyPath = @"transform.scale";
    scaleAni.toValue = @(0.03);

    group.duration = 0.5;
    group.animations = @[rotationAni, scaleAni];
    [group setValue:@"toMini" forKey:@"animType"];
    [AniView.layer addAnimation:group forKey:nil];
}




@end
