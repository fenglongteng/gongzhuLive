//
//  AHLiveViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.

// 在anchorView 和gameLive 界面内 block中 注意造成的内存泄漏问题。。

#import "AHLiveViewController.h"
#import "AHAlertView.h"
#import "AHLiveAnchorView.h"
#import "AHLiveUserPopView.h"
#import "AHContributeView.h"
#import "AHLiveGameView.h"
#import "AHLiveSettingView.h"
#import "AHSuccessOrFailView.h"
#import "AHApplyForBanker.h"
#import "endCreatingLive.h"
#import "AHHistoryGainsView.h"
#import "AHGiftView.h"
#import "AHLiveSenderMessageToolView.h"
#import "baseRedPacket.h"
#import "sendRedView.h"
#import "LBShareController.h"
#import "pokerAnimation.h"
#import "AHCurrencySuccessView.h"//结算赢大钱
#import "AHCurrentcyView.h"//结算
#import <AVFoundation/AVFoundation.h>
#import "gameRemind.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"
#import "NSString+Tool.h"
#import "gameFinishView.h"
#import "AHLiveSocketManager.h"
#import "MediaPackages.pbobjc.h"
#import "LiveUsers.pbobjc.h"
#import "H264HwDecoderImpl.h"
#import "AHGoldLackPopView.h"
#import "AHRechargeView.h"
#import "SKAudioBuffer.h"
#import "MCAudioOutputQueue.h"
#import "AHCallStatusMonitoring.h"


@interface AHLiveViewController ()<UIGestureRecognizerDelegate,H264HwDecoderImplDelegate>{
    
    //当前主播房间信息
    Room * _roomModel;
    //上一个庄的信息
    DouNiuBanker * _bankerMes;
    //当前庄的id
    NSString * _currentBankerid;
    
    AudioStreamPacketDescription *_fmation;
    AudioStreamBasicDescription _descript;
    MCAudioOutputQueue *_audioQueue;

}

@property (nonatomic,strong)AVAudioPlayer *ringPlayer;
@property (nonatomic,strong)AHLiveAnchorView *anchorView;// 顶部 包含主播头像 名称等  还差观看直播人的滑动
@property (nonatomic,strong)AHLiveUserPopView *popUserView;//点击头像弹出用户

@property (nonatomic,strong)AHContributeView *contributeView;//贡献榜

@property (nonatomic,strong)AHLiveGameView *gameView;// 游戏整个界面，包含发牌栏 庄家栏  记录等

@property (nonatomic,strong)AHLiveSettingView *liveSetView;//点击设置，弹出设置栏

@property (nonatomic,strong)AHSuccessOrFailView *recordView;//记录

@property (nonatomic,strong)AHApplyForBanker *applyBanker;//申请上下庄

@property (nonatomic,strong)AHHistoryGainsView *historyGansView;//历史战绩

@property (nonatomic,strong)AHGiftView *giftView;//礼物界面

@property (nonatomic,strong)AHLiveSenderMessageToolView *messageToolView;//发送消息

@property (nonatomic,strong)sendRedView *redPacketSenderView;//红包发送界面

@property (nonatomic,strong)getRedView *redPacketGetView;//抢红包界面

@property (nonatomic,strong)LBShareController *shareView;//分享界面

@property (nonatomic,strong)AHGoldLackPopView *goldLackView;//金币不足界面

@property (nonatomic,strong)AHCurrencySuccessView *currencySuccess;//结算视图

@property (nonatomic,strong)AHRechargeView *rechargeView;//充值界面

@property (nonatomic,strong)UIImageView *backImageView;

@property (nonatomic,strong)gameRemind * gameRemindView; //游戏相关提示、动画View

@property (nonatomic,strong)gameFinishView * gameFinish;//游戏等待或结束时

@property (nonatomic,strong)AVSampleBufferDisplayLayer *avPlayer;//图像展示Layer

@property (nonatomic,strong)H264HwDecoderImpl *h264Decoder;//解码h264

@property (nonatomic,assign)BOOL isSwpite;//是否需要下上手势

