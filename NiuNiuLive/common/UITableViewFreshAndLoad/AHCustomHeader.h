//
//  MJDIYHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface AHCustomHeader : MJRefreshHeader

/**
 设置AHCustomHeader背景背景色和label的字体颜色

 @param backgroundColor 背景色
 @param tintColor 字体颜色
 */
-(void)setBackgroundColor:(UIColor *)backgroundColor statusLabelTintColor:(UIColor*)tintColor;

/**
 使用gif图片加载
 */
-(void)UseGifImageLoading;
@end
