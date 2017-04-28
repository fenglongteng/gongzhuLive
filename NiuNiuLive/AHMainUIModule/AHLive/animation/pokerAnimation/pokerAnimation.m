//
//  pokerAnimation.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "pokerAnimation.h"
#import "DHAnimation.h"
#import "AHLiveGameView.h"
#import "AHCurrentcyView.h"
#import "AHCurrencySuccessView.h"
#import "gameRemind.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"
#import "WMLocationManager.h"

//牌宽
static CGFloat pokerWidth = 37;
static CGFloat pokerHeight = 45;
//庄家牌被压住的宽度
static CGFloat bankerMask = (37 * 5 - 110)/4.0;
@interface UIPopoverController()

@end

static pokerAnimation * poker;
//播放器
static AVAudioPlayer * _ringPlayer;
@interface pokerAnimation(){
    gameRemind * _gameRemindView;
    //游戏返回的扑克数组
    NSArray * _pokers;
    //游戏返回的结果数据
    DouNiuEventGameResult * _resultMessage;
    UIImageView * _gold;
    //重新进入了APP 则不显示结束提醒
    BOOL _isAgain;
    
    
}
@property(nonatomic,strong)AHCurrentcyView * currentcy;

@property(nonatomic,strong)AHCurrencySuccessView * currentSuView;
//庄区域所有牌的X坐标
@property(nonatomic,strong)NSMutableArray * bankerXsArray;
//天区域所有牌的X坐标
@property(nonatomic,strong)NSMutableArray * skyXsArray;
//地区域所有牌的X坐标
@property(nonatomic,strong)NSMutableArray * earthXsArray;
//人区域所有牌的X坐标
@property(nonatomic,strong)NSMutableArray * personXsArray;

@end

@implementation pokerAnimation

- (void)dealloc{
    if (self.pokerImageArray) {
        self.pokerImageArray = nil;
        self.gameView = nil;
    }
}

+ (pokerAnimation *)pokerAnimation{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        poker = [[pokerAnimation alloc] init];
        [poker initAllXs];
    });
    return poker;
}

+ (void)destructionDealloc{
    [_ringPlayer stop];
    _ringPlayer = nil;
    poker.isStop = YES;
}

- (void)betingSound{
    if (self.isStop == YES) {
        return;
    }
    [_ringPlayer stop];
    //押注
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"xiazhu" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }

}

- (void)licensingSound{
    if (self.isStop == YES) {
        return;
    }
    [_ringPlayer stop];
    //发牌时播放
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"fapaipoker" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)finishSound{
    if (self.isStop == YES) {
        return;
    }
    [_ringPlayer stop];
    //结束
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"overgame" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)ShuffleTheDeckSound{
    if (self.isStop == YES) {
        return;
    }
    [_ringPlayer stop];
    //发牌时播放
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"xipaipoker" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)startGameSound{
    if (self.isStop == YES) {
        return;
    }
    [_ringPlayer stop];
    //开局时播放
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"startgame" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }

}

- (void)initAllXs{
    NSMutableArray * bankerXs = [NSMutableArray array];
    NSMutableArray * skyXs = [NSMutableArray array];
    NSMutableArray * earthXs = [NSMutableArray array];
    NSMutableArray * personXs = [NSMutableArray array];
    //每张牌被压住的宽度
    CGFloat maskPadiding = (37 * 5 -(screenWidth - 60)/3.0)/4.0;
    for (int i = 0; i < 5; i++) {
        CGFloat skyX = 12 + (pokerWidth - maskPadiding) * i;
        CGFloat earthX = (screenWidth - 45)/3.0 + 24 + (pokerWidth - maskPadiding) * i;
        CGFloat personX = (screenWidth - 45)/3.0 * 2 + 37 + (pokerWidth - maskPadiding) * i;
        CGFloat bankerX = 2 + (pokerWidth - bankerMask) * i;
        [skyXs addObject:@(skyX)];
        [earthXs addObject:@(earthX)];
        [personXs addObject:@(personX)];
        [bankerXs addObject:@(bankerX)];
    }
    self.bankerXsArray = bankerXs;
    self.skyXsArray = skyXs;
    self.earthXsArray = earthXs;
    self.personXsArray = personXs;
    //程序切换后台或者重新进入时通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didEnterBackground{
    [self.gameView.layer removeAllAnimations];

}