@property (nonatomic,copy)NSString *ownerId;//自己的UserID

@property (nonatomic,strong)MediaPackage *spsPacket; //存储sps包
@property (nonatomic,strong)MediaPackage *ppsPacket; //存储pps包

@property(nonatomic,strong) AHCallStatusMonitoring *callStatus;//通话状态监听

@end

@implementation AHLiveViewController

- (instancetype)initWithRoom:(Room *)roomModel{
    self = [super init];
    if (self) {
        _roomModel = roomModel;
        _roomId = roomModel.ownerId;
    }
    return self;
}

- (void)createAudioQueue{
    //设置AAC basicDescript
    _descript.mSampleRate = 44100;
    _descript.mFormatID =kAudioFormatMPEG4AAC;
    _descript.mFormatFlags = 0;
    _descript.mBytesPerPacket = 0;
    _descript.mFramesPerPacket = 1024;
    _descript.mBytesPerFrame = 0;
    _descript.mChannelsPerFrame = 1;
    _descript.mBitsPerChannel = 0;
    _descript.mReserved = 0;
    _audioQueue = [[MCAudioOutputQueue alloc]initWithFormat:_descript bufferSize:0x1000 macgicCookie:nil];
}

- (void)createVideoPlayer{
    _avPlayer = [[AVSampleBufferDisplayLayer alloc]init];
    _avPlayer.frame = self.view.bounds;
    _avPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:_avPlayer atIndex:1];
}

#pragma mark - 获得视频数据和音频数据
- (void)getVideoAudioDataPlayer{
    
    __block  NSMutableData *h264Data = [NSMutableData data];
    WeakSelf;
    [[AHLiveSocketManager instance]qureyHandle:^(id message) {
        MediaPackage *media = (MediaPackage *)message;
        if (media.mediaType == MediaPackageMediaType_MediaPackageMediaTypeVideo) {
            [weakSelf resourceMediaPackFrame:media h264Data:h264Data];
        }
        if (media.mediaType == MediaPackageMediaType_MediaPackageMediaTypeAudio) {
            NSData *data = media.data_p;
//            [weakSelf playerAudio:data];
        }
    } messageStr:@"MediaPackage"];
}

#pragma mark -播放音频
- (void)playerAudio:(NSData *)audioData{
#warning 播放
//    SKAudioBuffer *audio = [[SKAudioBuffer alloc]init];
//    AudioStreamPacketDescription *streamPack;
//    [audio storePacketData:[audioData bytes] dataLength:(int32_t)audioData.length packetDescriptions:streamPack packetsCount:1];
    AudioStreamPacketDescription *fmation = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription));
    fmation->mStartOffset = 7;
    fmation->mVariableFramesInPacket = 0;
    fmation->mDataByteSize = (UInt32)audioData.length;
//    [_audioQueue playData:audioData packetCount:6 packetDescriptions:fmation isEof:YES];
    
//    [_audioQueue resume];
}

#pragma mark -H264HwDecoderImplDelegate 解码delegate

- (void)displayDecodedFrame:(CVImageBufferRef)imageBuffer{
    
    if(!imageBuffer)return;
    if (_avPlayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
        [_avPlayer flush];
    }
    CMSampleTimingInfo timing = {kCMTimeInvalid,kCMTimeInvalid,kCMTimeInvalid};
    //获取视频信息
    CMVideoFormatDescriptionRef videoInfo = NULL;
    OSStatus result = CMVideoFormatDescriptionCreateForImageBuffer(NULL, imageBuffer, &videoInfo);
    NSParameterAssert(result == 0 && videoInfo != NULL);
    CMSampleBufferRef sampleBuffer = NULL;
    result = CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, imageBuffer, true, NULL, NULL, videoInfo, &timing, &sampleBuffer);
    NSParameterAssert(result == 0 && sampleBuffer != NULL);
    CFRelease(imageBuffer);
    CFRelease(videoInfo);
    CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, YES);
    CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
    CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
    [_avPlayer enqueueSampleBuffer:sampleBuffer];
    CFRelease(sampleBuffer);
    
}

