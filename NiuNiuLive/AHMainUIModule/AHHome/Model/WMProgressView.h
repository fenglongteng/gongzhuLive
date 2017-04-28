//
//  WMProgressView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMProgressView : UIView

#define KProgressBorderWidth 1.0f
#define KProgressPadding 1.0f
#define KProgressColor [UIColor colorWithRed:241/255.0 green:213/255.0 blue:70/255.0 alpha:1]

//初始化进度条方法 无需要启动
-(instancetype)initWithFrame:(CGRect)frame Progress:(CGFloat)progress;
//xib加载 手动启动
-(void)setProgress:(CGFloat)progress;
//是否显示阴影
-(void)setHideShadowView:(BOOL)isHiden;
@end
