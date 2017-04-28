//
//  AHLiveAnchorView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"
#import "Rooms.pbobjc.h"

@interface AHLiveAnchorView : AHBaseView

@property (nonatomic,copy) void (^closeLiveBlock)();

@property (nonatomic,copy)void (^clickContributeShowBlock)();

@property (nonatomic,copy) NSString *roomId;

+ (instancetype)liveAnchorView;

@property (nonatomic,assign)BOOL isBanker;//是否是主播

@end