- (void)failDecode:(OSStatus)error{

    [self.h264Decoder decodeNalu:(uint8_t *)[self.spsPacket.data_p bytes] withSize:(uint32_t)self.spsPacket.data_p.length];
    
   [self.h264Decoder decodeNalu:(uint8_t *)[self.ppsPacket.data_p bytes] withSize:(uint32_t)self.ppsPacket.data_p.length];
}

#pragma mark -整合视频数据 播放
- (void)resourceMediaPackFrame:(MediaPackage *)mediaPack h264Data:(NSMutableData *)h264Data{
    
    if (mediaPack.h264FrameType == H264FrameType_H264FrameTypeSps) {
        self.spsPacket = mediaPack;
    }
    if (mediaPack.h264FrameType == H264FrameType_H264FrameTypePps) {
        self.ppsPacket = mediaPack;
    }
    //根据mediapack 的包pageid 和hasRemain 进行一帧数据的整合
    if (!mediaPack.hasRemain && mediaPack.packageId == 0) {
        [self.h264Decoder decodeNalu:(uint8_t *)[mediaPack.data_p bytes] withSize:(uint32_t)mediaPack.data_p.length];
    }
    if (mediaPack.hasRemain) {
        [h264Data appendData:mediaPack.data_p];
    }
    if (!mediaPack.hasRemain && mediaPack.packageId != 0) {
        [h264Data appendData:mediaPack.data_p];
        [self.h264Decoder decodeNalu:(uint8_t *)[h264Data bytes] withSize:(uint32_t)h264Data.length];
        [h264Data resetBytesInRange:NSMakeRange(0, h264Data.length)];
        [h264Data setLength:0];
    }
}

#pragma mark -音视频socket连接
- (void)connectLiveSocket{
    
    [[AHLiveSocketManager instance] connectWithIp:liveSocketHost port:30003 connectSuccess:^(int status) {
        //连接成功 根基房间ID进行登录
        if (status == 0) {
            //登录房间
            [self loginLiveSocket:self.roomId];
        }
    }];
}

#pragma mark -音视频登录 获得拉流数据
- (void)loginLiveSocket:(NSString *)roomId{
    
    LiveUsersLoginRequest *loginReq = [[LiveUsersLoginRequest alloc]init];
    loginReq.userId = self.ownerId;
    loginReq.type = LiveUsersLoginRequest_Type_Puller;
    loginReq.token = [[[AHPersonInfoManager manager]getInfoModel]token];
    loginReq.roomId = self.roomId;
    
    [[AHLiveSocketManager instance]sendMessage:loginReq classSite:UsersClassName block:^(id response) {
        LOG(@"登录成功");
    }];
}

#pragma mark -登出 音视频拉流
- (void)logOutLiveSocket{
    
    LiveUsersLogoutRequest *logOutReq = [[LiveUsersLogoutRequest alloc]init];
    logOutReq.userId = self.ownerId;
    [[AHLiveSocketManager instance]sendMessage:logOutReq classSite:UsersClassName block:^(id response) {
        //登出成功响应
    }];
}

