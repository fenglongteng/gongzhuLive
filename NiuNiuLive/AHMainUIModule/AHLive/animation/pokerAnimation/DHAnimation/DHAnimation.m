//
//  DHAnimation.m
//  HipoDemo
//
//  Created by DreamHack on 15-11-19.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHAnimation.h"

@interface DHAnimation ()


@property (nonatomic, strong) CADisplayLink * displayLink;


@end

@implementation DHAnimation

#pragma mark - 初始化
+ (instancetype)animation
{
    return [[self alloc] init];
}

+ (instancetype)animationWithDuration:(CGFloat)duration fromValue:(id)fromValue toValue:(id)toValue animationBlock:(void (^)(id))animationBlock
{
    DHAnimation * animation = [self animation];
    
    animation.duration = duration;
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.animationBlock = animationBlock;
    animation.animationCurve = DHAnimationCurveNone;

    return animation;
}

#pragma mark - 接口方法
- (void)runAnimation
{
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    if (!self.beginTime) {
        self.beginTime = CACurrentMediaTime();
    }
}

- (void)stopAnimation
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - 私有方法

- (CGFloat)easeOut:(CGFloat)p
{
    return -(p - 1) * (p - 1) + 1;
}

- (CGFloat)easeIn:(CGFloat)p
{
    return p*p;
}

- (void)onDisplayLink:(CADisplayLink *)displayLink
{
    CGFloat currentDuration = CACurrentMediaTime() - self.beginTime;
    CGFloat percent = currentDuration/self.duration;
    if (percent >= 1) {
        [self.displayLink invalidate];
        return;
    }
    
    if (self.animationCurve == DHAnimationCurveEaseIn) {
        percent = [self easeIn:percent];
    } else if (self.animationCurve == DHAnimationCurveEaseOut) {
        percent = [self easeOut:percent];
    }
    
    if ([self.fromValue isKindOfClass:[UIColor class]]) {
        
        UIColor * color = interpolateColor(self.fromValue, self.toValue, percent);
        if (self.animationBlock) {
            self.animationBlock(color);
        }
        
    } else if ([self.fromValue isKindOfClass:[NSNumber class]]) {
        CGFloat value = interpolateFloat([self.fromValue floatValue], [self.toValue floatValue], percent);
        
        if (self.animationBlock) {
            self.animationBlock(@(value));
        }
    } else if ([self.fromValue isKindOfClass:[NSValue class]]) {
        
        NSString * description = [self.fromValue description];
        if ([description hasPrefix:@"NSPoint"]) {
            CGPoint fromPoint = [self.fromValue CGPointValue];
            CGPoint toPoint = [self.toValue CGPointValue];
            
            CGPoint point = interpolatePoint(fromPoint, toPoint, percent);
            if (self.animationBlock) {
                self.animationBlock([NSValue valueWithCGPoint:point]);
            }
            
        } else if ([description hasPrefix:@"NSRect"]) {
            CGRect fromRect = [self.fromValue CGRectValue];
            CGRect toRect = [self.toValue CGRectValue];
            
            CGRect rect = interpolateRect(fromRect, toRect, percent);
            if (self.animationBlock) {
                self.animationBlock([NSValue valueWithCGRect:rect]);
            }
        }
    }
    
}



+ (void)getRGBComponents:(CGFloat [4])components forColor:(UIColor *)color
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 4; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }

}

#pragma mark - getter
- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    }
    return _displayLink;
}

#pragma mark - 插值函数

static inline CGFloat interpolateFloat(CGFloat from, CGFloat to, CGFloat percent)
{
    return from + (to - from)*percent;
}

static inline CGPoint interpolatePoint(CGPoint from, CGPoint to, CGFloat percent)
{
    CGFloat x = interpolateFloat(from.x, to.x, percent);
    CGFloat y = interpolateFloat(from.y, to.y, percent);
    return CGPointMake(x, y);
}

static inline CGRect interpolateRect(CGRect from, CGRect to, CGFloat percent)
{
    CGFloat width = interpolateFloat(from.size.width, to.size.width, percent);
    CGFloat height = interpolateFloat(from.size.height, to.size.height, percent);
    CGPoint origin = interpolatePoint(from.origin, to.origin, percent);
    
    CGRect rect = {origin, CGSizeMake(width, height)};
    
    return rect;
}

static inline UIColor * interpolateColor(UIColor * from, UIColor * to, CGFloat percent)
{
    CGFloat fromColorRGBA[4];
    CGFloat toColorRGBA[4];
    
    [DHAnimation getRGBComponents:fromColorRGBA forColor:from];
    
    [DHAnimation getRGBComponents:toColorRGBA forColor:to];
    
    CGFloat r = interpolateFloat(fromColorRGBA[0], toColorRGBA[0], percent);
    CGFloat g = interpolateFloat(fromColorRGBA[1], toColorRGBA[1], percent);
    CGFloat b = interpolateFloat(fromColorRGBA[2], toColorRGBA[2], percent);
    CGFloat a = interpolateFloat(fromColorRGBA[3], toColorRGBA[3], percent);
    
    UIColor * color = [UIColor colorWithRed:r green:g blue:b alpha:a];
    
    return color;
}

@end
