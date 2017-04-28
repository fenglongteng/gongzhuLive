//
//  AHBankerLiveController.m
//  NiuNiuLive
//
//  Created by anhui on 17/4/11.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBankerLiveController.h"
#import "GPUImageBeautifyFilter.h"
#import "H264Encoder.h"
#import "AHLiveAnchorView.h"
#import "AACEncoder.h"
#import "MediaPackages.pbobjc.h"
#import "LiveUsers.pbobjc.h"
#import "AHLiveSocketManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AHLiveGameView.h"
#import "AHAnchorLiveSettingView.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"
#import "gameRemind.h"
#import "gameFinishView.h"
#import "endCreatingLive.h"
#import "AHSuccessOrFailView.h"
#import "AHContributeView.h"
#import "AHApplyForBanker.h"
#import "AHAnchorUserPopView.h"
#import "inviteView.h"
#import "pokerAnimation.h"
#import "AHDirectMessagesView.h"
#import "AHAlertView.h"
#import "AHToolBtnView.h"
#import "AHWinnerView.h"

#import <AVFoundation/AVFoundation.h>

#define GAMEFLAGS @"gameFlags"
@interface AHBankerLiveController ()<H264EncoderDelegate,GPUImageVideoCameraDelegate,CAAnimationDelegate,UIGestureRecognizerDelegate>{
    AVAudioPlayer * _ringPlayer;
    NSString * _gameid;//当前局游戏id,
    //上一个庄的信息
    DouNiuBanker * _bankerMes;
    //当前庄的id
    NSString * _currentBankerid;
    
}
@property (nonatomic,copy)NSString * finishGameid;//游戏结束时id,用来查看大赢家，让主播游戏结束才能看到大赢家
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, weak) GPUImageView *captureVideoPreview;
@property (nonatomic,strong)AACEncoder *aacencoder;//音频解码
@property (nonatomic,strong)H264Encoder *h264Encoder;
@property (nonatomic,assign)NSTimeInterval time;
@property (nonatomic,assign)int64_t  frameId;
@property (nonatomic,assign)int64_t  AudioframeId;

@property (nonatomic,strong)AHLiveAnchorView *bankerAnchorView;//主播信息
@property (nonatomic,strong)AHLiveGameView *gameView;//游戏的界面
@property (nonatomic,strong)AHAnchorLiveSettingView *liveSetting;//插件框
@property (nonatomic,assign)CGSize outputSize;
@property (nonatomic,strong)AHSuccessOrFailView * recordView;//胜负走势图

@property (nonatomic,strong)gameRemind * gameRemindView; //游戏相关提示、动画View

@property (nonatomic,strong)gameFinishView * gameFinish;//游戏等待或结束时

@property (nonatomic,strong)AHContributeView *contributeView;//贡献榜

@property (nonatomic,strong)AHApplyForBanker *forBankber;//申请上下庄

@property (nonatomic,strong)AHAnchorUserPopView *anchorPopView;//点击用户弹出框

@property (nonatomic,strong)inviteView * inviteview;//邀请界面

@property (nonatomic,strong)GPUImageBeautifyFilter *beautifyFiler;

@property (nonatomic,strong)UIImageView *backImageView;//背景图片

@property (nonatomic,assign)BOOL isSwpite;//是否需要下上手势

@property (nonatomic,assign)BOOL isSpsPps;//解码

@end

@implementation AHBankerLiveController

//连接直播服务器 并进行登录
- (void)connectLiveSocket{
    
    [[AHLiveSocketManager instance] connectWithIp:liveSocketHost port:30003 connectSuccess:^(int status) {
        //连接成功 根基房间ID进行登录
        if (status == 0) {
            //登录房间
            [self loginRooms:self.roomId];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self connectLiveSocket];
}

#pragma mark - 创建手势 下滑和上提
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

#pragma mark -手势通知
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGesture{

    if(swipeGesture.direction==UISwipeGestureRecognizerDirectionDown) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeDown object:self];
        [pokerAnimation pokerAnimation].xiaHeight = 210;
    }
    if(swipeGesture.direction==UISwipeGestureRecognizerDirectionUp) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeUp object:self];
        [pokerAnimation pokerAnimation].xiaHeight = 0;
    }
}

