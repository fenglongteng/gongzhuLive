//
//  GameSocketManager.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/7.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"
#import "GameTcpApi.h"

#define HeaderLength 20
@interface GameSocketManager()<GCDAsyncSocketDelegate>{
    //parsing 解析包使用
    PackHeader* header;//if this is nil we are receiving the header, other wise the body.
    
    NSMutableData * protuData;
    int16_t length;
    int16_t lengthAll;
    NSData* emptyData;
    NSMutableDictionary* dictProto;//
    NSMutableDictionary* dictResponse;
    int32_t packageIndex;
}

@property (nonatomic,strong)id<ParsingPackageDelegate> parsingDelegate;
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) dispatch_queue_t socketQueue;         // 发数据的串行队列
@property (strong, nonatomic) dispatch_queue_t receiveQueue;        // 收数据处理的串行队列
@property (strong, nonatomic) NSString *ip;
@property (assign, nonatomic) UInt16 port;
@property (assign, nonatomic) BOOL isConnecting;

@property (nonatomic,strong)completionResult completionResult;

@property (nonatomic,strong)NSTimer *heartTimer;    //心跳定时器
@property (nonatomic,assign)BOOL shouldHeart;       //是否需要心跳
@property (nonatomic,assign)BOOL loginStatus;      //登录状态

@end

static GameSocketManager * gameSocket = nil;
static NSTimeInterval TimeOut = 60;       // 超时时间, 超时会关闭 socket

@implementation GameSocketManager

+ (GameSocketManager *)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameSocket = [[GameSocketManager alloc] init];
    });
    return gameSocket;
}
- (instancetype)init {
    if (self = [super init]) {
        self.isConnecting = false;
        GameDelegate * gameDelegate = [[GameDelegate alloc] init];
        self.parsingDelegate = gameDelegate;
        packageIndex = 1;
        header = nil;
        protuData = [[NSMutableData alloc] init];//initWithBytes:"" length:0];
        emptyData = [[NSData alloc] init];
        length = 0;
        lengthAll = HeaderLength;
        
        dictProto = [NSMutableDictionary dictionary];
        dictResponse = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)sendHeartPacket{
    //发送心跳包
    NSLog(@"Sending heart beat package");
    EchoBuf * req = [EchoBuf new];
    req.hello = @"echo";
    [self sendPackage:ProtoTypes_PtIdecho andMessage:req];
}

//开启心跳
- (void)startHeartBeat{
    self.shouldHeart = YES;
    [self tryOpenTimer];
    
}

// 关闭心跳，退出时关闭，关闭后不会自动开启
- (void)closeHeartBeat{
    self.shouldHeart = NO;
    [self closeTimer];
}

- (void)tryOpenTimer{
    
    if ([[GameSocketManager instance] status] && self.shouldHeart) {
        //[self sendHeartPacket];
        //[self closeTimer];
        // timer 要在主线程中开启才有效
        dispatch_async(dispatch_get_main_queue(), ^{
            self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(sendHeartPacket) userInfo:nil repeats:true];
            
        });
    }
}

- (void)closeTimer{
    
    if (self.heartTimer != nil) {
        [self.heartTimer timeInterval];
        self.heartTimer = nil;
    }
}

- (dispatch_queue_t)socketQueue {
    if (_socketQueue == nil) {
        _socketQueue = dispatch_queue_create("com.gameSendSocket", DISPATCH_QUEUE_SERIAL);
    }
    return _socketQueue;
}

- (dispatch_queue_t)receiveQueue {
    if (_receiveQueue == nil) {
        _receiveQueue = dispatch_queue_create("com.gameReceiveSocket", DISPATCH_QUEUE_SERIAL);
    }
    return _receiveQueue;
}

- (void)resetSocket {
    [self disConnect];
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
    self.socket.IPv6Enabled = true;
    self.socket.IPv4Enabled = true;
    self.socket.IPv4PreferredOverIPv6 = false;     // 4 优先
}

- (void)connectWithIp:(NSString *)ip port:(UInt16)port {
    self.ip = ip;
    self.port = port;
    [self resetSocket];
    NSError *error = nil;
    [self.socket connectToHost:self.ip onPort:self.port withTimeout:15 error:&error];   // 填写 地址，端口进行连接
    if (error != nil) {
        NSLog(@"游戏socket连接错误：%@", error);
    }
}

- (void)disConnect {
    [self.socket disconnect];
    self.socket = nil;
    self.socketQueue = nil;
}

