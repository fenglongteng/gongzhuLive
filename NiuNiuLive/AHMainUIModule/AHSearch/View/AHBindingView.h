//
//  AHBindingView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
// 绑定界面

#import <UIKit/UIKit.h>

@class AHBindingView;

typedef NS_ENUM(NSInteger, AHBingViewType) {
    AHBingPhone,
    AHBingWeibo,
};

@protocol AHBingViewDelegate <NSObject>

@optional

- (void)bingAccount:(AHBindingView *)bingView;

@end

@interface AHBindingView : UIView

@property (nonatomic,assign)AHBingViewType bingType;

@property (nonatomic,weak)id<AHBingViewDelegate>delegate;

- (void)hideBingView;

@end