#pragma mark- 弹出系统消息界面
- (void)popDirectMessagesView{
    
    AHDirectMessagesView *directView = [[AHDirectMessagesView alloc]init];
    
    [directView showOnTheWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加手势通知
    [self createSwipestureRecongnizer];
    //获取主播
    self.backImageView.image = [UIImage imageNamed:@"bg_poker"];
    [self.view addSubview:self.backImageView];
    //禁用本页面系统侧滑返回手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    //注册通知 点击用户头像及用户名的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBanerUser:) name:kNotifyBankerClickUser object:nil];
    self.frameId = 0;
    self.AudioframeId = 0;
    self.bankerAnchorView.roomId = self.roomId;
    self.bankerAnchorView.isBanker = YES;//是主播
    self.gameView.bankerToolView.hidden = NO;//显示toolView
    self.gameView.gameRoomid = self.roomId;
    WeakSelf;
    [self.gameView setBankerToolButtonBlock:^(UIButton *sender, NSInteger buttonType) {
        //根基不同的sender Type 执行不同的处理
        switch (buttonType) {
            case ToolButtonPlug://插件
                [weakSelf.liveSetting showAnchorLiveSetView];
                break;
            case ToolButtonMessage://消息
                [weakSelf popDirectMessagesView];
                break;
            case ToolButtonSecurity://密码
                [weakSelf addSettingView];
                break;
            case ToolButtonScreen://屏幕切换
                
                break;
            case ToolButtonWinner:{
                AHWinnerView *winnerView = [AHWinnerView shareWinerView];
                winnerView.roomid = weakSelf.roomId;
                [winnerView setGameid:weakSelf.finishGameid];
                [winnerView showWinnerViewFrom:sender];
                
            }   break;
            case ToolButtonGameClose:{//关闭游戏
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:GAMEFLAGS] intValue]==1) {
                    return ;
                }
                __block AHAlertView * alert = [[AHAlertView alloc] initSetAlertViewTitle:@"确认关闭游戏？" detailString:@"这局游戏结束之后将会关闭游戏，同时清除当前游戏的所有玩家" AndLeftBt:@"取消" AndRight:@"确定" cancelAction:^{
                    alert = nil;
                } settingAction:^{
                    _isSwpite = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeDown object:weakSelf];
                    [pokerAnimation pokerAnimation].xiaHeight = 210;
                    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:GAMEFLAGS];
                    [weakSelf controlGameRoom];
                    alert = nil;
                }];
                [alert showAlert];
            } break;
                
            default:
                break;
        }
    }];
    //音视频解码
    [self setAudioEncodeVideoEncoder];
    //创建游戏房间
    [self createGameRoom];
    
    //游戏相关回调
    [[GameSocketManager instance] addHandler:^int(PackHeader *header, NSData *body) {
        //DouNiuEventBet
        DouNiuEventBet * douniu = GetMessage(DouNiuEventBet, body);
        if (douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtbegin) {
            //开始下注
            //当局结束，判断是否变庄
            DouNiuEventBet * rt = GetMessage(DouNiuEventBet, body);
            [self.gameView setBankerMessage:rt.banker];
            [self.gameView isMeOfBankerWithBankerid:rt.banker.id_p];
            if (![_bankerMes.id_p isEqualToString:rt.banker.id_p] && _bankerMes) {
                _bankerMes = rt.banker;
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"玩家%@上庄",rt.banker.nickName]];
            }
            [[pokerAnimation pokerAnimation] removeAllPokerImage];
            _currentBankerid = rt.banker.id_p;
            [_gameFinish removeFromSuperview];
            _gameFinish = nil;
            [weakSelf.gameRemindView removeFromSuperview];
            weakSelf.gameRemindView = nil;
            _gameid = douniu.gameId;
            [weakSelf startToLicensing:douniu.tickLeft];
        }else if (douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtend){
            //等待游戏开始
        }else if (douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtchanged){
            
        }else if (douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtnext){
            //新的一局已经开始了，等待几秒下注
          
        }else if(douniu.dneb == DouNiuEventBet_DBEBTypes_Dbebtstart){
            //游戏重新开始
            [self gameWaitingOfShowFinshViewWithIsCard:NO];
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
        [_gameRemindView licensingOfServiceWithTag:result gameView:self.gameView];
        //投注时间到，关闭投注
        [_gameView gameWithStarting:NO];
        _gameRemindView.licensingBlock = ^(gameRemind * gameRemindView){
            [gameRemindView startLicensing:result];
        };
        //[self.gameView otherPlayerToBetting:result.allBetsArray];
        return 0;
    } withProtoType:ProtoTypes_PtIddouNiuEventGameResult];
}
//通知服务器 主播已开启/关闭游戏
- (void)openGameRequest:(BOOL)isGaming{
    UsersAlterInfoRequest * alterInfo = [[UsersAlterInfoRequest alloc] init];
    if (isGaming == YES) {
        alterInfo.field = (0x01 << 9) + (0x01 << 10);
        alterInfo.gameName = @"百人牛牛";
    }else{
        alterInfo.field = 0x01 << 9;
    }
    alterInfo.isGaming = isGaming;
    [[AHTcpApi shareInstance] requsetMessage:alterInfo classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersAlterInfoResponse * alterRes = (UsersAlterInfoResponse *)response;
        if (alterRes.result == 0) {
            
        }
    }];
}

