//
//  AHTool.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/29.
//  Copyright © 2017年 AH. All rights reserved.
//工具头文件 代码工具


#ifndef AHTool_h
#define AHTool_h

#define screenWidth   [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height
#define screenSize    [UIScreen mainScreen].bounds.size
#define DeviceScale   [UIScreen mainScreen].scale

#define tabBarHeight    49
#define navHeight       64
#define statusHeight    20

#define iPhone4ScreenWidth       320
#define iPhone4ScreenHeight      480
#define iPhone5ScreenHeight      568
#define iPhone6PScreenWidth      414
#define iPhone6PScreenHeight     736
#define iPhone6ScreenWidth       375
#define iPhone6ScreenHeight      667


//图片宏
#define ImageNamed(imageName) [UIImage imageNamed:@"imageName"]

//debug模式下打印日志。
#ifdef DEBUG
#   define LOG(fmt, ...)                                             NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define LOG(...)
#endif


//RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

// 设置颜色宏
#define BYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define AHColor(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

//弱引用self宏
#define WeakSelf __weak typeof(self) weakSelf = self
#define AHWeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf

#define DefaultHeadImage [UIImage imageNamed:@"image_user_def"]

#endif /* AHTool_h */