#pragma mark - 断开liveSocket
- (void)disConnectLiveSocket{
    
    [[AHLiveSocketManager instance]disConnect];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createAudioQueue];
    //解码
    self.h264Decoder = [[H264HwDecoderImpl alloc]init];
    self.h264Decoder.delegate = self;
    self.ownerId = [[[AHPersonInfoManager manager]getInfoModel] userId];
    _isSwpite = YES;
    [self connectLiveSocket];
    [self getVideoAudioDataPlayer];
    //添加视图显示
    [self createVideoPlayer];
    //进入房间
    [self enterRoom];
    //进入游戏房间
    [self GameApiLogin];
    //socket重新连接然后重新进入房间
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterRoom) name:SocketDidConnect object:nil];
    //获取主播
    UIImageView *backImageV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageV.image = [UIImage imageNamed:@"bg_poker"];
    [self.view insertSubview:backImageV atIndex:0];
    self.backImageView = backImageV;
    self.anchorView.roomId = _roomId;
    self.gameView.gameRoomid = _roomId;
    //禁用本页面系统侧滑返回手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickUser:) name:kNotifyClickUser object:nil];
    
    [self createSwipestureRecongnizer];
    WeakSelf;
    //游戏回调
    [[GameSocketManager instance] addHandler:^int(PackHeader *header, NSData *body) {
        //DouNiuEventBet
        DouNiuEventBet * douniu = GetMessage(DouNiuEventBet, body);
        if (douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtbegin) {
            //开始下注
            //变庄了
            DouNiuEventBet * rt = GetMessage(DouNiuEventBet, body);

            [self.gameView setBankerMessage:rt.banker];
            [self.gameView isMeOfBankerWithBankerid:rt.banker.id_p];
            if (![_bankerMes.id_p isEqualToString:rt.banker.id_p] && _bankerMes) {
                _bankerMes = rt.banker;
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"玩家%@上庄",rt.banker.nickName]];
            }
            _currentBankerid = rt.banker.id_p;
            [[pokerAnimation pokerAnimation] removeAllPokerImage];
            [weakSelf.gameFinish removeFromSuperview];
            weakSelf.gameFinish = nil;
            [weakSelf.gameRemindView removeFromSuperview];
            weakSelf.gameRemindView = nil;
            [weakSelf startToLicensing:douniu.tickLeft];
            weakSelf.gameView.currentGameid = douniu.gameId;
            weakSelf.gameView.gameRoomid = douniu.roomId;
        }else if (douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtend){
            //等待游戏开始
        }else if (douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtchanged){

        }else if (douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtnext){
            //新的一局已经开始了，等待几秒下注
            [weakSelf.gameView removewAllChouMaImage];
            DouNiuEventBet * rt = GetMessage(DouNiuEventBet, body);
            //游戏结束时，判断主播是否关闭了游戏
            if (rt.room.flags == 1) {
                weakSelf.isSwpite = NO;
                [pokerAnimation pokerAnimation].isStop = YES;//关闭游戏声音
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeDown object:nil];
                [pokerAnimation pokerAnimation].xiaHeight = 210;
                __block AHAlertView * alert = [[AHAlertView alloc] initAlertViewReminderTitle:@"提示" title:@"主播已经关闭了游戏！" cancelBtnTitle:@"确定" cancelAction:^{
                }];
                [alert showAlert];
                
                [weakSelf.gameFinish removeFromSuperview];
                weakSelf.gameFinish = nil;
            }else if (rt.room.flags == 0){
                [pokerAnimation pokerAnimation].isStop = NO;//关闭游戏声音
            }
        }else if(douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtstart){
            //游戏重新开始
            weakSelf.isSwpite = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeUp object:nil];
            [pokerAnimation pokerAnimation].xiaHeight = 0;
            [weakSelf gameWaitingOfShowFinshViewWithIsCard:YES];
        }
        return 0;
    } withProtoType:ProtoTypes_PtIddouNiuEventBet];
    
    //金币增加广播
    [[GameSocketManager instance]  addHandler:^int(PackHeader *header, NSData *body) {
        DouNiuEventOnBets * bets = GetMessage(DouNiuEventOnBets, body);
        [[pokerAnimation pokerAnimation]betingSound];
        [weakSelf.gameView otherPlayerToBetting:bets];
        return 0;
    } withProtoType:ProtoTypes_PtIddouNiuEventOnBet];
    
    [[GameSocketManager instance] addHandler:^int(PackHeader *header, NSData *body) {
        //DouNiuEventBet
        DouNiuEventGameResult * result = GetMessage(DouNiuEventGameResult, body);
        //result.handArray
        //开始发牌
        if (result.handArray.count < 4 ) {
            return 0;
        }
        for(int i=0;i<4;i++){
            if(((DouNiuGameHand*)result.handArray[i]).cardsArray_Count<5)
                return 0;
        }
        //投注时间到，关闭投注
        [weakSelf.gameView gameWithStarting:NO];
        [_gameRemindView licensingOfServiceWithTag:result gameView:self.gameView];
        
        weakSelf.gameRemindView.licensingBlock = ^(gameRemind * gameRemindView){
            [gameRemindView startLicensing:result];
        };
        //[weakSelf.gameView otherPlayerToBetting:result.allBetsArray];
        return 0;
    } withProtoType:ProtoTypes_PtIddouNiuEventGameResult];
    //通话监听 如果是主播那么久要发送消息 来电话啦
    _callStatus =  [[AHCallStatusMonitoring alloc]init];
    [_callStatus begingMonitoring];
}
//进入游戏
- (void)GameApiLogin{
    
    DouNiuEnterRoom * enterGame = [[DouNiuEnterRoom alloc] init];
    enterGame.roomId = self.roomId;
    
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuEnterRoom andMessage:enterGame andHandler:^int(PackHeader *header, NSData *body) {
        DouNiuEnterRoomRes * res = GetMessage(DouNiuEnterRoomRes ,body);
        if (res.room.flags == 1) {
            _isSwpite = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeDown object:self];
            [pokerAnimation pokerAnimation].xiaHeight = 210;
        }else{
            if (res.status == 0) {
                //设置庄家信息
                DouNiuBanker * banker = res.room.banker;
                _bankerMes = banker;
                [self.gameView setBankerMessage:banker];
                [pokerAnimation pokerAnimation].isStop = NO;
                int gameStatus = res.room.gameStep;
                switch (gameStatus) {
                    case DouNiuRoom_RoomGameSteps_Rgsprepair:{//游戏等待阶段
                        [self gameWaitingOfShowFinshViewWithIsCard:NO];
                    }    break;
                    case DouNiuRoom_RoomGameSteps_Rgsbeting:{//下注倒计时阶段
                        [self.gameView gameWithStarting:YES];//开启投注
                        [self gameWaitingOfShowRemindView:YES timeTickLeft:res.room.gameStepTickLeft];
                    }    break;
                    case DouNiuRoom_RoomGameSteps_RgsdealCards:{//发牌阶段,即直接把扑克图片加上来，不做动画
                        [self gameWaitingOfShowFinshViewWithIsCard:YES];
                        [[pokerAnimation pokerAnimation] dealCardsWithPokersMessageArray:res.room.handArray gameView:self.gameView];
                    }    break;
                    default:
                        break;
                }
                
            }
        }
        return 0;
    }];
    
}