//添加邀请关注用户的界面
- (void)addSettingView{
    if (!self.inviteview) {
        self.inviteview = [inviteView initInviteView];
        self.inviteview.frame = self.view.bounds;
        self.inviteview.roomid = self.roomId;
        [self.view addSubview:self.inviteview];
        [self.inviteview settingViewShow];
    }else{
        [self.inviteview settingViewShow];
    }
    WeakSelf;
    self.inviteview.closeBlock = ^{
        //动画显示
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = 0.2;
        scaleAnimation.beginTime = CACurrentMediaTime();
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.1];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.delegate = weakSelf;
        scaleAnimation.fillMode = kCAFillModeForwards;
        [weakSelf.inviteview.layer addAnimation:scaleAnimation forKey:@"scaleAnim"];
    };
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.inviteview.layer animationForKey:@"scaleAnim"]) {
        [self.inviteview removeFromSuperview];
        self.inviteview = nil;
    }
    
}

//游戏开始
- (void)startToLicensing:(int)betTime{
    [self gameWaitingOfShowRemindView:NO timeTickLeft:betTime];
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
    int32_t gameFlags = [[[NSUserDefaults standardUserDefaults] objectForKey:GAMEFLAGS] intValue];
    self.finishGameid = _gameid;//游戏动画结束，把游戏id赋值给大赢家接口，同事重置gameid。
    _gameid = @"";
    if (gameFlags == 0) {
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
    
}


// 创建视频源
- (void)getVideoAudioImageCamera{

    // SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
    // cameraPosition:摄像头方向
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.delegate = self;
    [videoCamera addAudioInputsAndOutputs];
    
    _videoCamera = videoCamera;
    //    // 创建最终预览View
    GPUImageView *captureVideoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    captureVideoPreview.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [captureVideoPreview setInputRotation:kGPUImageFlipHorizonal atIndex:0];
    [self.view insertSubview:captureVideoPreview aboveSubview:self.backImageView];
    _captureVideoPreview = captureVideoPreview;
    // 设置处理链
    //    [_videoCamera addTarget:_captureVideoPreview];
    //     创建美颜滤镜
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    _beautifyFiler = beautifyFilter;
    // 设置GPUImage处理链，从数据源 => 滤镜 => 最终界面效果
    [videoCamera addTarget:beautifyFilter];
    [beautifyFilter addTarget:_captureVideoPreview];
    // 必须调用startCameraCapture，底层才会把采集到的视频源，渲染到GPUImageView中，就能显示了。
    // 开始采集视频
    [videoCamera startCameraCapture];
    
    CGSize outputSize = CGSizeMake(640, 480);
    
    self.outputSize = outputSize;
    
    GPUImageRawDataOutput *rawDataOutput = [[GPUImageRawDataOutput alloc]initWithImageSize:outputSize resultsInBGRAFormat:YES];
    
    [beautifyFilter addTarget:rawDataOutput];
    
    __weak GPUImageRawDataOutput *weakOutput = rawDataOutput;
    __weak typeof(self)weakself = self;
    //获取带滤镜效果的数据
    [rawDataOutput setNewFrameAvailableBlock:^{
        __strong GPUImageRawDataOutput *strongOutput = weakOutput;
        [strongOutput lockFramebufferForReading];
        // 这里就可以获取到添加滤镜的数据了
        GLubyte *outputBytes = [strongOutput rawBytesForImage];
        NSInteger bytesPerRow = [strongOutput bytesPerRowInOutput];
        CVImageBufferRef pixelBuffer = NULL;
        CVPixelBufferCreateWithBytes(kCFAllocatorDefault, outputSize.width, outputSize.height, kCVPixelFormatType_32BGRA, outputBytes, bytesPerRow, nil, nil, nil, &pixelBuffer);
        [weakself.h264Encoder encode:pixelBuffer];
        [strongOutput unlockFramebufferAfterReading];
        CFRelease(pixelBuffer);
    }];
}

#pragma mark -进入直播界面 登录
- (void)loginRooms:(NSString *)roomId{
    
    LiveUsersLoginRequest *loginRequest = [[LiveUsersLoginRequest alloc]init];
    loginRequest.userId = roomId;
    loginRequest.type = LiveUsersLoginRequest_Type_Pusher;
    NSString *token = [[[AHPersonInfoManager manager] getInfoModel] token];
    loginRequest.token = token;
    [[AHLiveSocketManager instance]sendMessage:loginRequest classSite:UsersClassName block:^(id response) {
        //设置摄像头 采集视频 音频
        [self getVideoAudioImageCamera];
    }];
}

#pragma mark -登出直播界面
- (void)logoutLiveRoom:(NSString *)roomId{

    LiveUsersLogoutRequest *logoutReq = [[LiveUsersLogoutRequest alloc]init];
    logoutReq.userId = roomId;
    [[AHLiveSocketManager instance]sendMessage:logoutReq classSite:UsersClassName block:^(id response) {
    }];
}

- (void)controlGameRoom{
    int32_t gameFlags = [[[NSUserDefaults standardUserDefaults] objectForKey:GAMEFLAGS] intValue];
    DouNiuControlRoom * creatGame = [[DouNiuControlRoom alloc] init];
    creatGame.flags = gameFlags;
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuControlRoom andMessage:creatGame andHandler:^int(PackHeader *header, NSData *body) {
        DouNiuEnterRoomRes * res = GetMessage(DouNiuEnterRoomRes ,body);
        if ( res.status == DouNiuControlRoom_ResponseStatus_Rsok) {
            //主播已经开启游戏
            if (gameFlags == 0) {
                [self openGameRequest:YES];
                //设置庄家信息
                DouNiuBanker * banker = res.room.banker;
                _bankerMes = banker;
                [self.gameView setBankerMessage:banker];
                [self gameWaitingOfShowFinshViewWithIsCard:NO];
            }else{
                [self openGameRequest:NO];
            }
        }
        return 0;
    }];

}

