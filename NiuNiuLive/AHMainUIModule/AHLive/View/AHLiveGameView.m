//
//  AHLiveGameView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLiveGameView.h"
#import "AHLiveMessageCell.h"
#import "DHAnimation.h"
#import "AHBarrageInputBoxView.h"
#import "AHDirectMessagesView.h"
#import "ProtoEcho.pbobjc.h"
#import "GameSocketManager.h"
#import "Messages.pbobjc.h"
#import "SVProgressHUD.h"
#import "Gifts.pbobjc.h"
#import "baseRedPacket.h"
#import <AVFoundation/AVFoundation.h>
#import "AHBarrageViewController.h"
#import "AHLiveMessageObject.h"
#import "GiftBase.h"

@interface AHLiveGameView ()<UITableViewDelegate,UITableViewDataSource,AHBankerToolViewDelegate>{
    //天下注多少
    int _tianF;
    //地下注多少
    int _diF;
    //人下注多少
    int _renF;
    //上一次天、地、人的金币总数
    int64_t _lastTian;
    int64_t _lastDi;
    int64_t _lastRen;
    //天总下注
    int64_t _tianAllF;
    int64_t _diAllF;
    int64_t _renAllF;
    AVAudioPlayer * _ringPlayer;
    //是否可以开始下注
    BOOL isBet;
    //记录押了一注之后的金币，以判断是否还可以下注
    int64_t _currentGold;
    //记录选中的筹码下标
    NSInteger _currentSelected;
    //是否已经显示过提示
    BOOL _isShow;
    //当前庄的id；
    NSString * _bankerid;
    //是本人当庄
    BOOL _isMeBanker;
    //庄家的金币数
    int64_t _bankerCoin;
}

@property (weak, nonatomic) IBOutlet UILabel *bankerName;
@property (weak, nonatomic) IBOutlet UIImageView *zhuangHeadImageView;

@property (weak, nonatomic) IBOutlet UIView *bankerGoldView;
@property (weak, nonatomic) IBOutlet UIScrollView *goldScrollView;//金币滑动scrollView
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (nonatomic,strong)NSMutableArray *messages;//推送的消息
@property (nonatomic,strong)getRedView *redPacketGetView;//抢红包界面

@property (nonatomic,assign)CGPoint beginPoint;
@property (nonatomic,assign)CGPoint movePoint;

@property (weak, nonatomic) IBOutlet UIImageView *cathecticTian;//投注天的区域
@property (weak, nonatomic) IBOutlet UIImageView *cathecticDi;//投注地区域
@property (weak, nonatomic) IBOutlet UIImageView *cathecticRen;//投注人区域
//筹码按钮数组
@property (nonatomic,strong)NSMutableArray * btnArray;
//动画闪烁圈圈View
@property(nonatomic,strong)UIView * animationView;
//每个筹码的外圈闪烁View
@property(nonatomic,strong)NSMutableArray * viewArray;
//当前选择筹码的下标
@property(nonatomic,assign)NSInteger currentIndex;
//所有筹码图片，牌局结束时全部移除
@property(nonatomic,strong)NSMutableArray *choumaArray;
//弹幕数组
//@property(nonatomic,strong)NSMutableArray *barrageArray;
//弹幕试图
@property(nonatomic,strong)AHBarrageViewController *barrageViewController;
//头部第一次进入 按钮及消息
@property (weak, nonatomic) IBOutlet UIButton *messageActtentBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageActtentLb;

@property (nonatomic,strong)DouNiuBanker *gameZhuanInfo;

@end

#define touchDistance 100
//偏移
#define touchPy  10

@implementation AHLiveGameView


