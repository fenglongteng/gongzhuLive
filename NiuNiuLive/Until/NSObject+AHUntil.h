//
//  NSObject+AHUntil.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NSObject (AHUntil)

/**
 //跳转到storyboard中的控制器

 @param fromVC 跳转起始控制器
 @param toVC 跳转目标控制器 控制器的identifier（AHStoryboard中的）
 @param sb sb文件名称
 */
+(void)pushFromVC:(UIViewController*)fromVC toVCWithName:(NSString*)toVC InTheStoryboardWithName:(NSString*)sb;

/**
设置修改个人资料请求的组合数

 @param request 修改请求
 @param isEditGender 是否修改性别
 @param isGaming 是否修改正在游戏
 @return 修改请求
 */
+(UsersAlterInfoRequest*)getFieldOfUsersAlterInfoRequest:(UsersAlterInfoRequest*)request isEditGender:(BOOL)isEditGender isEditeGaming:(BOOL)isGaming;


/**
 设置修改个人资料请求的组合数
 
 @param request 修改请求
 @param isEditGender 是否修改性别
 @return 修改请求
 */

+(UsersAlterInfoRequest*)getFieldOfUsersAlterInfoRequest:(UsersAlterInfoRequest*)request isEditGender:(BOOL)isEditGender;


/**
 把时间戳转换为时间字符串

 @param timeStamp 时间戳
 @return 时间字符串
 */
+(NSString*)getTimeStringWithTimeStamp:(int64_t)timeStamp;
@end
