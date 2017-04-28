//
//  gameRemind.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/1.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHLiveGameView.h"
#import "ProtoEcho.pbobjc.h"
#import <AVFoundation/AVFoundation.h>

@interface gameRemind : UIView

+ (gameRemind *)initGameRemindView;

//牌局开始时调用(需要传入当前游戏界面) 传入服务器的押注时间
- (void)startGameWithView:(AHLiveGameView *)gameView betTime:(int)betTime;

//显示休息一下View
- (void)showHaveRestView;

@property(nonatomic,strong)AVAudioPlayer * ringPlayer;


//牌局结束Block
@property(nonatomic,copy)void (^finishBlock)();

//ui倒计时结束 开始发牌
@property(nonatomic,copy)void (^licensingBlock)(gameRemind * gameremindView);

//开始发牌(传入扑克数据)
- (void)startLicensing:(DouNiuEventGameResult *)pokerMessage;

//服务器出牌了,也要传游戏界面
- (void)licensingOfServiceWithTag:(DouNiuEventGameResult *)result gameView:(AHLiveGameView *)gameView;

//下注倒计时,是否已经是下注阶段
- (void)clockStarting:(int)betTime isEnterGameBetingStatus:(BOOL)isBeting;
@end