+(id)liveGameShareView{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    //拿到当前用户的金币数
    self.afterBetingCoin = [[AHPersonInfoManager manager] getInfoModel].goldCoins;
    self.goldLb.text = [self getCurrentGold:[[AHPersonInfoManager manager] getInfoModel].goldCoins];
    _zhuangHeadImageView.userInteractionEnabled = YES;
    _zhuangHeadImageView.layer.cornerRadius = _zhuangHeadImageView.height*0.5;
    _bankerGoldView.layer.cornerRadius = _bankerGoldView.height*0.5;
    self.btnArray = [NSMutableArray array];
    self.viewArray = [NSMutableArray array];
    self.choumaArray = [NSMutableArray array];
    self.messages = [NSMutableArray array];
    //初始化当前可以下注的金币
    _currentGold = [[AHPersonInfoManager manager] getInfoModel].goldCoins;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserImageView:)];
    [_zhuangHeadImageView addGestureRecognizer:tap];
    
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    [self.messageTableView registerNib:[UINib nibWithNibName:@"AHLiveMessageCell" bundle:nil] forCellReuseIdentifier:@"liveMessageCell"];
    [self.messageTableView setContentOffset:CGPointMake(0, self.messageTableView.height) animated:YES];
    [self createGoldButton];
    
    [self createCathecticViewTapGesture];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameViewDown:) name:kNotifiGameSwipeDown object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameViewUp:) name:kNotifiGameSwipeUp object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userGoldChange:) name:UserGoldDidChange object:nil];
    
    [self createMessageBlock];
    
    [self getGiftPushMessage];
}

- (void)setBankerMessage:(DouNiuBanker *)roomMessage{
    
    _gameZhuanInfo = roomMessage;
    
    long bankercoin = roomMessage.coin;
    self.bankerCoin = roomMessage.coin;
    if (self.bankerCoin >= 100000000) {
        self.bankerGoldLb.text = [NSString stringWithFormat:@"%.2f亿",(bankercoin / 100000000.0)];
    }else{
        self.bankerGoldLb.text = [NSString stringWithFormat:@"%.2fW",(bankercoin / 10000.0)];
    }
    [self.zhuangHeadImageView sd_setImageWithURL:[NSURL URLWithString:roomMessage.icon] placeholderImage:[UIImage imageNamed:@"logo_500.jpg"]];
    
    if (roomMessage.isSystem == YES) {
        self.bankerName.text = @"系统荷官";
    }else{
        self.bankerName.text = roomMessage.nickName;
    }
    _bankerCoin = roomMessage.coin;
}

- (void)isMeOfBankerWithBankerid:(NSString *)bankerid{
    _bankerid = bankerid;
}

#pragma mark - 获得礼物通知

- (void)getGiftPushMessage{
    
    WeakSelf;
    [[AHTcpApi shareInstance]query:@"PushGift" andHandler:^(id message, NSData *bodyData) {
        PushGift *pushGift = (PushGift *)message;
        if (pushGift.gift.type == 1) {
            //抢红包
            getRedView * getRedView = [baseRedPacket initWithGetRed:pushGift];
            weakSelf.redPacketGetView = getRedView;
            PushMessage *pushMessage = [[PushMessage alloc]init];
            pushMessage.fromUserId = pushGift.fromUserId;
            pushMessage.nickName = pushGift.nickName;
            pushMessage.level = pushGift.level;
            pushMessage.subType = 10;
            pushMessage.message = [NSString stringWithFormat:@"发送了一个%lld游戏币的红包",pushGift.gift.goldCoins];
            [weakSelf.messages addObject:[weakSelf statusLiveMessage:pushMessage]];
        }
        //普通礼物
        if (pushGift.gift.type == 0) {
            GiftBase *giftAnimation = [GiftBase initGiftType];
            [giftAnimation baseGiftAnimationWithModel:pushGift backView:weakSelf];
            PushMessage *pushMessage = [[PushMessage alloc]init];
            pushMessage.fromUserId = pushGift.fromUserId;
            pushMessage.nickName = pushGift.nickName;
            pushMessage.level = pushGift.level;
            pushMessage.subType = 5;
            pushMessage.message = [NSString stringWithFormat:@"送给主播%d%@",pushGift.count,pushGift.gift.name];
            [weakSelf.messages addObject:[weakSelf statusLiveMessage:pushMessage]];
        }
        [weakSelf.messageTableView reloadData];
        [weakSelf srollToBottom];
        
    }];
}