- (void)send:(NSData *)data{

    if (self.socket == nil || self.socket.isDisconnected) {
        [self connectWithIp:self.ip port:self.port];
    }

    [self.socket writeData:data withTimeout:TimeOut tag:110];

}

//判断连接状态
- (BOOL)status {
    
    if (self.socket != nil && self.socket.isConnected) {
        return true;
    }
    return false;
}

// 代理方法 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    LOG(@"游戏socket连接成功");
    [self.socket readDataWithTimeout:TimeOut tag:110];
}

//连接失败 或连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    LOG(@"游戏socket连接断开, %@",err);
    self.socket = nil;
    self.socketQueue = nil;
    [self closeHeartBeat];
    [self reset];
    dictResponse = [NSMutableDictionary new];
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    [self onData:data];
    
    [self.socket readDataWithTimeout:TimeOut tag:110];
    
}

- (uint16_t)parsingGetedData:(NSData *)data{
    
    NSData *buffLengthData = [data subdataWithRange:NSMakeRange(18, 2)];
    uint16_t buffLength;
    [buffLengthData getBytes:&(buffLength) length:sizeof(buffLength)];
    
    NTOHS(buffLength);

    return buffLength;
}

-(void) reset{
    header = nil;
    //data = [[NSMutableData alloc] init];//initWithBytes:"" length:0];
    length = 0;
    lengthAll = HeaderLength;
    [protuData setLength:0];
}


-(void) onPackage:(PackHeader*) head andBody:(NSData*) dat{
    //[delegate onPackage:head andBody:dat];
    
    //parsing data
    if(head.Res == 1){
        //see and more head.PackageIndex
        pfnPackageHandler block = [dictResponse objectForKey:@(head.PackageIndex)];
        [dictResponse removeObjectForKey:@(head.PackageIndex)];
        
        if(block != nil){
            //parsing package
            /*
            NSData *bufferData = dat;
            GPBMessage *message = [[GPBMessage alloc]init];
            message =  [message initWithData:bufferData extensionRegistry:nil error:nil];
             */
            
            //GPBMessage* message = GetMessage(GPBMessage, dat);
            //go to main thread
            NSData* copy = [dat copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(head, copy);
            });
        }else{
            NSLog(@"Not handled query result");
        }
        return;
    }
    
    //see head.ProtoType
    pfnPackageHandler block = [dictProto objectForKey:@(head.ProtoType)];
    if(block != nil){
        //parsing package
        /*
        NSData *bufferData = dat;
        GPBMessage *message = [[GPBMessage alloc]init];
        message =  [message initWithData:bufferData extensionRegistry:nil error:nil];
         */
        //go to main thread
        NSData* copy = [dat copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(head, copy);
        });
    }else{
        NSLog(@"Not handled: %d", head.ProtoType);
    }
    
}

/*
 int32_t PackageIndex;
 int32_t ProtoType;
 int8_t Res;
 int16_t Len;
 
 protobuffer - body
 
 pfnPackageHandler
 */
-(void)query:(int32_t) protoType andMessage:(GPBMessage*) msg andHandler: (pfnPackageHandler)handler{
    //pack package and then do
    //make a unique package index
    //NSLog(@"%d-%@ ", protoType, msg);
    packageIndex += 2; //atomic
    
    //package
    //
    NSData* data = [GameTcpApi encodingWithPacketIndex:packageIndex prototype:protoType response:0 message:msg];
    
    //write network
    [dictResponse setObject:handler forKey:@(packageIndex)];
    [self send:data];
}

-(void)sendPackage:(int32_t) protoType andMessage:(GPBMessage*) msg{
    NSData* data = [GameTcpApi encodingWithPacketIndex:0 prototype:protoType response:0 message:msg];
    [self send:data];
}

-(void) response:(int32_t) protoType andMessage:(GPBMessage*) msg packageIndex:(int32_t) pi{
    NSData* data = [GameTcpApi encodingWithPacketIndex:pi prototype:protoType response:1 message:msg];
    [self send:data];
}

-(void)addHandler:(pfnPackageHandler)handler withProtoType:(int32_t) protoType{
    [dictProto setObject:handler forKey:@(protoType)];
}