- (void)didBecomeActive{
    
}

//进入游戏时，如果已经是发牌阶段则直接显示扑克信息
- (void)dealCardsWithPokersMessageArray:(NSArray *)pokersArray gameView:(AHLiveGameView *)gameview{
    _pokers = pokersArray;
    self.lastPokerArray = [NSMutableArray array];
    self.pokerImageArray = [NSMutableArray array];
    self.backPokers = [NSMutableArray array];
    self.gameView = gameview;
    NSArray * Xarray = @[self.bankerXsArray,self.skyXsArray,self.earthXsArray,self.personXsArray];
    //模拟牌面
    NSArray * hua = @[@"a",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"j",@"q",@"k",];
    NSArray * style = @[@"f",@"m",@"h",@"ht"];
    CGFloat pokerY = self.gameView.frame.size.height - 105;
    for (int count = 0; count < 5; count++) {
        for (int i = 0; i < 4; i++) {
            UIImageView * pokerImage = [[UIImageView alloc] init];
            int card = [(GPBInt32Array *)(((DouNiuGameHand*)_pokers[i]).cardsArray) valueAtIndex:count];
            NSInteger huase = [self CardStyleIndex:card];
            NSInteger shu = [self CardValueIndex:card];
            pokerImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_%@",style[huase],hua[shu]]];
            if (i == 0) {
                pokerImage.frame = CGRectMake([Xarray[i][count] floatValue], 62, 37, pokerHeight);
                [((AHLiveGameView *)self.gameView).bankerView addSubview:pokerImage];
            }else{
                pokerImage.frame = CGRectMake([Xarray[i][count] floatValue], pokerY, 37, pokerHeight);
                [self.gameView addSubview:pokerImage];
            }
            [self.pokerImageArray addObject:pokerImage];
        }
    }
    CGFloat width = (screenWidth - 60)/3.0;
    for (int i = 0; i< 4; i++) {
        int cow = ((DouNiuGameHand *)_pokers[i]).niuN;
        int win = ((DouNiuGameHand *)_pokers[i]).winBanker;//0 表示输，1 表示赢
        UIImageView * image = [[UIImageView alloc] init];
        if (i == 0) {
            image.frame = CGRectMake(0, 0, 91, 35);
            image.center = CGPointMake(62.5, 90);
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_bluecow%d",cow]];
            [((AHLiveGameView *)self.gameView).bankerView addSubview:image];
        }else{
            switch (i) {
                case 1:
                    image.frame = CGRectMake(0, 0, 91, 35);
                    image.center = CGPointMake(width/2.0 + 10, self.gameView.frame.size.height - 80);
                    break;
                case 2:
                    image.frame = CGRectMake(0, 0, 91, 35);
                    image.center = CGPointMake(self.gameView.centerX, self.gameView.frame.size.height - 80);
                    break;
                case 3:
                    image.frame = CGRectMake(0, 0, 91, 35);
                    image.center = CGPointMake(self.gameView.centerX + width + 12, self.gameView.frame.size.height - 80);
                    break;
                default:
                    break;
            }
            if (win == 1) {
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_cow%d",cow]];
            }else{
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_cow%du",cow]];
            }
            [self.gameView addSubview:image];
        }
        [self.pokerImageArray addObject:image];
    }

}
//正常发牌动画
- (void)initWithPoker:(gameRemind *)remindView pokerMessage:(DouNiuEventGameResult *)pokers gameView:(AHLiveGameView *)gameView{
    _gameView = gameView;
    _pokers = pokers.handArray;
    _resultMessage = pokers;
    _gameRemindView = remindView;
    self.lastPokerArray = [NSMutableArray array];
    self.pokerImageArray = [NSMutableArray array];
    self.backPokers = [NSMutableArray array];
    for (int i = 0; i <= 6; i++) {
        UIImageView * poker = [[UIImageView alloc] init];
        poker.image = [UIImage imageNamed:@"icon_poker_back"];
        poker.frame = CGRectMake(0, 0, 51, 63);
         CGRect forRect;
        if (self.xiaHeight > 0) {
            poker.center = CGPointMake(screenWidth / 2.0 + (i * 1.5), screenHeight / 2.0 + (i * 1.5) - 91 - 210);
            forRect = CGRectMake(-60, 160 - 210, 51, 63);
        }else{
            poker.center = CGPointMake(screenWidth / 2.0 + (i * 1.5), screenHeight / 2.0 + (i * 1.5) - 91);
            forRect = CGRectMake(-60, 160, 51, 63);
        }
        [self.pokerImageArray addObject:poker];
        [self.backPokers addObject:poker];
        [_gameView addSubview:poker];
        DHAnimation * animation = [DHAnimation animationWithDuration:0.5 fromValue:[NSValue valueWithCGRect:forRect] toValue:[NSValue valueWithCGRect:CGRectMake(poker.frame.origin.x, poker.frame.origin.y, 51, 63)] animationBlock:^(id animationValue) {
            poker.frame = [animationValue CGRectValue];
            if (i == 5) {
                CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                
                animation.fromValue = [NSNumber numberWithFloat:0.f];
                animation.toValue =  [NSNumber numberWithFloat: M_PI / 12.0];
                animation.duration  = 0.1;
                animation.fillMode =kCAFillModeForwards;
                animation.removedOnCompletion = NO;
                animation.repeatCount = 1;
                [poker.layer addAnimation:animation forKey:nil];
            }else if (i == 6){
                CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                
                animation.fromValue = [NSNumber numberWithFloat:0.f];
                animation.toValue =  [NSNumber numberWithFloat: M_PI / 6.0];
                animation.duration  = 0.2;
                animation.fillMode =kCAFillModeForwards;
                animation.removedOnCompletion = NO;
                animation.repeatCount = 1;
                [poker.layer addAnimation:animation forKey:nil];
            }
        }];
        animation.beginTime = CACurrentMediaTime() + (i *0.08);
        animation.animationCurve = DHAnimationCurveEaseOut;
        [animation runAnimation];
    }
}