#pragma mark -获得消息通知
- (void)createMessageBlock{
    
    //获得消息的推送通知
    WeakSelf;
    [[AHTcpApi shareInstance]query:@"PushMessage" andHandler:^(id message, NSData *bodyData) {
        
        PushMessage *pushMessage = (PushMessage*)message;
        AHLiveMessageObject *lastMessage = [weakSelf.messages lastObject];
        if (pushMessage.subType == 1 && lastMessage.message.subType == 1) {
            
            [weakSelf.messages replaceObjectAtIndex:weakSelf.messages.count-1 withObject:[weakSelf statusLiveMessage:pushMessage]];
            
            [weakSelf.messageTableView reloadData];
            
            [weakSelf srollToBottom];
            
            return ;
        }
        [weakSelf.messages addObject:[weakSelf statusLiveMessage:pushMessage]];
        
        if (pushMessage.type == MessageType_MessageTypeFlowText) {
            //弹幕
            [weakSelf.barrageViewController addBarrageDArrayOfEmoDanmakuItemData:@[pushMessage]];
        }
        [weakSelf.messageTableView reloadData];
        
        [weakSelf srollToBottom];
    }];
}

#pragma mark -处理消息模型进行转化

- (AHLiveMessageObject *)statusLiveMessage:(PushMessage *)message{
    
    AHLiveMessageObject *liveMessage = [[AHLiveMessageObject alloc]init];
    
    liveMessage.message = message;
    
    return liveMessage;
}

- (void)srollToBottom{
    
    if (self.messages.count > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (AHBankerToolView *)bankerToolView{
    
    if (_bankerToolView == nil) {
        AHBankerToolView *bankToolView = [[[NSBundle mainBundle]loadNibNamed:@"AHBankerToolView" owner:nil options:nil] firstObject];
        _bankerToolView = bankToolView;
        bankToolView.delegate = self;
        [self.gameView addSubview:bankToolView];
        [bankToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.right.equalTo(@0);
            make.height.equalTo(@45);
        }];
    }
    return _bankerToolView;
}


//弹幕view
-(AHBarrageViewController*)barrageViewController{
    if (!_barrageViewController) {
        _barrageViewController = [[AHBarrageViewController alloc]init];
        [self insertSubview:_barrageViewController.view atIndex:0];
    }
    return _barrageViewController;
}

#pragma mark -AHBankerToolViewDelegate

- (void)bankerToolViewButton:(UIButton *)button type:(NSInteger)buttonType{
    //根基点击了 tool的按钮进行处理操作
    if (self.bankerToolButtonBlock) {
        self.bankerToolButtonBlock(button,buttonType);
    }
}

// 天 地 人 区域 点击事件
- (void)createCathecticViewTapGesture{
    
    UITapGestureRecognizer *tianTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cathecticTapGesture:)];
    [self.cathecticTian addGestureRecognizer:tianTap];
    
    UITapGestureRecognizer *diTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cathecticTapGesture:)];
    [self.cathecticDi addGestureRecognizer:diTap];
    
    UITapGestureRecognizer *renTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cathecticTapGesture:)];
    
    [self.cathecticRen addGestureRecognizer:renTap];
    
}

