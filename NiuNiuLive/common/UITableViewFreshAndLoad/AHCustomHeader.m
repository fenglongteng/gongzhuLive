//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "AHCustomHeader.h"
#import "UIImage+GIF.h"
@interface AHCustomHeader()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *logo;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
//是否是gif图片动画
@property(nonatomic,assign)BOOL isGifAnimation;
@end

@implementation AHCustomHeader
#pragma mark 定时器放超时
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

-(void)startTimer{
    
    self.time = 0;
    _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:1 target:self selector:@selector(timToStart) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

-(void)timToStart{
    self.time++;
    if (self.time >= 20) {
        [self endRefreshing];
        self.time = 0;
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）

- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 65;
    [self addSubview:self.label];
    [self addSubview:self.logo];
}

-(UILabel*)label{
    if (!_label) {
        // 添加label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        _label = label;
    }
    return _label;
}

-(UIImageView*)logo{
    if (!_logo) {
        // logo
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_nn_loading"]];
        _logo = logo;
    }
    return _logo;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor statusLabelTintColor:(UIColor*)tintColor{
    self.backgroundColor = backgroundColor;
    if ([self label]) {
        self.label.textColor = tintColor;
    }
}

/**
 使用gif图片加载
 */
-(void)UseGifImageLoading{
    _isGifAnimation = YES;
    self.mj_h = 100;
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"bg_loading60.gif" ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    self.logo.image = [UIImage sd_animatedGIFWithData:imageData];
}

#pragma mark 动画效果
-(void)beginAnimation{
    if ([self.logo.layer animationForKey:@"rotating"]) {
        [self.logo.layer removeAnimationForKey:@"rotating"];
    }else{
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, NULL, self.logo.centerX,self.logo.centerY, 1, 0,M_PI * 2, 0);
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = path;
        CGPathRelease(path);
        animation.duration = 0.5;
        animation.repeatCount = CGFLOAT_MAX;
        animation.autoreverses = NO;
        animation.rotationMode =kCAAnimationRotateAuto;
        animation.fillMode =kCAFillModeForwards;
        [self.logo.layer addAnimation:animation forKey:@"rotating"];
    }
}

-(void)removeAnimation{
    if ([self.logo.layer animationForKey:@"rotating"]) {
        [self.logo.layer removeAnimationForKey:@"rotating"];
    }
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    if (_isGifAnimation) {
        self.label.frame = self.bounds;
        self.logo.size = CGSizeMake(40, 40);
        self.logo.center = CGPointMake(screenWidth/2, self.mj_h * 0.5 - 5);
       self.label.center = CGPointMake(screenWidth/2, self.mj_h * 0.5+30);
    }else{
        self.label.frame = self.bounds;
        self.label.center = CGPointMake(screenWidth/2, self.mj_h * 0.5+20);
        self.logo.center = CGPointMake(screenWidth/2, self.mj_h * 0.5 - 5);
    }
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"下拉刷新";
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松手开始刷新";
            break;
        case MJRefreshStateRefreshing:
            [self beginAnimation];
            if (_isGifAnimation) {
                [self removeAnimation];
            }
            [self startTimer];
            self.label.text = @"刷新中";
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}

#pragma mark 重新结束加载
-(void)endRefreshing{
    [super endRefreshing];
    if ([self.logo.layer animationForKey:@"rotating"]) {
        [self.logo.layer removeAnimationForKey:@"rotating"];
    }
    [self.timer invalidate];
    self.timer = nil;
}
@end
