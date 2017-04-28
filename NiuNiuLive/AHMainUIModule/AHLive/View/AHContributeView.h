//
//  AHContributeView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
// 贡献榜

#import "AHBaseView.h"

@interface AHContributeView : AHBaseView

+ (id)contributeShareView;

@property (nonatomic,copy) void (^meKnowBlock)();//贡献榜弹出框
@end
