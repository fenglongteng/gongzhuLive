//
//  UITextView+placehold.h
//  Weather
//
//  Created by ComAnvei on 16/11/9.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

@interface UITextView (placehold)
/**
 
 *利用运行时动态添加的属性
 
 */

@property(nonatomic,strong)UITextView*placeHolderTextView;

/**
 
 *设置placeHoloder.placeHoloder颜色默认为灰色
 
 *
 
 *@param placeHolder
 
 */

- (void)addPlaceHolder:(NSString*)placeHolder;

/**
 
 *设置placeHoloder.placeHoloder颜色默认为自定义
 
 *
 
 *@param placeHolderplaceHolder
 
 *@param placeHoloderTextColor自定义颜色
 
 */

- (void)addPlaceHolder:(NSString*)placeHolder placeHoloderTextColor:(UIColor*)placeHoloderTextColor;

-(void)hidePlaceHold;

#pragma mark - textview上面添加lable方式
@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