//创建游戏房间
- (void)createGameRoom{
    int32_t gameFlags = [[[NSUserDefaults standardUserDefaults] objectForKey:GAMEFLAGS] intValue];
    DouNiuCreateRoom * creatGame = [[DouNiuCreateRoom alloc] init];
    creatGame.flags = gameFlags;
    if (gameFlags == 1) {
        _isSwpite = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeDown object:self];
        [pokerAnimation pokerAnimation].xiaHeight = 210;
    }
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuCreateRoom andMessage:creatGame andHandler:^int(PackHeader *header, NSData *body) {
        DouNiuEnterRoomRes * res = GetMessage(DouNiuEnterRoomRes ,body);
        if ( res.status == 0) {
            //主播已经开启游戏
            if (gameFlags == 0) {
                [pokerAnimation pokerAnimation].isStop = NO;
                _isSwpite = YES;
                [self openGameRequest:YES];
                //设置庄家信息
                DouNiuBanker * banker = res.room.banker;
                _bankerMes = banker;
                [self.gameView setBankerMessage:banker];
                [self gameWaitingOfShowFinshViewWithIsCard:NO];
            }else{
                [self openGameRequest:NO];
            }
        }
        if (res.status == 1) {
            [self getGameStatus:res];
        }
        return 0;
    }];
}

