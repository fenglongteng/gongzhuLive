/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;
- (void)showHudInWindowWithhint:(NSString *)hint;
- (void)hideHud;
- (void)showHint:(NSString *)hint;
- (void)showHintWithView:(UIView *)view hit:(NSString *)hint;

- (void)showHUDInTopViewWithHint:(NSString *)hint;
- (void)showHUDInTopView;
- (void)showHudWindowWithHint:(NSString *)hint;
- (void)showHudWindow;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
+ (void)showHudInView:(UIView *)view hint:(NSString *)hint;
+ (void)showHudInWindowWithhint:(NSString *)hint;

@end
