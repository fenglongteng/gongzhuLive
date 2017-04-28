//
//  AHTabBarView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@class AHTabButton;

@interface AHTabBarView : AHBaseView

@property (nonatomic,strong)UIImageView *backImageView;

@property (nonatomic,strong)AHTabButton *currentButton;

@end