//点击投注区域 进行动画展现
- (void)cathecticTapGesture:(UITapGestureRecognizer *)tapGesture{
    
    if ([_bankerid isEqualToString:[[AHPersonInfoManager manager] getInfoModel].userId]) {
        [SVProgressHUD showInfoWithStatus:@"您是庄家，不能下注！"];
        _isMeBanker = YES;
        self.cathecticDi.userInteractionEnabled = NO;
        self.cathecticRen.userInteractionEnabled = NO;
        self.cathecticTian.userInteractionEnabled = NO;
        return;
    }else{
        self.cathecticDi.userInteractionEnabled = YES;
        self.cathecticRen.userInteractionEnabled = YES;
        self.cathecticTian.userInteractionEnabled = YES;
        _isMeBanker = NO;
    }
    
    NSArray * coinArray = @[@100,@1000,@10000,@100000,@500000,@1000000];
    int32_t coin = 0;
    if (_currentIndex >= 0) {
        coin = [coinArray[_currentIndex] intValue];
    }
    if (_currentIndex < 0 && _isShow == NO) {
        [SVProgressHUD showInfoWithStatus:@"当前金币不足"];
        _isShow = YES;
        return;
    }
    if (_bankerCoin < coin * 5) {
        [SVProgressHUD showInfoWithStatus:@"庄家金币不足，不能继续下注"];
        self.cathecticDi.userInteractionEnabled = NO;
        self.cathecticRen.userInteractionEnabled = NO;
        self.cathecticTian.userInteractionEnabled = NO;
        return;
    }else{
        self.cathecticDi.userInteractionEnabled = YES;
        self.cathecticRen.userInteractionEnabled = YES;
        self.cathecticTian.userInteractionEnabled = YES;
    }
    //小于500不能下注
    if ([[AHPersonInfoManager manager] getInfoModel].goldCoins < 500 || isBet == NO || _currentGold < coin * 5) {
        [_ringPlayer stop];
        //警告
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"xizhushibai" ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
        
        _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [_ringPlayer setVolume:1];
        _ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
        if([_ringPlayer prepareToPlay])
        {
            [_ringPlayer play]; //播放
        }
        if (isBet == NO) {
            [SVProgressHUD showInfoWithStatus:@"现在不能下注"];
        }else{
            if (_isShow == NO) {
                [SVProgressHUD showInfoWithStatus:@"当前金币不足"];
            }
        }
    }else{
        //筹码宽高
        CGFloat width = 25.0 * screenWidth / 375;
        NSInteger tag = [tapGesture.view tag];
        NSArray * goldImages = @[@"icon_game_gold100",@"icon_game_gold1000",@"icon_game_gold1w",@"icon_game_gold10w",@"icon_game_gold50w",@"icon_game_gold100w"];
        UIImageView * imageView;
        if (_currentIndex >= 0) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:goldImages[_currentIndex]]];
            [self.choumaArray addObject:imageView];
        }
        CGFloat y = (70 + (arc4random() % (int)(145 - width - 70 + 1)));
        switch (tag) {
            case 200:{//天
                CGFloat x = arc4random()% (int)(CGRectGetMaxX(self.cathecticTian.frame) - width - self.cathecticTian.frame.origin.x + 1)  + self.cathecticTian.frame.origin.x;
                imageView.frame = CGRectMake(x, y, width, width);
                [self.gameView addSubview:imageView];
            } break;
            case 201:{//地
                CGFloat x = arc4random()% (int)(CGRectGetMaxX(self.cathecticDi.frame) - width - self.cathecticDi.frame.origin.x + 1)  + self.cathecticDi.frame.origin.x;
                imageView.frame = CGRectMake(x, y, width, width);
                [self.gameView addSubview:imageView];
                
            }break;
            case 202:{//人
                CGFloat x = arc4random()% (int)(CGRectGetMaxX(self.cathecticRen.frame)- width - self.cathecticRen.frame.origin.x + 1 )  + self.cathecticRen.frame.origin.x;
                imageView.frame = CGRectMake(x, y, width, width);
                [self.gameView addSubview:imageView];
            }
                break;
            default:
                break;
        }
        CGRect btnRect = ((UIButton *)(self.btnArray[_currentIndex])).frame;
        CGRect srcollRect = [self.gameView convertRect:btnRect fromView:self.goldScrollView];
        DHAnimation * animation = [DHAnimation animationWithDuration:0.5 fromValue:[NSValue valueWithCGRect:srcollRect] toValue:[NSValue valueWithCGRect:imageView.frame] animationBlock:^(id animationValue) {
            imageView.frame = [animationValue CGRectValue];
        }];
        animation.beginTime = CACurrentMediaTime();
        animation.animationCurve = DHAnimationCurveEaseOut;
        [animation runAnimation];
        [self TouZhuLabelTextWithTag:tag];
    }
}

