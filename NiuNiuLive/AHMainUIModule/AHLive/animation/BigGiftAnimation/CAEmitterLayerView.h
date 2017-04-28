//
//  CAEmitterLayerView.h
//  Weather
//
//  Created by Anvei on 16/3/21.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAEmitterLayerView : UIView


//模拟一个抽象的父类

/*
 模仿setter,getter方法 用.语法解决设置有很多参数的问题
 */
- (void)setEmitterLayer:(CAEmitterLayer *)layer;
- (CAEmitterLayer *)emitterLayer;

//显示出当前View
- (void)show;




@end