- (void)removeAllPokerImage{
    for(UIImageView * poker in self.pokerImageArray){
        [poker removeFromSuperview];
    }
    [_pokerImageArray removeAllObjects];
}

- (void)licensingToPlayers:(AHLiveGameView *)gameView{
    self.gameView = gameView;
    
    [self licensingAnimationWithCount:0 BankerOfLocations:self.bankerXsArray skyLocations:self.skyXsArray earthLocations:self.earthXsArray personLocations:self.personXsArray];
}
//传入每个游戏区域5张牌的X左边数组,递归调用5次
- (void)licensingAnimationWithCount:(NSInteger)count BankerOfLocations:( NSArray *  )banderXs skyLocations:(NSArray * )skyXs earthLocations:(NSArray * )earthXs personLocations:(NSArray * )personXs{
    if (count > 4) {
        return;
    }else{
        [self licensingSound];
        [self licensingPokerWithCount:count bankerXs:banderXs skyXs:skyXs earthXs:earthXs personXs:personXs];
        count ++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self licensingAnimationWithCount:count BankerOfLocations:banderXs skyLocations:skyXs earthLocations:earthXs personLocations:personXs];
        });
    }
}
//发牌动画
-(int)CardValueIndex:(int32_t) card{
    return (card-1)%13;
}
-(int)CardStyleIndex:(int32_t) card{
    return (card-1)/13;
}
- (void)licensingPokerWithCount:(NSInteger)count bankerXs:(NSArray *)bankerXs skyXs:(NSArray *)skyXs earthXs:(NSArray *)earthXs personXs:(NSArray *)personXs{
    
    //模拟牌面
    NSArray * hua = @[@"a",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"j",@"q",@"k",];
    NSArray * style = @[@"f",@"m",@"h",@"ht"];
    CGFloat pokerY = self.gameView.frame.size.height - 105;
    //生成4张牌
    for (int i = 0; i < 4; i++) {
        UIImageView * pokerImage = [[UIImageView alloc] init];
        
        int card = [(GPBInt32Array *)(((DouNiuGameHand*)_pokers[i]).cardsArray) valueAtIndex:count];
        NSInteger huase = [self CardStyleIndex:card];//(0 + (arc4random() % 4));
        NSInteger shu = [self CardValueIndex:card];//(0 + (arc4random() % 13));
        if (count == 4) {
            pokerImage.image = [UIImage imageNamed:@"icon_poker_back"];
            [self.lastPokerArray addObject:pokerImage];
        }else{
            pokerImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_%@",style[huase],hua[shu]]];
        }
        [self.pokerImageArray addObject:pokerImage];
        if (self.xiaHeight > 0) {
            pokerImage.frame = CGRectMake(self.gameView.width/2.0-20, screenHeight/2.0-91-210, 51, 63);
        }else{
            pokerImage.frame = CGRectMake(self.gameView.width/2.0-20, screenHeight/2.0-91, 51, 63);
        }
        __block CGRect toFrame;
        if (i == 0) {
            toFrame = CGRectMake([bankerXs[count] floatValue], 62, 37, pokerHeight);
        }else if(i == 1){
            toFrame = CGRectMake([skyXs[count] floatValue], pokerY, 37, pokerHeight);
        }else if(i == 2){
            toFrame = CGRectMake([earthXs[count] floatValue], pokerY, 37, pokerHeight);
        }else{
            toFrame = CGRectMake([personXs[count] floatValue], pokerY, 37, pokerHeight);
        }
        if (i == 0) {
            [((AHLiveGameView *)self.gameView).bankerView addSubview:pokerImage];
        }else{
            [self.gameView addSubview:pokerImage];
        }
        if (self.xiaHeight > 0) {
            if (i == 0) {
                DHAnimation * animation = [DHAnimation animationWithDuration:0.5 fromValue:[NSValue valueWithCGRect:pokerImage.frame] toValue:[NSValue valueWithCGRect:toFrame] animationBlock:^(id animationValue) {
                    pokerImage.frame = [animationValue CGRectValue];
                }];
                animation.beginTime = CACurrentMediaTime();
                animation.animationCurve = DHAnimationCurveEaseOut;
                [animation runAnimation];
                
            }else{
                DHAnimation * animation = [DHAnimation animationWithDuration:0.5 fromValue:[NSValue valueWithCGRect:pokerImage.frame] toValue:[NSValue valueWithCGRect:toFrame] animationBlock:^(id animationValue) {
                    pokerImage.frame = [animationValue CGRectValue];
                    
                }];
                animation.beginTime = CACurrentMediaTime();
                animation.animationCurve = DHAnimationCurveEaseOut;
                [animation runAnimation];
                
            }
            
        }else{
            if (i == 0) {
                DHAnimation * animation = [DHAnimation animationWithDuration:0.5 fromValue:[NSValue valueWithCGRect:pokerImage.frame] toValue:[NSValue valueWithCGRect:toFrame] animationBlock:^(id animationValue) {
                    pokerImage.frame = [animationValue CGRectValue];
                }];
                animation.beginTime = CACurrentMediaTime();
                animation.animationCurve = DHAnimationCurveEaseOut;
                [animation runAnimation];
                
            }else{
                DHAnimation * animation = [DHAnimation animationWithDuration:0.5 fromValue:[NSValue valueWithCGRect:pokerImage.frame] toValue:[NSValue valueWithCGRect:toFrame] animationBlock:^(id animationValue) {
                    pokerImage.frame = [animationValue CGRectValue];
                    
                }];
                animation.beginTime = CACurrentMediaTime();
                animation.animationCurve = DHAnimationCurveEaseOut;
                [animation runAnimation];
                
            }
        }
    }
}