- (void)TouZhuLabelTextWithTag:(NSInteger)Tag{
    NSArray * coinArray = @[@100,@1000,@10000,@100000,@500000,@1000000];
    int32_t coin = 0;
    if (_currentIndex >= 0) {
        coin = [coinArray[_currentIndex] intValue];
    }
    //下注请求
    DouNiuBetOne * req = [[DouNiuBetOne alloc]init];
    req.gameId = self.currentGameid;
    req.roomId = self.gameRoomid;
    req.bet = [DouNiuBet new];
    if (Tag == 200) {
        req.bet.betOn = BetOnTypes_Botone;
        req.bet.coin = coin; //多少金币
    }else if(Tag == 201){
        req.bet.betOn = BetOnTypes_Bottow;
        req.bet.coin = coin; //多少金币
    }else{
        req.bet.betOn = BetOnTypes_Botthree;
        req.bet.coin = coin; //多少金币
    }
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuBetOne andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
        
        ResponseStatus * res = GetMessage(ResponseStatus ,body);
        //扣金币
        if (res.status == 0) {
            if (Tag == 200) {
                _tianF += coin;
                if (_tianF >= 10000) {
                    self.TianCount.text = [NSString stringWithFormat:@"%.2fW",(_tianF / 10000.0)];
                }else{
                    self.TianCount.text = [NSString stringWithFormat:@"%d",_tianF];
                }
            }else if(Tag == 201){
                _diF += coin;
                if (_diF >= 10000) {
                    self.DiCount.text = [NSString stringWithFormat:@"%.2fW",(_diF / 10000.0)];
                }else{
                    self.DiCount.text = [NSString stringWithFormat:@"%d",_diF];
                }
            }else{
                _renF += coin;

                if (_renF >= 10000) {
                    self.RenCount.text = [NSString stringWithFormat:@"%.2fW",(_renF / 10000.0)];
                }else{
                    self.RenCount.text = [NSString stringWithFormat:@"%d",_renF];
                }
            }
            _currentGold = _currentGold - coin * 5;
            self.afterBetingCoin = self.afterBetingCoin - coin;
            self.goldLb.text = [self getCurrentGold:self.afterBetingCoin];
            [self ButBettingChipsWithGold:[self getCurrentGold:_currentGold]];
        }
        return 0;
    }];
}

- (void)otherPlayerToBetting:(DouNiuEventOnBets *)betsMessage{
    _bankerCoin = _bankerCoin - betsMessage.allBetsArray[0].coin - betsMessage.allBetsArray[1].coin - betsMessage.allBetsArray[2].coin;
    //区域需要增加的金币数
    for (int i = 0; i < betsMessage.userBetsArray.count; i++) {
        [self animationWithAddType:((DouNiuUserBet *)betsMessage.userBetsArray[i]).bet.betOn coin:((DouNiuUserBet *)betsMessage.userBetsArray[i]).bet.coin betUserid:betsMessage.userBetsArray[i].userId];
    }
    _tianAllF = betsMessage.allBetsArray[0].coin;
    _diAllF = betsMessage.allBetsArray[1].coin;
    _renAllF = betsMessage.allBetsArray[2].coin;
    if (_tianAllF >= 10000) {
        self.TianAllCount.text = [NSString stringWithFormat:@"%.2fW",_tianAllF / 10000.0];
    }else{
        self.TianAllCount.text = [NSString stringWithFormat:@"%lld",_tianAllF];
    }
    if (_diAllF >= 10000) {
        self.DiAllCount.text = [NSString stringWithFormat:@"%.2fW",_diAllF / 10000.0];
    }else{
        self.DiAllCount.text = [NSString stringWithFormat:@"%lld",_diAllF];
    }
    if (_renAllF >= 10000) {
        self.RenAllCount.text = [NSString stringWithFormat:@"%.2fW",_renAllF / 10000.0];
    }else{
        self.RenAllCount.text = [NSString stringWithFormat:@"%lld",_renAllF];
    }
    
}

