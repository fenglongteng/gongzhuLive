//
//  AppDelegate.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) NSTimer *myTimer;
/**
 *  获取window
 *
 *  @return window
 */
+ (UIWindow *)getAppdelegateWindow;

/**
 *  获取rootViewController
 *
 *  @return rootViewController
 */
+ (UIViewController *)getAppdelegateRootViewControoler;

/**
 *  获取navigation顶部视图
 *
 *  @return topController
 */
+ (UIViewController *)getNavigationTopController;

/**
 *  返回Appdelegate
 *
 *  @return delegate
 */
+ (AppDelegate *)getSelf;


/**
 * 设置登录控制器为根控制器
 */
+(void)setLogVCBecomeRootViewController;


/**
 * 设置TabBarController为跟控制器
 */
+(void)setTabBarControllerBecomeRootViewController;

@end