- (void)FlipCARDS:(NSInteger)count{
    if (count > 3) {
        return;
    }else{
        //self.index = count;
        //翻第二张牌时移除 发牌的图片
        if (count == 1) {
            for(UIImageView * poker in self.backPokers){
                [poker removeFromSuperview];
            }
        }
        UIImageView * poker;
        if (self.lastPokerArray.count > 0) {
            poker = self.lastPokerArray[count];
        }
        CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
        
        shakeAnim.keyPath = @"transform.translation.x";
        
        shakeAnim.duration = 0.2;
        
        shakeAnim.values = @[@0 , @(-1),@0, @(1), @0];
        
        shakeAnim.repeatCount = 2;
        
        [poker.layer addAnimation:shakeAnim forKey:nil];
        NSInteger index = count;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImageView * poker;
            if (self.lastPokerArray.count > 0) {
                poker = self.lastPokerArray[index];
            }
            //模拟牌面
            NSArray * hua = @[@"a",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"j",@"q",@"k",];
            NSArray * style = @[@"f",@"m",@"h",@"ht"];
            //获取最后一张牌
            int card = [(GPBInt32Array *)(((DouNiuGameHand*)_pokers[count]).cardsArray) valueAtIndex:4];
            NSInteger huase = [self CardStyleIndex:card];
            NSInteger shu = [self CardValueIndex:card];
            
            [UIView beginAnimations:@"View Filp" context:nil];
            [UIView setAnimationDelay:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:poker cache:NO];
            [UIView commitAnimations];
            [UIView animateWithDuration:1 animations:^{
                poker.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_%@",style[huase],hua[shu]]];
            }];

            [self performSelector:@selector(setImage) withObject:nil afterDelay:1.0];
           
        });

    }
}
//当前牛牛的倍率显示
- (void)setImage{
    CGFloat width = (screenWidth - 60)/3.0;
    int cow = ((DouNiuGameHand *)_pokers[self.index]).niuN;
    int win = ((DouNiuGameHand *)_pokers[self.index]).winBanker;//0 表示输，1 表示赢
    
    switch (self.index) {
        case 0:{
            UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_live_bluecow%d",cow]]];
            image.frame = CGRectMake(0, 0, 91, 35);
            image.center = CGPointMake(62.5, 90);
            [((AHLiveGameView *)self.gameView).bankerView addSubview:image];
            [self.pokerImageArray addObject:image];
        }
            break;
        case 1:{
            UIImageView * image = [[UIImageView alloc] init];
            if (win == 1) {
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_cow%d",cow]];
            }else{
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_cow%du",cow]];
            }
            image.frame = CGRectMake(0, 0, 91, 35);
            image.center = CGPointMake(width/2.0 + 10, self.gameView.frame.size.height - 80);
            [self.gameView addSubview:image];
            [self.pokerImageArray addObject:image];
        }
            break;
        case 2:{
            UIImageView * image = [[UIImageView alloc] init];
            if (win == 1) {
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_cow%d",cow]];
            }else{
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_cow%du",cow]];
            }
            image.frame = CGRectMake(0, 0, 91, 35);
            image.center = CGPointMake(self.gameView.centerX, self.gameView.frame.size.height - 80);
            [self.gameView addSubview:image];
            [self.pokerImageArray addObject:image];
        }
            break;
        case 3:{
            UIImageView * image = [[UIImageView alloc] init];
            if (win == 1) {
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_cow%d",cow]];
            }else{
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_live_cow%du",cow]];
            }
            image.frame = CGRectMake(0, 0, 91, 35);
            image.center = CGPointMake(self.gameView.centerX + width + 12, self.gameView.frame.size.height - 80);
            [self.gameView addSubview:image];
            [self.pokerImageArray addObject:image];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_resultMessage.selfWinCoin > 0) {
                    [self addAnimationWith:1 goldCount:_resultMessage.selfWinCoin];
                }else{
                    [self addAnimationWith:2 goldCount:_resultMessage.selfWinCoin];
                }
            });
        }
            break;
        default:
            break;
    }
    self.index ++;
    if(self.index>3){
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self FlipCARDS:self.index];
    });
    
}

