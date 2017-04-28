//
//  AHTabBar.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHTabBar.h"
#import "UIImage+extension.h"

@interface AHTabBar ()

@property (nonatomic,strong)UIButton *plusBtn;

@end

@implementation AHTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        self.backgroundImage = [[UIImage alloc]init];
        [self setShadowImage:[[UIImage alloc]init]];
        UIImage *image = [UIImage imageNamed:@"bg_home_btn"];
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, image.size.height)];
        backImageView.image = image;
        backImageView.contentMode = UIViewContentModeScaleAspectFill;
        backImageView.clipsToBounds = YES;
        backImageView.y = -(image.size.height - tabBarHeight);
        [self addSubview:backImageView];
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"btn_iconnn"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"btn_iconnn"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"btn_iconnn"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"btn_iconnn"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)plusClick{

    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews{

    [super layoutSubviews];
    // 1.设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5-12;
    // 2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonW;
            // 设置x
            child.x = tabbarButtonIndex * tabbarButtonW;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

@end
