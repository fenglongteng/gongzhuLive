//
//  AHDeviceInfo.m
//  Weather
//
//  Created by luobaoyin on 16/2/26.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import "AHDeviceInfo.h"
#import "Reachability.h"
#import <sys/utsname.h>

@implementation AHDeviceInfo

+ (CGRect)bounds
{
    return [UIScreen mainScreen].bounds;
}

+ (CGFloat)systemVersion
{
    return [CURRENT_DEVICE.systemVersion floatValue] ;
}

+ (NSString*)systemName
{
    return CURRENT_DEVICE.systemName ;
}

+ (NSString*)currentLanguage
{
    return [[NSLocale preferredLanguages] objectAtIndex:0] ;
}

+ (BOOL)isIPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ;
}

+ (BOOL)isIPhone
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ;
}


+ (BOOL)isWidth320Device{
    return ([AHDeviceInfo bounds].size.width == 320) ;
}


+(NSInteger)deviceNumber{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return 4;
    if ([platform isEqualToString:@"iPhone3,2"]) return 4;
    if ([platform isEqualToString:@"iPhone3,3"]) return 4;
    if ([platform isEqualToString:@"iPhone4,1"]) return 4;
    if ([platform isEqualToString:@"iPhone5,1"]) return 5;
    if ([platform isEqualToString:@"iPhone5,2"]) return 5;
    if ([platform isEqualToString:@"iPhone5,3"]) return 5;
    if ([platform isEqualToString:@"iPhone5,4"]) return 5;
    if ([platform isEqualToString:@"iPhone6,1"]) return 5;
    if ([platform isEqualToString:@"iPhone6,2"]) return 5;
    if ([platform isEqualToString:@"iPhone7,1"]) return 7;//iphone 6plus
    if ([platform isEqualToString:@"iPhone7,2"]) return 6;
    
    return 0;
}

+ (BOOL)isLaunchFirst
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:LAUNCH_FIRST_FLAG] == nil )
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LAUNCH_FIRST_FLAG] ;
        [[NSUserDefaults standardUserDefaults] synchronize] ;
        return YES ;
    }
    return NO ;
}

+ (BOOL)isExistenceNetwork
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"https://www.baidu.com"];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        return NO;
    }
    return YES;
}

@end
