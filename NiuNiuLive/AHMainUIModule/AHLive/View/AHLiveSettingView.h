//
//  AHLiveSettingView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHLiveSettingView : AHBaseView

+(id)liveSetingShare;

- (void)showAnimation;
-(void)hideAnimation;

@property (nonatomic,copy) void (^historyGainsBlock)();

@property (nonatomic,assign)BOOL isNoGame;//是否在游戏

@property (nonatomic,assign)BOOL isShowGame;//是否显示游戏

@end