- (void)gameWaitingOfShowRemindView:(BOOL)isBetingTime timeTickLeft:(int32_t)BetTime{
    if (!self.gameRemindView) {
        gameRemind * remindView = [gameRemind initGameRemindView];
        remindView.frame = CGRectMake(0, 0, 200, 50);
        remindView.center = CGPointMake(self.gameView.centerX, self.gameView.height - 135);
        [self.gameView addSubview:remindView];
        self.gameRemindView = remindView;
        WeakSelf;
        self.gameRemindView.finishBlock = ^{
            [weakSelf gameWaitingOfShowFinshViewWithIsCard:NO];
        };
    }
    if (isBetingTime == YES) {
        [self.gameRemindView clockStarting:BetTime isEnterGameBetingStatus:YES];
    }else{
        [self.gameRemindView startGameWithView:self.gameView betTime:BetTime];
        WeakSelf;
        self.gameRemindView.finishBlock = ^{
            [weakSelf gameWaitingOfShowFinshViewWithIsCard:NO];
        };

    }
}

- (void)gameWaitingOfShowFinshViewWithIsCard:(BOOL)isCards{
    if (!self.gameFinish) {
        //开局提示view
        gameFinishView * finish = [gameFinishView initGameFinishView];
        finish.frame = CGRectMake(0, 0, 200, 50);
        finish.center = CGPointMake(self.gameView.centerX, self.gameView.height - 135);
        self.gameFinish = finish;
        [self.gameView addSubview:finish];
        [finish gameWaitingOrGameCreating];
    }
    if (isCards == YES) {
        self.gameFinish.timeLbl.text = @"请等待下一局游戏";
    }
    [self.gameFinish gameWaitingOrGameCreating];
    
}

