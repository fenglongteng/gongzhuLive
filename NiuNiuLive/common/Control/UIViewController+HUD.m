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

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = hint;
    HUD.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

- (void)showHudInWindowWithhint:(NSString *)hint{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = hint;
    HUD.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
    
}

+ (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.f];
    
}

+ (void)showHudInWindowWithhint:(NSString *)hint{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.f];
}

- (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.f];
}

- (void)showHintWithView:(UIView *)view hit:(NSString *)hint{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.f];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.f];
}

- (void)showHUDInTopViewWithHint:(NSString *)hint{
    UINavigationController *viweController = (UINavigationController *)[AppDelegate getAppdelegateRootViewControoler];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:viweController.topViewController.view animated:YES];
    HUD.label.text = hint;
    HUD.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    [self setHUD:HUD];
    
}

- (void)showHUDInTopView{
    UINavigationController *viweController = (UINavigationController *)[AppDelegate getAppdelegateRootViewControoler];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:viweController.topViewController.view animated:YES];
    [self setHUD:HUD];
    
}

- (void)showHudWindowWithHint:(NSString *)hint{
    UIWindow *window = [AppDelegate getAppdelegateWindow];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    HUD.label.text = hint;
    HUD.label.font = [UIFont boldSystemFontOfSize:12.f] ;
    [self setHUD:HUD];
}

- (void)showHudWindow{
    UIWindow *window = [AppDelegate getAppdelegateWindow];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [self setHUD:HUD];
}

- (void)hideHud{
    [[self HUD] hideAnimated:YES];
}

@end
