//
//  mainHeaderView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLHBannerView.h"
@interface mainHeaderView : UIView

- (void)initWithHeaderViewFrame:(CGRect)frame ;

@property(nonatomic,copy)void (^pushBlock)(NSString * title);

- (void)startTimer;

- (void)stopTimer;

//网络图片数组
- (void)setImageUrlStrArray:(NSMutableArray *)ImageUrlStrArray WithBannerFrame:(CGRect)frame andDelegate:(id)delegate;
@end
