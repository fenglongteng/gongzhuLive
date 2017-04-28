//
//  AHBaseViewController.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "AHCustomNavigationBar.h"
#import "MJRefresh.h"
#import "SocketManager.h"
#import "protoBuffers.h"
#import "AHAlertView.h"
@interface AHBaseViewController : UIViewController
//自定义导航栏   可以修改这个View
@property(nonatomic,strong) AHCustomNavigationBar *customNavigationBar;

//设置右边的导航按钮 （文字）
- (void)setRightButtonBarItemTitle:(NSString *)title target:(id)target action:(SEL)action;

//设置右边的导航按钮 （文字+颜色）
- (void)setRightButtonBarItemTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action;

//设置右边的导航按钮 （图片）
- (void)setRightButtonBarItemImage:(NSString *)imageStr highlightImage:(NSString *)highlightImageStr target:(id)target action:(SEL)action;

//设置左边的导航按钮 （文字）
- (void)setLeftButtonBarItemTitle:(NSString *)title target:(id)target action:(SEL)action;

//设置左边的导航按钮 （图片）
- (void)setLeftButtonBarItemImage:(NSString *)imageStr highlightImage:(NSString *)highlightImageStr target:(id)target action:(SEL)action;

//设置左边的导航按钮 （文字+颜色）
- (void)setLeftButtonBarItemTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action;

//隐藏返回按钮
- (void)hideleftBarButtonItem;

//添加返回按钮
- (void)addPopButton;

//设置标题字体加粗
-(void)setHoldTitle:(NSString*)title;

//设置titleView
-(void)setTitleView:(UIView*)titleView;

//设置导航条颜色
-(void)setBarTintColor:(UIColor*)color;

//自定义透明导航条 默认样式只有返回键其他透明 若要更改看用AHCustomNavigationBar自行修改。且用FDFullscreenPopGesture自行隐藏导航条
-(void)setCustomTransparencyNavigationBarWithFrame:(CGRect)frame;

//设置导航栏分割线颜色，默认透明
-(void)setLineViewColor:(UIColor *)color;

@end
