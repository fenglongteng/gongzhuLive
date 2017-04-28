//
//  MBProgressHUDHelper.m
//  iSecurity Camera 5.4
//
//  Created by smailant on 13-4-16.
//  Copyright (c) 2013年 smailant. All rights reserved.
//

#import "CCHUD.h"
#import "AppDelegate.h"

@implementation CCHUD


+ (MBProgressHUD*)showLoadingView:(NSString*)strText superView:(UIView*)superView
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:superView animated:YES] ;
    hud.alpha = 0.5 ;
    hud.opaque = YES ;
    hud.label.text = strText ;
    hud.label.font = [UIFont boldSystemFontOfSize:12] ;
    hud.mode = MBProgressHUDModeIndeterminate ;
    hud.removeFromSuperViewOnHide = YES ;
    return hud ;
}

+ (MBProgressHUD*)showProgressView:(NSString*)strText superView:(UIView*)superView
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:superView animated:YES] ;
    hud.bezelView.alpha = 0.5 ;
    hud.opaque = YES ;
    hud.label.text = strText ;
    hud.mode = MBProgressHUDModeAnnularDeterminate ;// : MBProgressHUDModeDeterminate ;
    hud.removeFromSuperViewOnHide = YES ;
    return hud ;
}

+(void)showCustomHUD:(NSString *)imageName superView:(UIView*)superView message:(NSString *)message
{
    MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    HUD.detailsLabel.text = message;
    HUD.label.font = [UIFont boldSystemFontOfSize:12] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] ;
    [HUD hideAnimated:YES afterDelay:2];
}

+ (void)showTip:(NSString*)strText
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[CCHUD getNavigationTopControllerView] animated:YES] ;
    hud.bezelView.alpha = 0.7 ;
    hud.opaque = YES ;
    hud.detailsLabel.text = strText ;
    hud.label.font = [UIFont boldSystemFontOfSize:12] ;
    hud.mode = MBProgressHUDModeText ;
    hud.removeFromSuperViewOnHide = YES ;
    [hud hideAnimated:YES afterDelay:1.5];
}

+(void)showTip:(NSString *)strText view:(UIView *)showView
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:showView animated:YES] ;
    hud.bezelView.alpha = 0.7 ;
    hud.opaque = YES ;
    hud.detailsLabel.text = strText ;
    hud.label.font = [UIFont boldSystemFontOfSize:12] ;
    hud.mode = MBProgressHUDModeText ;
    hud.removeFromSuperViewOnHide = YES ;
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showTip{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[CCHUD getNavigationTopControllerView] animated:YES] ;
    hud.bezelView.alpha = 0.7 ;
    hud.opaque = YES ;
    hud.detailsLabel.text = NSLocalizedString(@"HUD.failed","") ;
    hud.mode = MBProgressHUDModeText ;
    hud.removeFromSuperViewOnHide = YES ;
    [hud hideAnimated:YES afterDelay:1.5];
    
}

+ (void)showTipByView:(UIView *)view{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES] ;
    hud.bezelView.alpha = 0.7 ;
    hud.opaque = YES ;
    hud.detailsLabel.text = @"Failed to connect Server." ;
    hud.mode = MBProgressHUDModeText ;
    hud.removeFromSuperViewOnHide = YES ;
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (UIView *)getNavigationTopControllerView{
    UIViewController *topVC = [AppDelegate getNavigationTopController];
    if (topVC) {
        return topVC.view;
    }
    return [[UIView alloc] init];
}

@end