#pragma mark -进入房间
-(void)enterRoom{
    
    RoomsJoinRoomRequest *joinRoomRequest = [[RoomsJoinRoomRequest alloc]init];
    joinRoomRequest.userId = _roomModel.ownerId;
    if (self.roomPassW) {
        joinRoomRequest.password = self.roomPassW;
    }
    [[AHTcpApi shareInstance] requsetMessage:joinRoomRequest classSite:RoomClassName completion:^(id response, NSString *error) {
        RoomsJoinRoomResponse *joinRoomResponse = response;
        if (joinRoomResponse.result == 0) {
            LOG(@"进入成功");
        }else{
            [SVProgressHUD showInfoWithStatus:@"很抱歉，进入房间失败，请重新进入"];
        }
    }];
}

#pragma mark -游戏开始
- (void)startToLicensing:(int)betTime{
    [self gameWaitingOfShowRemindView:NO timeTickLeft:betTime];
}

//移除所有游戏相关
- (void)removeGameRemind{
    [self.gameRemindView removeFromSuperview];
    self.gameRemindView = nil;
}

- (void)createSwipestureRecongnizer{
    
    UISwipeGestureRecognizer *recognizer;
    UISwipeGestureRecognizer * dowmrecognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [self.view addGestureRecognizer:recognizer];
    
    dowmrecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [dowmrecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [self.view  addGestureRecognizer:dowmrecognizer];
    recognizer.delegate = self;
    dowmrecognizer.delegate = self;
}

#pragma mark -上下滑动手势 通知模式

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeDown object:self];
        self.liveSetView.isShowGame = YES;
        [pokerAnimation pokerAnimation].xiaHeight = 210;
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeUp object:self];
        self.liveSetView.isShowGame = NO;
        [pokerAnimation pokerAnimation].xiaHeight = 0;
    }
}

#pragma mark -弹出AlertView 可以根据 主播不同类型 进行弹出显示
- (void)click{
    
    AHAlertView *alert = [[AHAlertView alloc]init];
    alert.alertType = AHAlertMaster;
    [alert showAlert];
    
}

#pragma mark -点击用户，弹出详情
- (void)clickUser:(NSNotification *)notification{
    
    NSString *userid = [notification.userInfo objectForKey:@"userId"];
    if (userid && userid.length != 0) {
        self.popUserView.userId = userid;
        [UIView animateWithDuration:0.5 animations:^{
            self.popUserView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

#pragma mark -设置弹框
- (AHLiveSettingView *)liveSetView{
    
    if (!_liveSetView) {
        AHLiveSettingView *liveSetView = [AHLiveSettingView liveSetingShare];
        _liveSetView = liveSetView;
        [self.view addSubview:liveSetView];
        [liveSetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        //弹出历史战绩
        [liveSetView setHistoryGainsBlock:^{
            self.historyGansView.roomid = self.roomId;
        }];
    }
    return _liveSetView;
}

#pragma mark- 游戏界面
- (AHLiveGameView *)gameView{
    
    if (!_gameView) {
        AHLiveGameView *gameView = [AHLiveGameView liveGameShareView];
        gameView.messageTableView.tableHeaderView = nil;
        [self.view addSubview:gameView];
        _gameView = gameView;
        __weak typeof(self)weakself = self;
        //设置界面弹出
        [gameView setSettingPopViewBlock:^{
            
            [weakself.liveSetView showAnimation];
        }];
        //礼物弹出界面
        [gameView setPopGiftViewBlock:^{
            //            [[NSNotificationCenter defaultCenter]postNotificationName:kNotifiGameSwipeDown object:nil];
            weakself.giftView.hidden = NO;
        }];
        //记录界面弹出
        [gameView setPopRecordBlock:^{
            weakself.recordView.roomid = weakself.roomId;
            [UIView animateWithDuration:0.5 animations:^{
                weakself.recordView.transform = CGAffineTransformIdentity;
            }];
        }];
        //申请上下庄
        [gameView setApplyBankerBlock:^{
            [weakself.applyBanker setBankerMessageWithRoomid:weakself.roomId currentBankerid:_currentBankerid];
        }];
        //分享
        [gameView setShareBlcok:^{
            if (weakself.shareView) {
                [weakself.shareView.view removeFromSuperview];
                weakself.shareView = nil;
            }
            weakself.shareView =  [LBShareController showShareViewWithMessage:@"分享给自己的朋友"];
            //            self.shareView.shareImg = ((UIImageView *)[self createShareImageView:self.view]).image;
            weakself.shareView.beViewController = weakself;
            weakself.shareView.shareText = @"";
            [weakself.shareView showShareViewAnimation];
        }];
        [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@90);
            make.bottom.equalTo(@0);
        }];
        
        __weak typeof(gameView)weakGameView = gameView;
        //充值 现在还没有具体确认 提供接口
        [gameView setRechargeBlock:^{
            weakself.rechargeView.goldCoin = weakGameView.bankerCoin;
        }];
        
    }
    return _gameView;
}

#pragma mark -贡献榜
- (AHContributeView *)contributeView{
    if (!_contributeView) {
        AHContributeView *contributeView = [AHContributeView contributeShareView];
        [self.view addSubview:contributeView];
        _contributeView = contributeView;
        
        [contributeView setMeKnowBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                self.contributeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.contributeView removeFromSuperview];
                self.contributeView = nil;
            }];
        }];
        
        [contributeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
    }
    return _contributeView;
}

