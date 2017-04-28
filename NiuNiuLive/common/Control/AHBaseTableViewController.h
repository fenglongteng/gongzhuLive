//
//  AHBaseTableViewController.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHBaseTableViewController : UITableViewController



//设置右边的导航按钮 （文字）
- (void)setRightButtonBarItemTitle:(NSString *)title target:(id)target action:(SEL)action;

//设置右边的导航按钮 （文字+颜色）
- (void)setRightButtonBarItemTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action;

//设置右边的导航按钮 （图片）
- (void)setRightButtonBarItemImage:(NSString *)imageStr highlightImage:(NSString *)highlightImageStr target:(id)target action:(SEL)action;

//设置左边的导航按钮 （文字）
- (void)setLeftButtonBarItemTitle:(NSString *)title target:(id)target action:(SEL)action;

//设置左边的导航按钮 （文字+颜色）
- (void)setLeftButtonBarItemTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action;

//设置左边的导航按钮 （图片）
- (void)setLeftButtonBarItemImage:(NSString *)imageStr highlightImage:(NSString *)highlightImageStr target:(id)target action:(SEL)action;

//隐藏返回按钮
- (void)hideleftBarButtonItem;

//设置标题字体加粗
-(void)setHoldTitle:(NSString*)title;

//设置titleView
-(void)setTitleView:(UIView*)titleView;

//设置导航条颜色
-(void)setBarTintColor:(UIColor*)color;
@end