//计算天 地 人 需要增加的筹码数
- (void)animationWithAddType:(NSInteger)type coin:(int64_t)coin betUserid:(NSString *)userid{
    if ([userid isEqualToString:[[AHPersonInfoManager manager] getInfoModel].userId]) {
        return;
    }else{
        //筹码宽高
        CGFloat width = 25.0 * screenWidth / 375;
        NSArray * goldImages = @[@"icon_game_gold100",@"icon_game_gold1000",@"icon_game_gold1w",@"icon_game_gold10w",@"icon_game_gold50w",@"icon_game_gold100w"];
        UIImageView * image = [[UIImageView alloc] init];
        //天区域
        CGFloat x = arc4random()% (int)(CGRectGetMaxX(self.cathecticTian.frame) - width - self.cathecticTian.frame.origin.x + 1)  + self.cathecticTian.frame.origin.x;
        //地区域
        CGFloat x1 = arc4random()% (int)(CGRectGetMaxX(self.cathecticDi.frame) - width - self.cathecticDi.frame.origin.x + 1)  + self.cathecticDi.frame.origin.x;
        //人区域
        CGFloat x2 = arc4random()% (int)(CGRectGetMaxX(self.cathecticRen.frame)- width - self.cathecticRen.frame.origin.x + 1 )  + self.cathecticRen.frame.origin.x;
        CGFloat y = (70 + (arc4random() % (int)(145 - width - 70 + 1)));
        switch (type) {
            case 1:
                image.frame = CGRectMake(x, y, width, width);
                break;
            case 2:
                image.frame = CGRectMake(x1, y, width, width);
                break;
            case 3:
                image.frame = CGRectMake(x2, y, width, width);
                break;
            default:
                break;
        }
        switch (coin) {
            case 100:
                image.image = [UIImage imageNamed:goldImages[0]];
                break;
            case 1000:
                image.image = [UIImage imageNamed:goldImages[1]];
                break;
            case 10000:
                image.image = [UIImage imageNamed:goldImages[2]];
                break;
            case 100000:
                image.image = [UIImage imageNamed:goldImages[3]];
                break;
            case 500000:
                image.image = [UIImage imageNamed:goldImages[4]];
                break;
            case 1000000:
                image.image = [UIImage imageNamed:goldImages[5]];
                break;
            default:
                break;
        }
        [UIView animateWithDuration:0.1 animations:^{
            [self.gameView addSubview:image];
        }];
        [self.choumaArray addObject:image];
    }
    
}

- (void)gameWithStarting:(BOOL)isStart{
    if (isStart == YES) {
        isBet = YES;
    }else{
        isBet = NO;
        [self resetAllCount];
    }
}

- (void)resetAllCount{
    _renF = 0;
    _tianF = 0;
    _diF = 0;
    _renAllF = 0;
    _tianAllF = 0;
    _diAllF = 0;
    _isShow = NO;
}

- (void)removewAllChouMaImage{
    
    for (UIImageView * image in self.choumaArray) {
        [image removeFromSuperview];
    }
    [self.choumaArray removeAllObjects];
}

- (void)tapUserImageView:(UITapGestureRecognizer *)tapGesture{
    
    NSString *owenerId = self.gameZhuanInfo.id_p; //庄家ID
    if (owenerId) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifyClickUser object:nil userInfo:@{@"userId" : owenerId}];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBankerClickUser object:nil userInfo:@{@"userId" : owenerId}];
    }
}

- (void)gameViewDown:(NSNotification *)notif{
    
    self.bankerView.hidden = YES;
    self.recordbtn.hidden = YES;
    self.rechargeBtn.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 210);
    }];
}

- (void)gameViewUp:(NSNotification *)notif{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.bankerView.hidden = NO;
        self.recordbtn.hidden = NO;
        self.rechargeBtn.hidden = NO;
    }];
}