- (void)getGameStatus:(DouNiuEnterRoomRes *)res{
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

#pragma mark - 音视频解码初始化
- (void)setAudioEncodeVideoEncoder{
    //初始化音频解码
    self.aacencoder = [[AACEncoder alloc]init];
    //初始化视频解码
    self.h264Encoder = [H264Encoder new];
    [self.h264Encoder initWithConfiguration];
    [self.h264Encoder initEncode:640 height:480];
    self.h264Encoder.delegate = self;
}

#pragma mark -视频采集
-(void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    //获得的数据 video
    CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    double dpts = (double)(pts.value)/pts.timescale;
    self.time = dpts;
}

#pragma mark -音频采集
- (void)willOutputSampleAudioBuffer:(CMSampleBufferRef)sampleBuffer{
    //获得的数据 audio
    CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    double dpts = (double)(pts.value)/pts.timescale;
    [self.aacencoder encodeSampleBuffer:sampleBuffer completionBlock:^(NSData *encodedData, NSError *error) {
        //音频文件
        MediaPackage *media = [[MediaPackage alloc]init];
        media.mediaType = MediaPackageMediaType_MediaPackageMediaTypeAudio;
        media.codecType = MediaPackageCodecType_MediaPackageCodecTypeAac;
        media.roomId = self.roomId;
        media.size = (int32_t)encodedData.length;
        media.totalSize = (int32_t)encodedData.length;
        media.data_p = encodedData;
        media.timestamp = dpts;
        media.hasRemain = NO;
        media.frameId = self.AudioframeId;
        media.packageId = 0;
        [self sendAudioAAcData:media];
    }];
}

#pragma mark -H264EncoderDelegate 编码
- (void)gotSpsPps:(NSData*)sps pps:(NSData*)pps{

    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    NSMutableData *data = [NSMutableData data];
    [data appendData:ByteHeader];
    [data appendData:sps];
    
    MediaPackage *media = [[MediaPackage alloc]init];
    media.mediaType =  MediaPackageMediaType_MediaPackageMediaTypeVideo;
    media.codecType = MediaPackageCodecType_MediaPackageCodecTypeH264;
    media.h264FrameType  = H264FrameType_H264FrameTypeSps;
    media.packageId = 0;
    media.roomId = self.roomId;
    media.width = self.outputSize.width;
    media.height = self.outputSize.height;
    media.frameId = self.frameId;
    media.hasRemain = NO;
    media.data_p = data;
    media.timestamp = self.time;
    media.totalSize = (int32_t)data.length;
    media.size = (int32_t)data.length;
    //上传
    [self senderData:media];
   
    [data resetBytesInRange:NSMakeRange(0, [data length])];
    [data setLength:0];
    [data appendData:ByteHeader];
    [data appendData:pps];
    
    MediaPackage *mediapps = [[MediaPackage alloc]init];
    mediapps.mediaType =  MediaPackageMediaType_MediaPackageMediaTypeVideo;
    mediapps.codecType = MediaPackageCodecType_MediaPackageCodecTypeH264;
    mediapps.h264FrameType  = H264FrameType_H264FrameTypePps;
    mediapps.packageId = 0;
    mediapps.roomId = self.roomId;
    mediapps.width = self.outputSize.width;
    mediapps.height = self.outputSize.height;
    mediapps.frameId = self.frameId;
    mediapps.hasRemain = NO;
    mediapps.data_p = data;
    mediapps.totalSize = (int32_t)data.length;
    mediapps.timestamp = self.time;
    mediapps.size = (int32_t)data.length;
    //上传
    [self senderData:mediapps];
//    self.isSpsPps = YES;
}

- (void)gotEncodedData:(NSData*)data isKeyFrame:(BOOL)isKeyFrame{
    
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
   // NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    NSMutableData *h264Data = [NSMutableData new];
    [h264Data appendBytes:bytes length:length];
    [h264Data appendData:data];
    NSMutableData *naluData = [h264Data mutableCopy];
    //判断帧
    int nalu =  [self decodeNalu:(uint8_t *)[naluData bytes] withSize:(uint32_t)naluData.length];
    switch (nalu) {
        case 0x05:
            [self senderH264Data:h264Data h264FrameType:3];
            break;
        case 0x06:
            [self senderH264Data:h264Data h264FrameType:5];
            break;
        default:
            [self senderH264Data:h264Data h264FrameType:4];
            break;
    }
}
#pragma mark -确定帧
-(int)decodeNalu:(uint8_t *)frame withSize:(uint32_t)frameSize
{
    int nalu_type = (frame[4] & 0x1F);
    //CVPixelBufferRef pixelBuffer = NULL;
    uint32_t nalSize = (uint32_t)(frameSize - 4);
    uint8_t *pNalSize = (uint8_t*)(&nalSize);
    frame[0] = *(pNalSize + 3);
    frame[1] = *(pNalSize + 2);
    frame[2] = *(pNalSize + 1);
    frame[3] = *(pNalSize);
    //传输的时候。关键帧不能丢数据 否则绿屏   B/P可以丢  这样会卡顿
    return nalu_type;
}

#pragma mark -帧类型 并进行拆分
- (void)senderH264Data:(NSData *)h264Data h264FrameType:(int)frameType{
    
    if (h264Data.length == 0) {
        return;
    }
    int mtu = 1200;
    int i = (int)h264Data.length/mtu;
    int residue = h264Data.length%mtu;
    int packageId = 0;
    if (i>=1) {
        packageId = 0;
        int j = 0;
        while (j<i) {
            NSData *mtuData = [h264Data subdataWithRange:NSMakeRange(mtu*j, mtu)];
            MediaPackage *mediapage = [[MediaPackage alloc]init];
            mediapage.mediaType =  MediaPackageMediaType_MediaPackageMediaTypeVideo;
            mediapage.codecType = MediaPackageCodecType_MediaPackageCodecTypeH264;
            mediapage.width = self.outputSize.width;
            mediapage.height = self.outputSize.height;
            mediapage.totalSize = (int32_t)h264Data.length;
            //需要判断帧类型
            mediapage.h264FrameType  = frameType;
            mediapage.roomId = self.roomId;
            mediapage.frameId = self.frameId;
            mediapage.packageId = packageId;
            mediapage.hasRemain = YES;
            mediapage.size = mtu;
            mediapage.data_p = mtuData; //帧数据
            mediapage.timestamp = self.time;
            [self senderData:mediapage];
            ++packageId;
            ++j;
        }
        
        NSData *resideData = [h264Data subdataWithRange:NSMakeRange(mtu*i, residue)];
        MediaPackage *mediapage = [[MediaPackage alloc]init];
        mediapage.mediaType =  MediaPackageMediaType_MediaPackageMediaTypeVideo;
        mediapage.codecType = MediaPackageCodecType_MediaPackageCodecTypeH264;
        mediapage.width = self.outputSize.width;
        mediapage.height = self.outputSize.height;
        mediapage.totalSize = (int32_t)h264Data.length;
        //需要判断帧类型
        mediapage.h264FrameType = frameType;
        mediapage.roomId = self.roomId;
        mediapage.frameId = self.frameId;//帧编号
        mediapage.packageId = packageId;
        mediapage.hasRemain = NO;
        mediapage.size = residue;
        mediapage.timestamp = self.time;
        mediapage.data_p = resideData; //帧数据
        [self senderData:mediapage];
    }
    else{
        MediaPackage *mediapage = [[MediaPackage alloc]init];
        mediapage.mediaType =  MediaPackageMediaType_MediaPackageMediaTypeVideo;
        mediapage.codecType = MediaPackageCodecType_MediaPackageCodecTypeH264;
        mediapage.width = self.outputSize.width;
        mediapage.height = self.outputSize.height;
        mediapage.totalSize = (int32_t)h264Data.length;
        //需要判断帧类型
        mediapage.h264FrameType  = frameType;
        mediapage.roomId = self.roomId;
        mediapage.frameId = self.frameId; //帧编号
        mediapage.packageId = packageId;
        mediapage.hasRemain = NO;
        mediapage.size = residue;
        mediapage.data_p = h264Data;
        mediapage.timestamp = self.time;
        
        [self senderData:mediapage];
    }
}

#pragma mark -推流音频
- (void)sendAudioAAcData:(id)audioMessagePacket{
    
    ++self.AudioframeId;
    [[AHLiveSocketManager instance]sendMessage:audioMessagePacket classSite:@"MediaPackages" block:nil];
}

#pragma mark - 推流
- (void)senderData:(id)messageObj{
    
    MediaPackage *mediapage  = (MediaPackage *)messageObj;
    if (!mediapage.hasRemain) {
        ++self.frameId;
    }
    [[AHLiveSocketManager instance]sendMessage:messageObj classSite:@"MediaPackages" block:nil];
}

#pragma mark -点击用户，弹出详情 通知类
- (void)clickBanerUser:(NSNotification *)notification{
    
    NSDictionary *user = notification.userInfo;
    NSString *userid = [user objectForKey:@"userId"];
    if (user != nil && userid.length != 0) {
        
        [self.anchorPopView showAnchorUserPopViewUserid:userid];
    }
}

#pragma mark - 主播头信息
- (AHLiveAnchorView *)bankerAnchorView{
    if (!_bankerAnchorView) {
        AHLiveAnchorView *anchorView = [AHLiveAnchorView liveAnchorView];
        [self.view insertSubview:anchorView aboveSubview:self.view];
        _bankerAnchorView = anchorView;
        __weak typeof(self) weakself = self;
        //退出房间
        anchorView.closeLiveBlock = ^(){
            //退出视频采集
             [weakself  closeLiveCamera];
            [weakself logoutLiveRoom:weakself.roomId];
            //退出游戏房间,游戏继续。
            [pokerAnimation destructionDealloc];
            DouNiuEnterRoom * enterGame = [[DouNiuEnterRoom alloc] init];
            enterGame.roomId = weakself.roomId;
            [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuLeaveRoom andMessage:enterGame andHandler:^int(PackHeader *header, NSData *body) {
                
                DouNiuEnterRoomRes * res = GetMessage(DouNiuEnterRoomRes ,body);
                if (res.status == 0) {
                    NSLog(@"退出游戏成功！");
                }
                return 0;
            }];
            [weakself.navigationController pushViewController:[[endCreatingLive alloc] init] animated:NO];
        };
        //点击显示贡献榜
        [anchorView setClickContributeShowBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
          weakself.contributeView.transform = CGAffineTransformIdentity;
            }];
        }];
        //布局
        [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@80);
            make.top.equalTo(@10);
        }];
    }
    return _bankerAnchorView;
}