- (void)inTheGame{
    
}

//加减金币动画(1表示赢，2表示输)
- (void)addAnimationWith:(int64_t)winType goldCount:(int64_t)goldCount{
    BOOL isGift = NO;//是否可以直接送礼
    //牌局结束，调用胜负资料界面(超过2000直接调用可送礼的View)
    NSArray * exceptionArray = [[WMLocationManager defaultDBManage] getExceptionalGiftData];
    int64_t minCoin = ((RewordConfig *)exceptionArray[0]).minCoin;
    //判断当前主播是不是本人，是本人则不打赏。
    if (goldCount >= minCoin && ![_resultMessage.roomId isEqualToString:[[AHPersonInfoManager manager] getInfoModel].userId]) {
        AHCurrencySuccessView * finishView = [AHCurrencySuccessView currencySuccessShareView];
        finishView.center = CGPointMake(screenWidth/2.0, 200);
        finishView.winCoin = _resultMessage.selfWinCoin;
        finishView.bankerCoin = _resultMessage.bankerWinCoin;
        [finishView setWinMessage:exceptionArray winCoin:goldCount];
        [self.gameView addSubview:finishView];
        isGift = YES;
        self.currentSuView = finishView;
    }else {
        AHCurrentcyView * finishView = [AHCurrentcyView currencyShareView];
        finishView.winCoin = _resultMessage.selfWinCoin;
        finishView.banerCoin = _resultMessage.bankerWinCoin;
        [finishView initFrame:CGRectMake(0, 0, 255, 140)];
        finishView.center = CGPointMake(self.gameView.centerX, self.gameView.height - 85);
        [self.gameView addSubview:finishView];
        self.currentcy = finishView;
    }
    if (goldCount != 0) {//本家押注的情况
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_ringPlayer stop];
            //金币
            NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"gold" ofType:@"mp3"];
            NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
            
            _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [_ringPlayer setVolume:1];
            _ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
            if([_ringPlayer prepareToPlay])
            {
                [_ringPlayer play]; //播放
            }
            for (int i = 0; i < 5; i++) {
                UIImageView * gold = [[UIImageView alloc] init];
                gold.image = [UIImage imageNamed:@"icon_zb_gold"];
                gold.frame = CGRectMake(-30, 0, 20, 20);
                [self.gameView addSubview:gold];
                [self.pokerImageArray addObject:gold];
                CGPoint fromPoint;
                CGPoint toPoint;
                if (winType == 2) {
                    if (isGift == YES) {
                        fromPoint = CGPointMake(15, self.gameView.frame.size.height - 25);
                        toPoint = CGPointMake(screenWidth / 2.0, 145);
                    }else{
                        fromPoint = CGPointMake(15, self.gameView.frame.size.height - 25);
                        toPoint = CGPointMake(self.gameView.frame.size.width / 2.0, self.gameView.frame.size.height - 80);
                    }
                }else{
                    if (isGift == YES) {
                        fromPoint = CGPointMake(screenWidth / 2.0, 145);
                        toPoint = CGPointMake(15, self.gameView.frame.size.height - 25);
                    }else{
                        fromPoint = CGPointMake(self.gameView.frame.size.width / 2.0, self.gameView.frame.size.height - 80);
                        toPoint = CGPointMake(15, self.gameView.frame.size.height - 25);
                    }
                }
                if (i == 4) {
                    _gold = gold;
                    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, NULL,fromPoint.x ,fromPoint.y);
                    CGPathAddQuadCurveToPoint(path, NULL, toPoint.x, toPoint.y, toPoint.x, toPoint.y);
                    position.path = path;
                    position.duration = 0.5;
                    position.speed = 0.9;
                    position.beginTime = CACurrentMediaTime() +(i * 0.08);
                    position.removedOnCompletion = YES;
                    position.fillMode = kCAFillModeForwards;
                    [_gold.layer addAnimation:position forKey:@"lastAnim"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self endGame];
                    });
                }else{
                    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, NULL,fromPoint.x ,fromPoint.y);
                    CGPathAddQuadCurveToPoint(path, NULL, toPoint.x, toPoint.y, toPoint.x, toPoint.y);
                    position.path = path;
                    position.duration = 0.5;
                    position.speed = 0.9;
                    position.beginTime = CACurrentMediaTime() +(i * 0.08);
                    position.removedOnCompletion = YES;
                    position.fillMode = kCAFillModeForwards;
                    [gold.layer addAnimation:position forKey:@"dfad"];
                }
            }
        });
    }else{//本家没有押注的情况
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //修改庄家金币数
            self.gameView.bankerCoin = self.gameView.bankerCoin + _resultMessage.bankerWinCoin;
            if (self.gameView.bankerCoin >= 100000000.0) {
                self.gameView.bankerGoldLb.text = [NSString stringWithFormat:@"%.2f亿",(self.gameView.bankerCoin / 100000000.0)];
            }else{
                self.gameView.bankerGoldLb.text = [NSString stringWithFormat:@"%.2fW",(self.gameView.bankerCoin / 10000.0)];
            }
            [self.gameView resetAllCount];
            [self removeAllPokerImage];
            [self.currentcy removeFromSuperview];
            [self.currentSuView removeFromSuperview];
            self.currentSuView = nil;
            self.currentcy = nil;
            [_gameRemindView showHaveRestView];
            [self.gameView removewAllChouMaImage];
            self.index = 0;
            self.gameView.TianCount.text = @"0";
            self.gameView.DiCount.text = @"0";
            self.gameView.RenCount.text = @"0";
            self.gameView.TianAllCount.text = @"0";
            self.gameView.DiAllCount.text = @"0";
            self.gameView.RenAllCount.text = @"0";
            [self finishSound];
        });
    }
}

