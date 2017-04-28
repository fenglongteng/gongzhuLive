//
//  AHAnchorLiveSettingView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/25.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"


@class AHToolBtnView;

typedef void(^toolButtonBlock)(AHToolBtnView *toolBtnView);

@interface AHAnchorLiveSettingView : AHBaseView

@property (nonatomic,copy) toolButtonBlock toolBtnBlock;

+(id)shareAnchorLiveSetting;

- (void)showAnchorLiveSetView;

- (void)dismiss;



@end