#pragma mark -设置界面的清除
- (void)removieSettingView{
    [self.liveSetView removeFromSuperview];
    self.liveSetView = nil;
}

#pragma mark - 直播头部展现 主播信息 观众信息 关闭按钮
- (AHLiveAnchorView *)anchorView{
    
    if (!_anchorView) {
        AHLiveAnchorView *anchorView = [AHLiveAnchorView liveAnchorView];
        [self.view insertSubview:anchorView atIndex:100];
        _anchorView = anchorView;
        __weak typeof(self) weakself = self;
        //退出直播界面
        anchorView.closeLiveBlock = ^(){
            [weakself logOutLiveSocket];
            [weakself disConnectLiveSocket];
            [weakself removieSettingView];
            [weakself.avPlayer stopRequestingMediaData];
            //退出游戏房间
            [pokerAnimation destructionDealloc];
            DouNiuEnterRoom * enterGame = [[DouNiuEnterRoom alloc] init];
            enterGame.roomId = self.roomId;
            [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuLeaveRoom andMessage:enterGame andHandler:^int(PackHeader *header, NSData *body) {
                DouNiuEnterRoomRes * res = GetMessage(DouNiuEnterRoomRes ,body);
                if (res.status == 0) {
                    NSLog(@"退出游戏成功！");
                }
                return 0;
            }];
            [weakself.navigationController popViewControllerAnimated:YES];
        };
        //点击显示贡献榜
        [anchorView setClickContributeShowBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                weakself.contributeView.transform = CGAffineTransformIdentity;
            }];
        }];
        [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@80);
            make.top.equalTo(@10);
        }];
    }
    return _anchorView;
}

#pragma mark -弹出用户框
- (AHLiveUserPopView *)popUserView{
    
    if (!_popUserView) {
        AHLiveUserPopView *popUserView = [AHLiveUserPopView LiveUserPopView];
        [self.view addSubview:popUserView];
        _popUserView = popUserView;
        [popUserView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
        // 关闭弹框
        popUserView.closeBlock = ^(){
            [UIView animateWithDuration:0.5 animations:^{
                self.popUserView.userbackView.transform = CGAffineTransformMakeTranslation(0, 136);
            } completion:^(BOOL finished) {
                [self.popUserView removeFromSuperview];
                self.popUserView = nil;
            }];
        };
    }
    return _popUserView;
}

#pragma mark -胜负走势图
- (AHSuccessOrFailView *)recordView{
    
    if (_recordView==nil) {
        AHSuccessOrFailView *recordView = [AHSuccessOrFailView successOrFailShareView];
        [self.view addSubview:recordView];
        _recordView = recordView;
        [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
        [recordView setCloseRecodView:^{
            [UIView animateWithDuration:0.5 animations:^{
                self.recordView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.recordView removeFromSuperview];
                self.recordView = nil;
            }];
        }];
    }
    return _recordView;
}

#pragma mark -历史战绩
- (AHHistoryGainsView *)historyGansView{
    
    if (!_historyGansView) {
        AHHistoryGainsView *historyView = [AHHistoryGainsView shareHistoryGainsView];
        [self.view addSubview:historyView];
        _historyGansView = historyView;
        [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
        //关闭历史战绩
        [historyView setCloseHistoryGainsBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                self.historyGansView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.historyGansView removeFromSuperview];
                self.historyGansView = nil;
            }];
        }];
    }
    return _historyGansView;
}

