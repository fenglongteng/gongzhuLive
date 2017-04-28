//
//  MJDIYBackFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "AHCustomFooter.h"
#import "AHDeleteCellAnimation.h"
@interface AHCustomFooter()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *logo;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;

@end

@implementation AHCustomFooter
#pragma mark 定时器防超时
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}
-(NSTimer*)timer{
    if (!_timer) {
        self.time = 0;
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:1 target:self selector:@selector(timToStart) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

-(void)timToStart{
    self.time++;
    if (self.time > 30) {
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

-(void)hideLoadingImageView{
    _logo.hidden = YES;
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
    self.label.frame = self.bounds;
    self.logo.center = CGPointMake(screenWidth/2-35, self.mj_h * 0.5);
    self.label.center = CGPointMake(CGRectGetMaxX(self.logo.frame)+35, self.mj_h * 0.5);
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
        {
            self.label.text = @"上拉加载更多";
            [self.label sizeToFit];
            self.label.frame = self.bounds;
            self.logo.center = CGPointMake(screenWidth/2-35, self.mj_h * 0.5);
            self.label.center = CGPointMake(CGRectGetMaxX(self.logo.frame)+35, self.mj_h * 0.5);
            
        }
            
            break;
        case MJRefreshStatePulling:
          
          
        {
            self.label.text = @"松手开始加载";
            [self.label sizeToFit];
            self.label.frame = self.bounds;
            self.logo.center = CGPointMake(screenWidth/2-35, self.mj_h * 0.5);
            self.label.center = CGPointMake(CGRectGetMaxX(self.logo.frame)+35, self.mj_h * 0.5);
            
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.label.text = @"加载中…";
            [self.label sizeToFit];
            self.label.frame = self.bounds;
            self.logo.center = CGPointMake(screenWidth/2-18, self.mj_h * 0.5);
            self.label.center = CGPointMake(CGRectGetMaxX(self.logo.frame)+18, self.mj_h * 0.5);
        }
            
             [self beginAnimation];
            break;
        case MJRefreshStateNoMoreData:
        {
            self.label.text = @"没有更多数据";
            [self.label sizeToFit];
            self.label.frame = self.bounds;
            self.logo.center = CGPointMake(screenWidth/2-35, self.mj_h * 0.5);
            self.label.center = CGPointMake(CGRectGetMaxX(self.logo.frame)+35, self.mj_h * 0.5);
            
        }
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
    [self removeAnimation];
}


@end