-(void)endGame{
    
    [self finishSound];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //修改庄家金币数
            int64_t bankerWin = _resultMessage.bankerWinCoin;
            self.gameView.bankerCoin = self.gameView.bankerCoin + bankerWin;
            if (self.gameView.bankerCoin >= 100000000.0) {
                self.gameView.bankerGoldLb.text = [NSString stringWithFormat:@"%.2f亿",(self.gameView.bankerCoin / 100000000.0)];
            }else{
                self.gameView.bankerGoldLb.text = [NSString stringWithFormat:@"%.2fW",(self.gameView.bankerCoin / 10000.0)];
            }
            AHPersonInfoModel *model = [AHPersonInfoManager manager].getInfoModel;
            model.goldCoins += _resultMessage.selfWinCoin;
            [[AHPersonInfoManager manager] setInfoModel:model];
            self.gameView.afterBetingCoin = model.goldCoins;
            self.gameView.goldLb.text = [self.gameView getCurrentGold:model.goldCoins];
            [self.gameView setCurrentGold:model.goldCoins];
            [self.gameView ButBettingChipsWithGold:self.gameView.goldLb.text];
            [self.gameView resetAllCount];
            [self removeAllPokerImage];
            [self.currentcy removeFromSuperview];
            [self.currentSuView removeFromSuperview];
            self.currentSuView = nil;
            self.currentcy = nil;
            [_gameRemindView showHaveRestView];
            [self.gameView removewAllChouMaImage];
            self.index = 0;
            self.gameView.TianCount.text = @"0";
            self.gameView.DiCount.text = @"0";
            self.gameView.RenCount.text = @"0";
            self.gameView.TianAllCount.text = @"0";
            self.gameView.DiAllCount.text = @"0";
            self.gameView.RenAllCount.text = @"0";
        });
  
    
}





@end