#pragma mark -申请上下庄
- (AHApplyForBanker *)applyBanker{
    
    if (!_applyBanker) {
        AHApplyForBanker *applyBanker = [AHApplyForBanker shareApplyForBanker];
        [self.view addSubview:applyBanker];
        _applyBanker = applyBanker;
        [applyBanker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
        //关闭申请上下庄弹框
        [applyBanker setCloseBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                self.applyBanker.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.applyBanker removeFromSuperview];
                self.applyBanker = nil;
            }];
        }];
    }
    return _applyBanker;
}

#pragma mark -礼物界面
- (AHGiftView *)giftView{
    if (!_giftView) {
        AHGiftView *giftView = [AHGiftView shareGiftView];
        [self.view addSubview:giftView];
        _giftView = giftView;
        [giftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
        
        //关闭礼物界面
        [giftView setCloseGiftViewBlock:^{
            
            [UIView animateWithDuration:0.5 animations:^{
                self.giftView.transform = CGAffineTransformMakeTranslation(0, 245);
            } completion:^(BOOL finished) {
                [self.giftView removeFromSuperview];
                self.giftView = nil;
            }];
            //            [[NSNotificationCenter defaultCenter]postNotificationName:kNotifiGameSwipeUp object:nil];
            
        }];
        [giftView setRechargeBlock:^{
            self.rechargeView.goldCoin = [[AHPersonInfoManager manager]getInfoModel].goldCoins;
        }];
        NSString *uuid = [NSString getUUIDSString];
        //发红包
        [giftView setSenderRedPacketViewBlock:^{
            sendRedView* redPacketView  = [baseRedPacket initWithSendRed];
            _redPacketSenderView = redPacketView;
        }];
    }
    return _giftView;
}

#pragma mark -充值界面
- (AHRechargeView *)rechargeView{
    
    if (_rechargeView == nil) {
        AHRechargeView *rechaView = [AHRechargeView rechargeShareView];
        _rechargeView = rechaView;
        [self.view addSubview:rechaView];
        [rechaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
        [rechaView setCloseRecherView:^{
            [self.rechargeView removeFromSuperview];
            self.rechargeView = nil;
        }];
    }
    return _rechargeView;
}

#pragma mark -金币不足弹框界面
- (AHGoldLackPopView *)goldLackView{

    if (_goldLackView == nil) {
        AHGoldLackPopView  *goldLackView = [AHGoldLackPopView shareGoldLackView];
        _goldLackView = goldLackView;
    }
    return _goldLackView;
}

//赢多的结算界面
- (AHCurrencySuccessView *)currencySuccess{
    
    if (!_currencySuccess) {
        AHCurrencySuccessView *currencySuccess = [AHCurrencySuccessView currencySuccessShareView];
        [self.view addSubview:currencySuccess];
        _currencySuccess = currencySuccess;
        [currencySuccess mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
    }
    return _currencySuccess;
}

- (AHLiveSenderMessageToolView *)messageToolView{
    
    if (!_messageToolView) {
        _messageToolView = [[AHLiveSenderMessageToolView alloc]init];
    }
    return _messageToolView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
#warning 根据是否在游戏中取消手势响应
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件（申请上下庄里面有UIView，顾添加UIView）
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        return NO;
    }
    return _isSwpite;
}

- (void)dealloc{
    
    LOG(@"%s",__func__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (_ringPlayer) {
        [_ringPlayer stop];
        _ringPlayer = nil;
    }
    [self removeGameRemind];
}

@end
