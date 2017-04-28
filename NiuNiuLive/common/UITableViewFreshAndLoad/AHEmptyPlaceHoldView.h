//
//  AHEmptyPlaceHoldView.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReloadNewData  <NSObject>

@optional
-(void)reloadNewData;

@end

@interface AHEmptyPlaceHoldView : UIView

//自定义初始化方法
-(instancetype)initWithIsHighLighted:(BOOL)hightlighted andTitle:(NSString*)title AndDelegate:(id <ReloadNewData>)delegate;

//是否高亮显示
-(void)setUpWithIsHighLighted:(BOOL)hightlighted andTitle:(NSString*)title;

//显示view 使用的时候用的#import "AHEmptyPlaceHoldView.h"  -(void)ah_reloadData;方法可以自动加载但是记得初始化AHEmptyPlaceHoldView
-(void)showOnTheView:(UIView*)view;
@end
