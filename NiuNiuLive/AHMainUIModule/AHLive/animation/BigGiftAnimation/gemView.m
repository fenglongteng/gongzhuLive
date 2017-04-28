//
//  gemView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/31.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "gemView.h"
#import "fireWorksView.h"

@interface gemView()<CAAnimationDelegate>

@property(nonatomic,strong)fireWorksView * fire;

@end

@implementation gemView

+ (instancetype)loadGemViewWithPoint:(CGPoint)point{
    gemView * gem = [[NSBundle mainBundle]loadNibNamed:@"gemView" owner:self options:nil].lastObject;
    gem.frame = CGRectMake(point.x, point.y, 225, 225);
    return gem;
}

- (void)addGemAnimationFromValue:(CGFloat)scaleFromValue toValue:(CGFloat)scaleToValue{
    [self insertSubview:self.yellowImage atIndex:0];
    [self insertSubview:self.redImage atIndex:1];
    fireWorksView * fire = [[fireWorksView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.backView addSubview:fire];
    self.fire = fire;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.yellowImage.alpha = 1;
        self.redImage.alpha = 1;
    });
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.5;
    scaleAnimation.beginTime = CACurrentMediaTime();;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:scaleFromValue];
    scaleAnimation.toValue = [NSNumber numberWithFloat:scaleToValue];
    scaleAnimation.removedOnCompletion = _removedOnCompletion;
    
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI * 2];
    animation.duration  = 4;
    animation.beginTime = CACurrentMediaTime() + 0.5;
    animation.fillMode =kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = -1;
    animation.delegate = self;
    [self.yellowImage.layer addAnimation:animation forKey:@"rotation"];
    [self.redImage.layer addAnimation:animation forKey:@"rotationY"];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 4.5f;
    animationGroup.removedOnCompletion = _removedOnCompletion;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.delegate = self;
    animationGroup.animations = @[scaleAnimation,animation];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
    [self.fire removeFromSuperview];
    self.fire = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
