//
//  UIImage+extension.h
//  wisdomWiFi
//
//  Created by anhui on 16/10/21.
//  Copyright © 2016年 anhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extension)


/**
 生成圆形图片

 @param rect 图片大小
 @param blockImage 图片剪切成功后回调block
 */
-(void)iamgeClipWithRect:(CGSize)rect block:(void(^)(UIImage *result))blockImage;

/**
 生成圆形图片

 @param size 图片大小
 @return 返回图片
 */
-(UIImage *)iamgeClipWithRect:(CGSize)size;

/**
 用颜色生成图片

 @param color 颜色
 @param size 图片大小
 @return 图片
 */
+(UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)size;

/**
 *  图片圆形加边框
 *
 *  @param name        图片名称
 *  @param borderWidth 边框大小
 *  @param borderColor 边框颜色
 *
 *  @return 处理后的图片
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  图片圆形加边框
 *
 *  @param oldImage    图片
 *  @param borderWidth 边框大小
 *  @param borderColor 边框颜色
 *
 *  @return 处理后的图片
 */
+ (instancetype)circleImageWithImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 给图片设置圆角

 @param radius 圆角半径
 @return 新图片
 */
- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

@end
