//
//  AHLiveGameView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"
#import "Rooms.pbobjc.h"
#import "AHBankerToolView.h"
#import "ProtoEcho.pbobjc.h"

@interface AHLiveGameView : AHBaseView

@property (weak, nonatomic) IBOutlet UIView *bankerView;//庄家View

@property (weak, nonatomic) IBOutlet UIView *setBackView;//设置页面

@property (weak, nonatomic) IBOutlet UIButton *recordbtn;

//本家金币位置
@property (weak, nonatomic) IBOutlet UIImageView *goldImage;
//游戏区域
@property (weak, nonatomic) IBOutlet UIView *gameView;
+(id)liveGameShareView;
@property (weak, nonatomic) IBOutlet UILabel *bankerGoldLb;//庄家金币Lb
@property (weak, nonatomic) IBOutlet UILabel *goldLb;//金币
//庄家金币
@property(nonatomic,assign)int64_t bankerCoin;
//本家金币
@property (nonatomic,copy) void (^settingPopViewBlock)();//点击设置按钮

@property (nonatomic,copy) void (^popGiftViewBlock)();//点击礼物按钮

@property (nonatomic,copy) void (^popRecordBlock)();//点击记录

@property (nonatomic,copy) void (^applyBankerBlock)();//申请上下庄

@property (nonatomic,copy) void(^shareBlcok)();//分享

@property (nonatomic,copy) void (^rechargeBlock)();//充值

@property (nonatomic,copy) void (^bankerToolButtonBlock)(UIButton *sender,NSInteger btnType);//主播直播界面的toolView点击事件

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet UIButton *gameRecoder;//主播数据按钮

//天区域个人投注显示
@property (weak, nonatomic) IBOutlet UILabel *TianCount;
//地区域个人投注显示
@property (weak, nonatomic) IBOutlet UILabel *DiCount;
//人区域个人投注显示
@property (weak, nonatomic) IBOutlet UILabel *RenCount;
//天区域所有投注
@property (weak, nonatomic) IBOutlet UILabel *TianAllCount;
//地区域所有投注
@property (weak, nonatomic) IBOutlet UILabel *DiAllCount;
//人区域所有投注
@property (weak, nonatomic) IBOutlet UILabel *RenAllCount;

@property (nonatomic,strong)AHBankerToolView *bankerToolView;

//押注之后记录押注之后的金币
@property(nonatomic,assign)int64_t afterBetingCoin;

//当前游戏id
@property(nonatomic,copy)NSString * currentGameid;

//当前游戏房间id
@property(nonatomic,copy)NSString * gameRoomid;

//下注情况
- (void)otherPlayerToBetting:(DouNiuEventOnBets *)betsMessage;

//移除所有下注筹码图片
- (void)removewAllChouMaImage;

//游戏开始或结束时投注区域是否可以点击
- (void)gameWithStarting:(BOOL)isStart;

//设置游戏庄家信息
- (void)setBankerMessage:(DouNiuBanker *)roomMessage;

//根据当前金币余额设置可下注筹码类型(每次金币改变许调用一次)
- (void)ButBettingChipsWithGold:(NSString *)goldString;

- (NSString *)getCurrentGold:(int64_t)goldCoin;

//牌局结束时设置可以下注的金币
- (void)setCurrentGold:(int64_t)coin;

//下注总数全是重置
- (void)resetAllCount;

//本人当庄时，不能下注
- (void)isMeOfBankerWithBankerid:(NSString *)bankerid;

@end