#pragma mark - 游戏界面
- (AHLiveGameView *)gameView{
    
    if (!_gameView) {
        AHLiveGameView *gameView = [AHLiveGameView liveGameShareView];
        gameView.setBackView.hidden = YES;//隐藏
        gameView.gameRecoder.hidden = NO;//数据按钮显示
        [self.view addSubview:gameView];
        gameView.messageTableView.tableHeaderView = nil;
        _gameView = gameView;
        __weak typeof(self)weakself = self;
        //记录界面弹出
        gameView.popRecordBlock = ^{
            weakself.recordView.roomid = weakself.roomId;
            [UIView animateWithDuration:0.5 animations:^{
                weakself.recordView.transform = CGAffineTransformIdentity;
            }];
        };
        //申请上下庄
        [gameView setApplyBankerBlock:^{
            //游戏房间id
            [weakself.forBankber setBankerMessageWithRoomid:weakself.roomId currentBankerid:_currentBankerid];
        }];
        [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@90);
            make.bottom.equalTo(@0);
        }];
        //充值 现在还没有具体确认 提供接口
        [gameView setRechargeBlock:^{
            
        }];
    }
    return _gameView;
}

#pragma mark -用户信息
- (AHAnchorUserPopView *)anchorPopView{
    
    if (!_anchorPopView) {
        AHAnchorUserPopView *anchorView = [AHAnchorUserPopView shareLiveUserPopView];
        _anchorPopView = anchorView;
    }
    return _anchorPopView;
}

