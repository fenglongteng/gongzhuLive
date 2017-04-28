//
//  levelHeader.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "levelHeader.h"
#import "WMProgressView.h"
#import "Masonry.h"

@interface levelHeader(){
    NSTimer * _timer;
}


@property(nonatomic,weak)IBOutlet WMProgressView * progressView;

@end

@implementation levelHeader

- (void)initWithFrame:(CGRect)frame userModel:(AHPersonInfoModel *)userModel{
    self.frame = frame;
    self.levelTitle.text = userModel.rank ? userModel.rank : @"无名之辈";
    self.levelImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_grad%d",userModel.level.level]];
    self.JingYanLbl.text = [NSString stringWithFormat:@"%lld/%lld经验",userModel.level.experiencePoint,userModel.level.nextLevelExperiencePoint];
    CGFloat pro = 0.0;
    if (userModel.level.experiencePoint >= 0 && (userModel.level.nextLevelExperiencePoint * 1.0) >0) {
        pro = userModel.level.experiencePoint / (userModel.level.nextLevelExperiencePoint * 1.0);
    }
    [_progressView setProgress:pro];
    //[self addTimer];
}



//- (void)addTimer
//{
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//}
//
//- (void)timerAction
//{
//    _progressView.progress += 0.01;
//    if (_progressView.progress >= 0.5) {
//        [self removeTimer];
//    }
//}
//
//- (void)removeTimer
//{
//    [_timer invalidate];
//    _timer = nil;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
