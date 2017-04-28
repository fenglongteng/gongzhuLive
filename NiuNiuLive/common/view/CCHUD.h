//
//  MBProgressHUDHelper.h
//  iSecurity Camera 5.4
//
//  Created by Legendry on 13-4-16.
//  Copyright (c) 2013年 Legendry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"



@interface CCHUD : NSObject

/**
 *	显示加载进度条
 **/
+ (MBProgressHUD*)showLoadingView:(NSString*)strText superView:(UIView*)superView ;//MBProgressHUDModeDeterminate


/**
 *	显示处理进度条
 **/
+ (MBProgressHUD*)showProgressView:(NSString*)strText superView:(UIView*)superView ;

/**
 *	显示一个自定义的HUD
 **/
+ (void)showCustomHUD:(NSString *)imageName superView:(UIView*)superView message:(NSString*)message;

/**
 *  显示进度条，并且传入父视图
 */
+(void)showTip:(NSString *)strText view:(UIView *)showView;


+ (void)showTip:(NSString*)strText;

/**
 *	连接服务器失败显示
 **/
+ (void)showTip;

/**
 *	连接服务器失败显示
 **/
+ (void)showTipByView:(UIView *)view;

/**
 *  获取顶部navigation
 *
 *  @return controller.view
 */
+ (UIView *)getNavigationTopControllerView;

@end
