//
//  gameFinishView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/13.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "gameFinishView.h"

@interface gameFinishView()<CAAnimationDelegate>



@end

@implementation gameFinishView

+ (gameFinishView *)initGameFinishView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)gameWaitingOrGameCreating{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.5;
    scaleAnimation.beginTime = CACurrentMediaTime();;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.2];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.delegate = self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnimation forKey:@"restAnim"];
}

- (void)WaitForTheCountdownWithTime:(int32_t)time{
    __block int32_t timeout = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.finishBlock) {
                    self.finishBlock(self);
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLbl.text = [NSString stringWithFormat:@"请等待游戏开始 %dS",timeout];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