- (void)createGoldButton{
    
    NSArray * goldImages = @[@"icon_game_gold100",@"icon_game_gold1000",@"icon_game_gold1w",@"icon_game_gold10w",@"icon_game_gold50w",@"icon_game_gold100w"];
    NSInteger count = goldImages.count;
    _currentIndex = 0;
    _currentSelected = 0;
    for (int i=0; i<count; i++) {
        UIButton *goldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goldBtn.frame = CGRectMake(i*32+((i+1)*12), 2, 32, 32);
        [goldBtn setImage:[UIImage imageNamed:goldImages[i]] forState:UIControlStateNormal];
        [goldBtn addTarget:self action:@selector(betGoldClick:) forControlEvents:UIControlEventTouchUpInside];
        goldBtn.enabled = NO;
        goldBtn.tag = 1000 + i;
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        backView.center = goldBtn.center;
        backView.clipsToBounds = YES;
        backView.layer.cornerRadius = 17.5;
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.borderWidth = 4.f;
        backView.layer.borderColor = [UIColor whiteColor].CGColor;
        backView.alpha = 0;
        if (i == 0 && [[AHPersonInfoManager manager] getInfoModel].goldCoins >= 500) {
            self.animationView = backView;
            goldBtn.selected = YES;
            //默认100筹码被点击
            [self animationWithSelectedBtn];
        }
        [self.goldScrollView addSubview:backView];
        [self.goldScrollView addSubview:goldBtn];
        [self.btnArray addObject:goldBtn];
        [self.viewArray addObject:backView];
    }
    self.goldScrollView.contentSize = CGSizeMake((32+12)*count, 0);
    [self ButBettingChipsWithGold:self.goldLb.text];
    
}

- (void)animationWithSelectedBtn{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:0.4];
    animation.duration = 1.5;
    animation.repeatCount = MAXFLOAT;
    
    
    CABasicAnimation * animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation1.fromValue = [NSNumber numberWithFloat:0.4];
    animation1.toValue = [NSNumber numberWithFloat:0.0];
    animation1.beginTime = 1.5;
    animation1.duration = 1.5;
    animation1.repeatCount = MAXFLOAT;
    
    CAAnimationGroup * animaGroup = [CAAnimationGroup animation];
    animaGroup.animations = @[animation,animation1];
    animaGroup.duration = 3;
    animaGroup.removedOnCompletion = NO;
    animaGroup.repeatCount = MAXFLOAT;
    [self.animationView.layer addAnimation:animaGroup forKey:@"viewAnim"];
}

//启动筹码闪烁动画
- (void)betGoldClick:(UIButton *)btn{
    
    [self.animationView.layer removeAllAnimations];
    if (_isMeBanker == YES) {
        for (int i = 0; i <= 5; i++) {
            UIButton * goldBtn = (UIButton *)self.btnArray[i];
            goldBtn.enabled = NO;
        }
    }
    if(self.afterBetingCoin >= 500 && _currentGold >= 500 && _isMeBanker == NO){
        _currentIndex =  btn.tag - 1000;
        _currentSelected = btn.tag - 1000;
        [self.animationView removeFromSuperview];
        self.animationView = nil;
        self.animationView = self.viewArray[btn.tag - 1000];
        self.animationView.center = btn.center;
        [self.goldScrollView addSubview:self.animationView];
        [self animationWithSelectedBtn];
    }
}

//游戏记录
- (IBAction)gameRecord:(id)sender {
    
    if (self.popRecordBlock) {
        self.popRecordBlock();
    }
    
}

//打赏主播的人数数据
- (IBAction)gameWinerReward:(id)sender {
    
    
}

//申请上下庄
- (IBAction)replaceZhuang:(id)sender {
    if(self.applyBankerBlock){
        self.applyBankerBlock();
    }
}

//设置按钮
- (IBAction)liveSettingClick:(id)sender {
    
    if (self.settingPopViewBlock) {
        self.settingPopViewBlock();
    }
}

//充值
- (IBAction)rechargeClick:(id)sender {
    
    if (self.rechargeBlock) {
        self.rechargeBlock();
    }
    
}

