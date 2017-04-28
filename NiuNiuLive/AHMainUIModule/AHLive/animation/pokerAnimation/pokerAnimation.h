//
//  pokerAnimation.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHLiveGameView.h"
#import "gameRemind.h"
#import <AVFoundation/AVFoundation.h>
#import "ProtoEcho.pbobjc.h"

@interface pokerAnimation : NSObject<CAAnimationDelegate>

@property(nonatomic,strong) NSMutableArray * pokerImageArray;
//4个玩家的最后一张牌数组
@property(nonatomic,strong)NSMutableArray * lastPokerArray;
//发牌的图片数组
@property(nonatomic,strong)NSMutableArray * backPokers;

@property(nonatomic,strong)AHLiveGameView * gameView;
//游戏视图下滑之后修改开始值
@property(nonatomic,assign)CGFloat xiaHeight;
//翻牌动画下标
@property(nonatomic,assign)NSInteger index;

@property(nonatomic,assign)BOOL isStop;

+ (pokerAnimation *)pokerAnimation;
//洗牌(传入扑克数据数组)
- (void)initWithPoker:(gameRemind *)remindView pokerMessage:(DouNiuEventGameResult *)pokers gameView:(AHLiveGameView *)gameView;

- (void)removeAllPokerImage;

//给4个玩家发牌
- (void)licensingToPlayers:(UIView *)gameView;

//翻牌(从庄开始翻)
- (void)FlipCARDS:(NSInteger)count;
//进入房间时，游戏已经过了押注时间
- (void)inTheGame;

//进入游戏时，如果已经是发牌阶段则直接显示扑克信息
- (void)dealCardsWithPokersMessageArray:(NSArray *)pokersArray gameView:(AHLiveGameView *)gameview;

//洗牌播放
- (void)ShuffleTheDeckSound;

//发牌播放
- (void)licensingSound;

//结束播放
- (void)finishSound;

//开局时播放
- (void)startGameSound;

//下注播放
- (void)betingSound;

//销毁内存
+ (void)destructionDealloc;

@end
