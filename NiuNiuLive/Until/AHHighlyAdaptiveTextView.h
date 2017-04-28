//
//  JQTextView.h
//  微博项目
//
//  Created by xxjqr on 16/4/15.
//  Copyright © 2016年 xxjqr. All rights reserved.
//

/*
 使用方法:
 一:请用下面类方法
 二:如果autoFit=YES 那么textView的高度是自适应的,
    即文字的内容增多,对应textView高度加大;所以无需设置height
 三:如果autoFit=NO 反之
 */

#import <UIKit/UIKit.h>
typedef void (^SetUpViewWithKeyBoardHeight)(CGFloat,CGFloat);
@interface AHHighlyAdaptiveTextView : UITextView
@property (nonatomic,strong)UIColor *customPlaceHoderColor;
@property (nonatomic,copy)IBInspectable NSString *customPlaceHoder;
//输入框所在view
@property (nonatomic,copy)SetUpViewWithKeyBoardHeight setUpViewBlock;

@property (nonatomic,strong) NSLayoutConstraint *constrainH1;//高度约束
@end

