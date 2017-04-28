//
//  NSObject+AHUntil.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "NSObject+AHUntil.h"
#import "NSDate+YYAdd.h"

@implementation NSObject (AHUntil)
+(void)pushFromVC:(UIViewController*)fromVC toVCWithName:(NSString*)toVC InTheStoryboardWithName:(NSString*)sb{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sb bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:toVC];
    [fromVC.navigationController pushViewController:viewController animated:YES];
}

//设置修改个人资料请求的组合数
+(UsersAlterInfoRequest*)getFieldOfUsersAlterInfoRequest:(UsersAlterInfoRequest*)request isEditGender:(BOOL)isEditGender isEditeGaming:(BOOL)isGaming{
    NSInteger field = 0;
    //修改密码
    if (request.password.length>0 && request.newPassword.length>0) {
        field += 1;
    }
    //修改昵称
    if (request.nickName.length>0) {
        field += 2;
    }
    //修改头像
    if (request.avatar.length>0) {
        field += 4;
    }
    //修改性别
    if (isEditGender) {
        field += 8;
    }
    //修改简介
    if (request.brief.length>0) {
        field += 16;
    }
    //修改城市名
    if (request.cityName.length>0) {
        field += 32;
    }
    //修改精度
    if (request.longitude>0) {
        field += 64;
    }
    //修改维度
    if (request.latitude>0) {
        field += 128;
    }
    //修改用户配置
    if (request.settings.length>0) {
        field += 256;
    }
    
    if (isGaming) {
        field += 512;
    }
    
    if (request.gameName.length>0) {
        field += 1024;
    }
    
    request.field = field;
    
    return request;
    
}

+(UsersAlterInfoRequest*)getFieldOfUsersAlterInfoRequest:(UsersAlterInfoRequest*)request isEditGender:(BOOL)isEditGender{
    NSInteger field = 0;
    //修改密码
    if (request.password.length>0 && request.newPassword.length>0) {
        field += 1;
    }
    //修改昵称
    if (request.nickName.length>0) {
        field += 2;
    }
    //修改头像
    if (request.avatar.length>0) {
        field += 4;
    }
    //修改性别
    if (isEditGender) {
        field += 8;
    }
    //修改简介
    if (request.brief.length>0) {
        field += 16;
    }
    //修改城市名
    if (request.cityName.length>0) {
        field += 32;
    }
    //修改精度
    if (request.longitude>0) {
        field += 64;
    }
    //修改维度
    if (request.latitude>0) {
        field += 128;
    }
    //修改用户配置
    if (request.settings.length>0) {
        field += 256;
    }
    request.field = field;
    
    return request;
}

+(NSString*)getTimeStringWithTimeStamp:(int64_t)timeStamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSInteger year = date.year;
    while (year>2020) {
        timeStamp =  timeStamp/1000;
        date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        year = date.year;
    }
    NSTimeZone *timeZone =   [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    NSString *timeString =  [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:timeZone locale:locale];
    return timeString;
}
@end