-(void) onData:(NSData*) d{
    while(true){
        
        int16_t dl = d.length;
        if(dl == 0)
            return;
        
        int16_t ll = lengthAll-length;
        if(ll >= dl){
            ll = (int16_t)d.length;
        }
        [protuData appendData:[d subdataWithRange:NSMakeRange(0, ll)]];
        length += ll;
        if(length < lengthAll) //package not complete;
            return;
        
        //data left for next package
        length = 0;//
        
        if(nil == header){
            //parseing header and then
            header = [[PackHeader alloc] initWithFullHeader: protuData];
            if(header == nil){
                //we are going to make a error, and then reset
                [self.parsingDelegate onError];
                [self reset];
                return;
                //continue;//or return
            }
            if(header.Len == 0){
                //we have a package that, call the xxx
                [self onPackage: header andBody:emptyData];
                //lengthAll = HeaderLength;
                [self reset];
            }else{
                lengthAll = header.Len;
                [protuData setLength:0];//we are going to make the data as a body now
            }
        }else{
            //lengthAll = HeaderLength;
            //here we'v got a package now, call xxx
            //header body
            [self onPackage:header andBody:protuData];
            [self reset];
        }
        if(ll < d.length)
            d = [d subdataWithRange:NSMakeRange(ll, d.length-ll)];
        else
            return;
    }
}


@end


@interface PackHeader(){
    int32_t PackageIndex;
    int32_t ProtoType;
    int8_t Res;
    int16_t Len;
}

@end

@implementation PackHeader
@synthesize PackageIndex;
@synthesize ProtoType;
@synthesize Res;
@synthesize Len;

-(id) initWithFullHeader:(NSData*) pkg{
    const char* data = [pkg bytes];
    if (data[0] != 'N' || data[1] != 'B'){
        return nil;
    }
    int16_t pf;
    [pkg getBytes: &pf range:NSMakeRange(6, sizeof(int16_t))];
    NTOHS(pf);
    if(pf != 2){
        //this is not a protobuffer
        return nil;
    }
    
    self = [super init];
    [pkg getBytes: &PackageIndex range:NSMakeRange(8, sizeof(int32_t))];
    NTOHL(PackageIndex);
    [pkg getBytes: &ProtoType range:NSMakeRange(12, sizeof(int32_t))];
    NTOHL(ProtoType);
    [pkg getBytes: &Len range:NSMakeRange(18, sizeof(int16_t))];
    NTOHS(Len);
    
    [pkg getBytes: &Res range:NSMakeRange(16, sizeof(int8_t))];
    
    return self;
}

@end


@implementation GameDelegate

- (void) onError{
    NSLog(@"On error");
}
@end

///////////////////////////
@interface testingforprotobuffer: NSObject

@end

@implementation testingforprotobuffer
+(void)allquery{
    {
        EchoBuf * req = [EchoBuf new];
        req.hello = @"echo";
        [[GameSocketManager instance] sendPackage:ProtoTypes_PtIdecho andMessage:req];
        
    }
    {
        //登录请求
        Login * req = [[Login alloc]init];
        req.id_p = @"qiongbi";
        req.token = @"qiongbi";
        [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
            
            ResponseStatus * res = GetMessage(ResponseStatus ,body);
            
            NSLog(@"Login: %@", res);
            
            return 0;
        }];
    }
    {
        //创建游戏房间
        DouNiuCreateRoom * req = [[DouNiuCreateRoom alloc]init];
        [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
            
            ResponseStatus * res = GetMessage(ResponseStatus ,body);
            
            NSLog(@"Login: %@", res);
            
            return 0;
        }];
    }
    
    {
        //进入游戏房间
        DouNiuEnterRoom * req = [[DouNiuEnterRoom alloc]init];
        req.roomId = @"roo id to login";
        [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
            
            DouNiuEnterRoomRes * res = GetMessage(DouNiuEnterRoomRes ,body);
            //res.status; 状态
            //res.hasRoom; 是否有room字段
            //res.room.roomId; 房间id
            //res.room.bankerId; 庄id
            //res.room.bankerLeftWager; 庄金币
            //res.room.gameStep; 游戏进度
            //res.room.gameStepTickLeft 游戏当前进度剩余时间
            NSLog(@"Login: %@", res);
            
            return 0;
        }];
    }
    {
        //下注请求
        DouNiuBetOne * req = [[DouNiuBetOne alloc]init];
        req.gameId = @"the game id when you receive a game event";
        req.roomId = @"roo id to login";
        req.bet = [DouNiuBet new];
        req.bet.betOn = BetOnTypes_Botone;//天 地 人
        req.bet.coin = 200; //多少金币
        [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
            
            ResponseStatus * res = GetMessage(ResponseStatus ,body);
            //res.status;
            NSLog(@"Login: %@", res);
            
            return 0;
        }];
    }
    
    {
        //庄家列表
        DouNiuBankerReq * req = [[DouNiuBankerReq alloc]init];
        req.roomId = @"roo id to login";
        req.opt = DouNiuBankerReq_DNBOperations_DnbogetBankerList; //获取banker列表
        req.opt = DouNiuBankerReq_DNBOperations_DnboapplyBanker; //申请当庄
        req.opt = DouNiuBankerReq_DNBOperations_DnboapplyUnBanker; //申请下庄
        
        [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
            
            DouNiuBankerRes * res = GetMessage(DouNiuBankerRes ,body);
            //res.status; 状态
            //res.bankersArray; 庄列表
            //DouNiuBanker* onebanker; 一个庄家
            //onebanker.id_p; 庄家id
            //onebanker.coin; 庄家钱币
            NSLog(@"Login: %@", res);
            
            return 0;
        }];
    }
    
    {
        //历史战绩
        DouNiuHistoryReq * req = [[DouNiuHistoryReq alloc]init];
        req.start=0; //起始记录
        req.count=10; //记录数目

        [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
            
            DouNiuHistoryRes * res = GetMessage(DouNiuHistoryRes ,body);
            /*
            res.status; //状态
            res.historyArray;// 所有历史记录
            DouNiuHistoryItem* history;// 这是其中一条历史
            history.bankerId;// 庄家
            history.roomId;// 房间
            history.userId;// 你的用户名
            history.time;// 时间
            history.handsArray;// 这次游戏的手牌记录 0，1，2，3
            DouNiuHistoryHand* hand;// 手牌
            hand.win;// 是否赢了庄家
            hand.niuN;// 牛N
            hand.rate;//赔率
            hand.coin// 下注金币
             */
            NSLog(@"Login: %@", res);
            
            return 0;
        }];
    }
}

