//
//  gameRemind.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/1.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "gameRemind.h"
#import "pokerAnimation.h"
#import "gameFinishView.h"

@interface gameRemind() <CAAnimationDelegate>{
    //当前游戏界面
    AHLiveGameView * _gameView;
    //押注时间
    int _BetTime;
    //服务器出牌了标志
    int _ServiceTag;
    //扑克信息
    DouNiuEventGameResult * _pokersMes;
}

@property (weak, nonatomic) IBOutlet UIImageView *startView;
@property (weak, nonatomic) IBOutlet UIImageView *clockImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *restImage;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;


@end

@implementation gameRemind

- (void)dealloc{
    _ringPlayer = nil;
}

+ (gameRemind *)initGameRemindView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)startGameWithView:(AHLiveGameView *)gameView betTime:(int)betTime{
    _BetTime = betTime;
    _gameView = gameView;
    [[pokerAnimation pokerAnimation]startGameSound];
    //游戏开局，开启投注手势
    [_gameView gameWithStarting:YES];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.5;
    scaleAnimation.beginTime = CACurrentMediaTime();;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.2];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.delegate = self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.startView.layer addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.startView.layer animationForKey:@"scaleAnim"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.startView removeFromSuperview];
            self.clockImage.hidden = NO;
            self.timeLabel.hidden = NO;
            [self clockStarting:_BetTime isEnterGameBetingStatus:NO];
        });
    }
    
}

- (void)licensingOfServiceWithTag:(DouNiuEventGameResult *)result gameView:(AHLiveGameView *)gameView{
    _ServiceTag +=1;// Tag;
    if (gameView && !_gameView) {
        _gameView = gameView;
    }
    if (result) {
        _pokersMes = result;
    }
    if(_ServiceTag==2 && _pokersMes && _gameView){
        self.clockImage.hidden = YES;
        self.timeLabel.hidden = YES;
        _ServiceTag = 0;
        [self startLicensing:_pokersMes];
    }
}

- (void)clockStarting:(int)betTime isEnterGameBetingStatus:(BOOL)isBeting{
    if (isBeting == YES) {
        [self.startView removeFromSuperview];
        self.clockImage.hidden = NO;
        self.timeLabel.hidden = NO;
    }
    __block int timeout = betTime -  1;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self licensingOfServiceWithTag:nil gameView:nil];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.text = [NSString stringWithFormat:@"%dS",timeout];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)showHaveRestView{
    
    if (self.finishBlock) {
        self.finishBlock();
    }
    
    
}

- (void)startLicensing:(DouNiuEventGameResult *)pokerMessage{
    [[pokerAnimation pokerAnimation] initWithPoker:self pokerMessage:pokerMessage gameView:_gameView];
    [[pokerAnimation pokerAnimation]ShuffleTheDeckSound];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[pokerAnimation pokerAnimation] licensingToPlayers:_gameView];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[pokerAnimation pokerAnimation] FlipCARDS:0];
    });

}

@end
