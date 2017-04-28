//
//  AHTabBarView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHTabBarView.h"
#import "AHTabButton.h"
#import "Masonry.h"


@implementation AHTabBarView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImageView];
        
        [self createTabBarButton];
    }
    return self;
}

- (void)createTabBarButton{

    CGFloat tabBarBtnWidth = screenWidth/5.0;
    NSArray *normalImages = @[@"btn_iconhome1",@"btn_iconfind1",@"btn_iconnn",@"btn_iconnews1",@"btn_iconme1"];
    NSArray *selectImages = @[@"btn_iconhome0",@"btn_iconfind0",@"btn_iconnn",@"btn_iconnews0",@"btn_iconme0"];
    NSArray *titles = @[@"首页",@"发现",@"",@"消息",@"我的"];
    for (int i = 0; i<normalImages.count; i++) {
        AHTabButton *tabBarBtn = [[AHTabButton alloc]initDefaultImage:[UIImage imageNamed:normalImages[i]] selectImage:[UIImage imageNamed:selectImages[i]] title:titles[i]];
//        [tabBarBtn setTitle:titles[i] forState:UIControlStateNormal];
//        [tabBarBtn setTitleColor:titles[i] forState:UIControlStateNormal];
//        [tabBarBtn setTitleColor:titles[i] forState:UIControlStateSelected];
        tabBarBtn.x = tabBarBtnWidth *i;
        tabBarBtn.y = 20;
        tabBarBtn.width = tabBarBtnWidth;
        tabBarBtn.height = tabBarHeight;
        if (i==2) {
            tabBarBtn.y = 10;
        }
        [self addSubview:tabBarBtn];
        [tabBarBtn addTarget:self action:@selector(tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)tabBarClick:(AHTabButton *)btn{
    btn.selected = YES;//被选中
    if (self.currentButton == btn) {
        return;
    }
    self.currentButton.selected = NO;
    self.currentButton = btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backImageView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (UIImageView *)backImageView{

    if (_backImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"bg_home_btn"];
        
        _backImageView = [[UIImageView alloc]initWithImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height-2, 10, 2, 10) ]];
    }
    return _backImageView ;
}

@end
