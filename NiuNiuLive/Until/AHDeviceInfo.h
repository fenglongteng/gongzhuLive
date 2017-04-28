//
//  AHDeviceInfo.h
//  Weather
//
//  Created by luobaoyin on 16/2/26.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LAUNCH_FIRST_FLAG                       @"LAUNCH_FIRST_FLAG"                                //第一次启动的标志

#define CURRENT_DEVICE                          ([UIDevice currentDevice])
#define DEVICE_SCREEN_BOUNDS                    ([AHDeviceInfo bounds])                                //设备屏幕Bounds
#define DEVICE_SCREEN_SIZE                      (DEVICE_SCREEN_BOUNDS.size)                            //设备屏幕Size
#define DEVICE_SCREEN_WIDTH                     (DEVICE_SCREEN_SIZE.width)                             //设备屏幕宽
#define DEVICE_SCREEN_HEIGHT                    (DEVICE_SCREEN_SIZE.height)                            //设备屏幕高

#define DEVICE_IS_IPAD                          ([AHDeviceInfo isIPad])                                //设备是否为iPad
#define DEVICE_IS_IPHONE                        ([AHDeviceInfo isIPhone])                              //设备是否为iPhone
#define DEVICE_IS_IPHONE5                       ([AHDeviceInfo isIPhone5])                             //设备是否为iPhone5
#define DEVICE_IS_IPHONE5ORHIGHER               ([AHDeviceInfo isIPhone5OrHigher])                     //设备是否为iphone5以及更高
#define DEVICE_IS_IOS7                          ([AHDeviceInfo isIOS7])                                //当前操作系统是否为ios7及以上系统
#define DEVICE_IS_IOS8                          ([AHDeviceInfo isIOS8])                                //当前操作系统是否为ios8及以上系统

/**
 *  设备信息
 */
@interface AHDeviceInfo : NSObject


/**
 * 屏幕大小 CGRect
 **/
+ (CGRect)bounds;

/**
 * 操作系统版本
 **/
+ (CGFloat)systemVersion;

/**
 * 操作系统名称
 **/
+ (NSString*)systemName;

/**
 * 当前操作系统使用的语言
 **/
+ (NSString*)currentLanguage;

/**
 * 当前设备是否是iPad
 **/
+ (BOOL)isIPad;

/**
 * 当前设备是否是iPhone
 **/
+ (BOOL)isIPhone;

/**
 * 设备宽度是否是320
 **/
+ (BOOL)isWidth320Device;

//次方法调用有问题，模拟器测试5s返回的是0
/**
 *  获取设备型号
 */
+ (NSInteger)deviceNumber;

/**
 *	是否是第一次启动
 **/
+ (BOOL)isLaunchFirst;

/**
 *  检测是否有网络
 *
 *  @return 是否
 */
+ (BOOL)isExistenceNetwork;



@end