- (AHApplyForBanker *)forBankber{
    if (!_forBankber) {
        AHApplyForBanker *applyBanker = [AHApplyForBanker shareApplyForBanker];
        [self.view addSubview:applyBanker];
        _forBankber = applyBanker;
        [applyBanker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(screenHeight));
        }];
        //关闭申请上下庄弹框
        [applyBanker setCloseBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                self.forBankber.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.forBankber removeFromSuperview];
                self.forBankber = nil;
            }];
        }];
    }
    return _forBankber;
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

#pragma mark -插件设置
- (AHAnchorLiveSettingView *)liveSetting{
    if (_liveSetting == nil) {
        AHAnchorLiveSettingView *liveSettingView  = [AHAnchorLiveSettingView shareAnchorLiveSetting];
        _liveSetting = liveSettingView;
        __weak typeof(self) weakself = self;
        [liveSettingView setToolBtnBlock:^(AHToolBtnView *toolBtnView){
            LOG(@"%@",toolBtnView);
     #warning 根据button不同 对直播进行处理  屏幕  声音 等
            if ([toolBtnView.toolNameLb.text isEqualToString:@"百人牛牛"]) {
                int32_t gameFlags = [[[NSUserDefaults standardUserDefaults] objectForKey:GAMEFLAGS] intValue];
                if (gameFlags == 1) {
                    [pokerAnimation pokerAnimation].isStop = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiGameSwipeUp object:self];
                    [pokerAnimation pokerAnimation].xiaHeight = 0;
                    _isSwpite = YES;
                    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:GAMEFLAGS];
                    [weakself controlGameRoom];
                }
            }
        }];
    }
    return _liveSetting;
}

#pragma mark -贡献榜
- (AHContributeView *)contributeView{
    if (!_contributeView) {
        AHContributeView *contributeView = [AHContributeView contributeShareView];
        [self.view addSubview:contributeView];
        _contributeView = contributeView;
        
        [contributeView setMeKnowBlock:^{
            [UIView animateWithDuration:0.3 animations:^{
                self.contributeView.transform = CGAffineTransformMakeScale(0.05, 0.05);
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件（申请上下庄里面有UIView，顾添加UIView）
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        return NO;
    }
    return _isSwpite;
}

- (BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)closeLiveCamera{
    //需要在关闭直播的时候调用
    [self.videoCamera stopCameraCapture];
    [self.videoCamera removeInputsAndOutputs];
    [self.videoCamera removeAllTargets];
    [self.beautifyFiler removeAllTargets];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIImageView *)backImageView{

    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.frame = self.view.bounds;
        _backImageView.userInteractionEnabled = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}

- (void)dealloc{
  
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    LOG(@"%s",__func__);
}

@end
