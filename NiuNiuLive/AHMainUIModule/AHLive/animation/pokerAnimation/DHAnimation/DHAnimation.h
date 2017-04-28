//
//  DHAnimation.h
//  HipoDemo
//
//  Created by DreamHack on 15-11-19.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DHAnimationCurve) {
    DHAnimationCurveNone = 0,
    DHAnimationCurveEaseOut,
    DHAnimationCurveEaseIn,
    
};

@interface DHAnimation : NSObject

@property (nonatomic, assign) DHAnimationCurve animationCurve;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;
@property (nonatomic, assign) CGFloat beginTime;
/**
 *  实现这个block来重新给自己想要动画的view通过animationValue赋值
 */
@property (nonatomic, copy) void (^animationBlock)(id animationValue);

+ (instancetype)animation;

// Color, Point, Rect, Float
+ (instancetype)animationWithDuration:(CGFloat)duration fromValue:(id)fromValue toValue:(id)toValue animationBlock:(void (^)(id animationValue))animationBlock;

- (void)runAnimation;
- (void)stopAnimation;

@end
