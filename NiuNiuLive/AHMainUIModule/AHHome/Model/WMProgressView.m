//
//  WMProgressView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "WMProgressView.h"

@interface WMProgressView ()
//进度View
@property (nonatomic, weak) UIView *tView;
//阴影View
@property (nonatomic, weak) UIView *sdiew;
//表框View
@property (nonatomic, weak) UIView *borderView;
//定时器
@property(nonatomic,strong) NSTimer * timer;
//初始进度条
@property (nonatomic, assign) CGFloat progress;
//当前的progress
@property (nonatomic, assign) CGFloat currentProgress;
@end

@implementation WMProgressView

-(instancetype)initWithFrame:(CGRect)frame Progress:(CGFloat)progress{
    if ([self initWithFrame:frame]) {
        self.progress = progress;
        [self addTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    
    return self;
}

-(void)setUpView{
    //阴影
    if (!self.sdiew) {
        UIImageView * view = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *image = [UIImage imageNamed:@"bg_nn_pbar"];
        view.image = image;
        [self addSubview:view];
        self.sdiew = view;
    }
    
    //边框
    if (!self.borderView) {
        UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
        borderView.layer.cornerRadius = self.bounds.size.height * 0.5;
        borderView.layer.masksToBounds = YES;
        borderView.backgroundColor = [UIColor blackColor];
        borderView.layer.borderColor = [[UIColor blackColor] CGColor];
        borderView.layer.borderWidth = KProgressBorderWidth;
        [self addSubview:borderView];
        self.borderView = borderView;
    }
    
    //进度
    if (!self.tView) {
        UIView *tView = [[UIView alloc] init];
        tView.backgroundColor = KProgressColor;
        tView.layer.cornerRadius = (self.bounds.size.height - (KProgressBorderWidth + KProgressPadding) * 2) * 0.5;
        tView.layer.masksToBounds = YES;
        [self addSubview:tView];
        self.tView = tView;
    }
    
}

- (void)addTimer
{
    if (!_timer) {
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:0.02 target:self selector:@selector(UpDateProgress) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }else{
        [self layoutSubviews];
        CGFloat margin = KProgressBorderWidth + KProgressPadding;
        CGFloat maxWidth = self.bounds.size.width - margin * 2;
        CGFloat heigth = self.bounds.size.height - margin * 2;
        _tView.frame = CGRectMake(margin, margin, maxWidth * _currentProgress, heigth);
    }
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    _currentProgress = 0;
    [self setUpView];
    [self addTimer];
}

-(void)setHideShadowView:(BOOL)isHiden{
    self.sdiew.hidden = isHiden;
}

-(void)UpDateProgress{
    if (_currentProgress <= _progress) {
       self.currentProgress += 0.01;
    }
    [self layoutSubviews];
    CGFloat margin = KProgressBorderWidth + KProgressPadding;
    CGFloat maxWidth = self.bounds.size.width - margin * 2;
    CGFloat heigth = self.bounds.size.height - margin * 2;
    _tView.frame = CGRectMake(margin, margin, maxWidth * _currentProgress, heigth);
    if (_currentProgress >= _progress) {
        [self removeTimer];
    }
}

-(void)layoutSubviews{
    self.sdiew.frame = self.bounds;
    self.sdiew.height = 27;
    self.borderView.frame = self.bounds;
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