//点击礼物
- (IBAction)giftClick:(id)sender {
    
    if (self.popGiftViewBlock) {
        self.popGiftViewBlock();
    }
}

//分享
- (IBAction)shareClick:(id)sender {
    if (self.shareBlcok) {
        self.shareBlcok();
    }
}

//系统消息按钮
- (IBAction)messageClick:(id)sender {
    AHDirectMessagesView *messageView  = [[AHDirectMessagesView alloc]init];
    [messageView showOnTheWindow];
}

//发消息
- (IBAction)senderMessageClick:(id)sender {
    
    [[AHBarrageInputBoxView share] showOnTheWindow];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AHLiveMessageObject *messge = [self.messages objectAtIndex:indexPath.row];
    
    AHLiveMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveMessageCell" forIndexPath:indexPath];
    cell.message = messge;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AHLiveMessageObject *messge = [self.messages objectAtIndex:indexPath.row];
    
    return messge.cellHeigth;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.barrageViewController dismiss];
    LOG(@"%s",__func__);
}

//根据当前金币余额设置可下注筹码类型(每次金币改变许调用一次)
- (void)ButBettingChipsWithGold:(NSString *)goldString{
    //首先判断是否含有“万”、"亿"的字眼
    NSString * Yi = @"亿";
    NSString * wan = @"W";
    NSInteger index;
    if ([goldString rangeOfString:Yi].location != NSNotFound) {
        index = 5;
    }else if ([goldString rangeOfString:wan].location != NSNotFound){
        NSString * countString = [goldString substringToIndex:goldString.length - 1];
        CGFloat gold = [countString floatValue];
        if (gold >= 500.0) {
            index = 5;
        }else if (gold <  500.0 && gold >= 250.0){
            index = 4;
        }else if(gold < 250.0 && gold >= 50.0){
            index = 3;
        }else if (gold < 50.0 && gold >= 5.0){
            index = 2;
        }else{
            index = 1;
        }
    }else{
        CGFloat gold = [goldString floatValue];
        if (gold >= 5000) {
            index = 1;
        }else{
            if (gold >= 500) {
                index = 0;
            }else{
                [self betGoldClick:(UIButton *)self.btnArray[0]];
                index = -1;
            }
        }
    }
    if (index < 0) {
        for (int i = 0; i <= 5; i++) {
            UIButton * goldBtn = (UIButton *)self.btnArray[i];
            goldBtn.enabled = NO;
        }
    }else{
        for (int i = 0; i < 6; i++) {
            UIButton * goldBtn = (UIButton *)self.btnArray[i];
            if (goldBtn.tag <= 1000 + index) {
                goldBtn.enabled = YES;
            }else{
                goldBtn.enabled = NO;
            }
        }
    }
    if (index >= 0 && _currentSelected >= index) {
        _currentSelected = index;
        [self betGoldClick:(UIButton *)self.btnArray[index]];
    }else{
        [self betGoldClick:(UIButton *)self.btnArray[_currentSelected]];
    }
    _currentIndex = _currentSelected;
}

//拿到个人金币数 装换成字符串
- (NSString *)getCurrentGold:(int64_t)goldCoin{
    if (goldCoin >= 100000000) {
        return [NSString stringWithFormat:@"%.2f亿",goldCoin / 100000000.0];
    }else if(goldCoin >= 10000 && goldCoin < 100000000){
        return [NSString stringWithFormat:@"%.2fW",goldCoin / 10000.0];
    }else{
        return [NSString stringWithFormat:@"%lld",goldCoin];
    }
}

- (void)setCurrentGold:(int64_t)coin{
    _currentGold = coin;
    self.afterBetingCoin = coin;
}

#pragma mark -金币数的改变
- (void)userGoldChange:(NSNotification *)notif{
    
    NSDictionary *dic = notif.userInfo;
    int64_t gold = [[dic objectForKey:@"userGold"]intValue];
    self.goldLb.text = [self getCurrentGold:gold];
    
}

@end
