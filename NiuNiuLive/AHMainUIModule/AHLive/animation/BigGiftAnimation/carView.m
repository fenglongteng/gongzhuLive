//
//  carView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/30.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "carView.h"
#import "fireWorksView.h"

@interface carView()<CAAnimationDelegate>

@property (nonatomic, copy) NSMutableArray *animations;
//礼花爆炸动画
@property (nonatomic,strong)fireWorksView * fire;

@end

@implementation carView

- (NSMutableArray *)animations{
    
    if (_animations == nil) {
        _animations = [[NSMutableArray alloc] init];
    }
    return _animations;
}

+ (instancetype)loadCarViewWithPoint:(CGPoint)point{
    carView *car = [[NSBundle mainBundle]loadNibNamed:@"carView" owner:self options:nil].lastObject;
    car.frame = CGRectMake(point.x, point.y, 150, 150);
    [car setPoints];
    [car setPlaneScrewImages:nil];
    return car;
}

- (instancetype)loadCarViewWithNib:(CGPoint)point{
    carView *car = [[NSBundle mainBundle]loadNibNamed:@"carView" owner:self options:nil].lastObject;
    car.frame = CGRectMake(point.x, point.y, 150, 150);
    [car setPoints];
    [car setPlaneScrewImages:nil];
    return car;
}

- (void)addAnimationsMoveToPoint:(CGPoint)movePoints endPoint:(CGPoint)endPoint{
    [self insertSubview:self.rotationImageY atIndex:0];
    [self insertSubview:self.rotationImage atIndex:1];
    fireWorksView * fire = [[fireWorksView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.backView addSubview:fire];
    self.fire = fire;

    CGFloat middle = (endPoint.y - movePoints.y)/2.0 + movePoints.y;
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, movePoints.x, movePoints.y);
    
//    [self.curveControlAndEndPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGRect rect = CGRectFromString(obj);
//        CGPathAddQuadCurveToPoint(path, NULL, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
//    }];
    CGPathAddQuadCurveToPoint(path, NULL, [UIScreen mainScreen].bounds.size.width / 2, middle, [UIScreen mainScreen].bounds.size.width / 2, middle);
    
    position.path = path;
    position.duration = 2;
    position.speed = _positionSpeed;
    position.removedOnCompletion = _removedOnCompletion;
    position.fillMode = kCAFillModeForwards;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rotationImage.alpha = 1;
        self.rotationImageY.alpha = 1;
    });
    
    CAKeyframeAnimation * position1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, [UIScreen mainScreen].bounds.size.width / 2, middle);
//    [self.curveControlAndEndPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGPathAddQuadCurveToPoint(path, NULL, endPoint.x, endPoint.y, endPoint.x, endPoint.y);
//    }];
    CGPathAddQuadCurveToPoint(path1, NULL, endPoint.x, endPoint.y, endPoint.x, endPoint.y);
    position1.path = path1;
    position1.duration = 2;
    position1.beginTime = 4;
    position1.speed = _positionSpeed;
    position1.removedOnCompletion = _removedOnCompletion;
    position1.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = _scaleDuration;
    scaleAnimation.beginTime = _beginScaleTime;
    scaleAnimation.fromValue = _scaleFromValue;
    scaleAnimation.toValue = _scaleToValue;
    scaleAnimation.removedOnCompletion = _removedOnCompletion;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 6.f;
    animationGroup.removedOnCompletion = _removedOnCompletion;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.delegate = self;
    animationGroup.animations = @[position,position1,scaleAnimation];
    
    if (self.animations.count == 0) {
        [self.animations addObject:animationGroup];
        [self.layer addAnimation:animationGroup forKey:@"carView"];
    }else{
        [self.animations addObject:animationGroup];
    }
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI];
    animation.duration  = 4;
    animation.beginTime = _beginScaleTime;
    animation.fillMode =kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = -1;
    animation.delegate = self;
    [self.rotationImage.layer addAnimation:animation forKey:@"rotation"];
    [self.rotationImageY.layer addAnimation:animation forKey:@"rotationY"];
}

- (void)setPlaneScrewImages:(NSArray *)imageArray{
    

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.rotationImageY.layer animationForKey:@"rotationY"]) {
        [self.rotationImageY removeFromSuperview];
        [self.rotationImage removeFromSuperview];
    }else{
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.fire removeFromSuperview];
            self.fire = nil;
        });
        
        if (self.animations.count > 0) {
            
        }else{
            
        }
    }
}

- (void)setPoints{
    _scaleDuration = 1.2;
    _positionDuration = 5.0;
    _positionSpeed = 0.7;
    _beginScaleTime = 0.f;
    if (!_scaleToValue) {
        _scaleToValue = [NSNumber numberWithFloat:1.5];
    }
    _scaleFromValue = [NSNumber numberWithFloat:0.7];
    
//    NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
//    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
//    [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
//    [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
//    [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
//    [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
//    [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
//    self.curveControlAndEndPoints = pointArrs;
}

- (void)setBeginScaleTime:(CGFloat)beginScaleTime{
    _beginScaleTime = beginScaleTime;
}

- (void)setPositionSpeed:(CGFloat)positionSpeed{
    _positionSpeed = positionSpeed;
}

- (void)setPositionDuration:(CGFloat)positionDuration{
    _positionDuration = positionDuration;
}

- (void)setScaleSpeed:(CGFloat)scaleSpeed{
    _scaleSpeed = scaleSpeed;
}

- (void)setScaleDuration:(CGFloat)scaleDuration{
    _scaleDuration = scaleDuration;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