+(void)allevents{
    //通用游戏事件
    [[GameSocketManager instance] addHandler:^int(PackHeader *header, NSData *body) {
        //DouNiuEventBet
        DouNiuEventBet * rt = GetMessage(DouNiuEventBet, body);
        /*
        rt.roomId;
        rt.gameId;
        rt.time;
        rt.dneb; //事件ID， DouNiuEventBet_DBEBTypes_Dbebtbegin = 0, DouNiuEventBet_DBEBTypes_Dbebtend = 1, DouNiuEventBet_DBEBTypes_Dbebtchanged = 2,
        rt.bankerId;
        rt.bankerLeftCoin
        rt.tickLeft; //当前状态持续时间秒
        rt.allBetsArray;//所有下注
        DouNiuBet* bet; //其中一注
        bet.betOn; //1, 2, 3
        bet.coin; //金币
         */
        NSLog(@"Login: %@", rt);
        return 0;
    } withProtoType:ProtoTypes_PtIddouNiuEventBet];
    
    //游戏结果事件
    [[GameSocketManager instance] addHandler:^int(PackHeader *header, NSData *body) {
        //DouNiuEventBet
        DouNiuEventGameResult * rt = GetMessage(DouNiuEventGameResult, body);
        
        //result.handArray
        
        //开始发牌
        /*
        rt.roomId;
        rt.gameId;
        rt.time;
        rt.winnerId; //最大牌序号
        rt.bankerWinCoin; //庄家赢了多少钱
        rt.selfWinCoin;//自己赢了多少钱
        rt.status;
        rt.reserve;
         
         rt.handArray;
         
         DouNiuGameHand* hand;
         hand.niuN; // 牛N
         hand.maxCard;// 最大牌
         hand.five;// 五花牛=5
         hand.rate;// 赔率
         hand.winBanker;// 是否赢了庄家
         hand.cardsArray; //牌
         
         GPBInt32Array cards;
         */
        NSLog(@"Login: %@", rt);
        return 0;
    } withProtoType:ProtoTypes_PtIddouNiuEventGameResult];
    
    //其他人使用此账户登录
    [[GameSocketManager instance] addHandler:^int(PackHeader *header, NSData *body) {
        //DouNiuEventBet
        LoginEvent * rt = GetMessage(LoginEvent, body);
        
        /*
         rt.ip; //ip地址
         rt.time; //时间
         */
        NSLog(@"Login: %@", rt);
        return 0;
    } withProtoType:ProtoTypes_PtIdloginEvent];

}
@end
