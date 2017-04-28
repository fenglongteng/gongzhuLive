//
//  MJDIYBackFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJRefreshBackFooter.h"

@interface AHCustomFooter : MJRefreshBackFooter
/**
 设置AHCustomHeader背景背景色和label的字体颜色
 
 @param backgroundColor 背景色
 @param tintColor 字体颜色
 */
-(void)setBackgroundColor:(UIColor *)backgroundColor statusLabelTintColor:(UIColor*)tintColor;

/**
 隐藏加载图片
 */
-(void)hideLoadingImageView;
@end
