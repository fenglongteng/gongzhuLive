//
//  AHLiveSocketManager.m
//  NiuNiuLive
//
//  Created by anhui on 17/4/8.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLiveSocketManager.h"

typedef void(^requestSuccessBlock)(id response);//请求成功回调

@interface AHLiveSocketManager ()<GCDAsyncSocketDelegate>
{
    liveSocketHeader* header;//if this is nil we are receiving the header, other wise the body.
    NSMutableData * protuData;
    int16_t length;
    int16_t lengthAll;
    NSData* emptyData;
    NSMutableDictionary* dictProto;//
    NSMutableDictionary* dictResponse;
    int32_t packageIndex;
}
@property (nonatomic,copy)NSString  *ip;
@property (nonatomic,assign)UInt16  port;
@property (strong, nonatomic) dispatch_queue_t socketQueue;
@property (nonatomic,strong)GCDAsyncSocket *socket;
@property (nonatomic,strong)NSMutableDictionary *liveBlockDic;

@property (nonatomic,copy) void (^successBlock)(int status);//连接成功的回调

@end

static AHLiveSocketManager *instance = nil;
static NSTimeInterval TimeOut = -1;       // 超时时间, 超时会关闭 socket

#define HeaderLeg 4

@implementation AHLiveSocketManager

+ (AHLiveSocketManager *)instance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AHLiveSocketManager alloc] init];
    });
    return instance;
}

-(instancetype)init{

    if (self = [super init]) {
        header = nil;
        protuData = [[NSMutableData alloc] init];//initWithBytes:"" length:0];
        emptyData = [[NSData alloc] init];
        dictResponse = [NSMutableDictionary dictionaryWithCapacity:2];
        self.liveBlockDic = [NSMutableDictionary dictionaryWithCapacity:2];
        length = 0;
        lengthAll = HeaderLeg;
    }
    return self;
}

//连接socket
- (void)connectWithIp:(NSString *)ip port:(UInt16)port connectSuccess:(void(^)(int status))block{
    self.ip = ip;
    self.port = port;
    //设置socket
    [self resetSocket];
    NSError *error = nil;
    [self.socket connectToHost:self.ip onPort:self.port withTimeout:15 error:&error];   // 填写 地址，端口进行连接
    if (error != nil) {
        LOG(@"连接错误：%@", error);
    }
    _successBlock = block;
}

- (void)qureyHandle:(liveVideoAudioPushBlock)handleBlock messageStr:(NSString *)message{

    [self.liveBlockDic setObject:handleBlock forKey:message];
}

- (void)sendMessage:(id)bufferMessage classSite:(NSString *)site block:(void(^)(id response))requestBlock{

    NSString *blockKey = NSStringFromClass([bufferMessage class]);
    if (requestBlock) {
        [dictResponse setObject:requestBlock forKey:blockKey];
    }
    NSMutableData *mData;
    if ([bufferMessage isKindOfClass:[GPBMessage class]]) {
        mData  = [self bufferEncodingData:bufferMessage classSite:site];
    }
    [[AHLiveSocketManager instance]send:mData];
}

- (void)resetSocket {
    
    [self disConnect];
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
    self.socket.IPv6Enabled = true;
    self.socket.IPv4Enabled = true;
    self.socket.IPv4PreferredOverIPv6 = false;     // 4 优先
}

- (dispatch_queue_t)socketQueue {
    if (_socketQueue == nil) {
        _socketQueue = dispatch_queue_create("com.LiveSendSocket", DISPATCH_QUEUE_SERIAL);
    }
    return _socketQueue;
}
//断开连接
- (void)disConnect {
    [self.socket disconnect];
    self.socket = nil;
    self.socketQueue = nil;
}

//判断连接状态
- (BOOL)status {
    
    if (self.socket != nil && self.socket.isConnected) {
        return true;
    }
    return false;
}

- (void)send:(NSData *)data{
    
    if (self.socket == nil || self.socket.isDisconnected) {
        
        [self connectWithIp:self.ip port:self.port connectSuccess:nil]; 
    }
    [self.socket writeData:data withTimeout:TimeOut tag:110];
}

//protolBuffer 头的拼接
- (NSMutableData *)bufferEncodingData:(GPBMessage *)message classSite:(NSString *)site{
    
    NSMutableData *mData = [NSMutableData data];
    // 编码 将buffer编码成data类型
    NSData *data = [message data];
    NSString *className = NSStringFromClass(message.class);
    //类长度
    NSString *str =  [NSString stringWithFormat:@"%@%@$%@",LiveBufferHeaderStr,site,className];
    //protocolbuffer 长度
    NSInteger dataLength = [data length];
    //总长转化
    NSInteger allLength = 8 + str.length + dataLength;
    uint32_t allLeg = 0xffff & allLength;
    HTONL(allLeg);
    [mData appendBytes:&allLeg length:sizeof(allLeg)];
    //类长转化
    uint32_t classlength = 0xffff &str.length;
    HTONL(classlength);
    [mData appendBytes:&classlength length:sizeof(classlength)];
    
    NSString * dataStr = [NSString stringWithFormat:@"%@",str];
    NSData *classNameData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [mData appendData:classNameData];
    [mData appendData:data];
    return mData;
}

// 收到消息的解码

- (id)deserialize:(NSData *)data{
    
    NSData *classData = [data subdataWithRange:NSMakeRange(0, 4)];
    uint32_t classLength;
    [classData getBytes:&classLength length:sizeof(classLength)];
    NTOHL(classLength);
    NSRange bufferRange = NSMakeRange(4+classLength, data.length - classLength-4);
    NSData *bufferData = [data subdataWithRange:bufferRange];
    NSString *str  = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(4, classLength)] encoding:NSUTF8StringEncoding];
    NSArray <NSString *>*Arr = [str componentsSeparatedByString:@"$"];
    NSString *className = Arr.lastObject;
    Class class = NSClassFromString(className);
    id message =  [class parseFromData:bufferData error:nil];
    return message;
}


#pragma mark -GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    //连接成功 返回0
    if (_successBlock) {
         _successBlock(0);
    }
    [self.socket readDataWithTimeout:TimeOut tag:110];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    //连接失败 断开
    self.socket = nil;
    self.socketQueue = nil;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //获得data数据
    [self onData:data];
    
    [self.socket readDataWithTimeout:TimeOut tag:110];
}

-(void) onData:(NSData*) d{
    
    while(true){
        int32_t dl = (int32_t)d.length;
        if(dl == 0)
            return;
        int32_t ll = lengthAll-length;
        if(ll >= dl){
            ll = (int32_t)d.length;
        }
        [protuData appendData:[d subdataWithRange:NSMakeRange(0, ll)]];
        length += ll;
        if(length < lengthAll) //package not complete;
            return;
        length = 0;
        if(nil == header){
            //parseing header and then
            header = [[liveSocketHeader alloc]initWithFullSockHeader:protuData];
            if(header == nil){
                //we are going to make a error, and then reset
                [self reset];
                return;
            }
            if(header.Len == 0){
                [self onPackage: header andBody:emptyData];
                [self reset];
            }else{
                lengthAll = header.Len-4;
                [protuData setLength:0];
            }
        }else{
            [self onPackage:header andBody:protuData];
            [self reset];
        }
        if(ll < d.length)
            d = [d subdataWithRange:NSMakeRange(ll, d.length-ll)];
        else
            return;
    }
}

-(void) reset{
    
    header = nil;
    //data = [[NSMutableData alloc] init];//initWithBytes:"" length:0];
    length = 0;
    lengthAll = HeaderLeg;
    [protuData setLength:0];
}

-(void) onPackage:(liveSocketHeader*) head andBody:(NSData*) dat{
    //处理解析
    id message = [self deserialize:dat];
    NSString *messName = NSStringFromClass([message class]);
    NSString *responseKey = [self responseConversionRequset:messName];
    if (responseKey!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            id obj = [dictResponse objectForKey:responseKey];
            [dictResponse removeObjectForKey:responseKey];
            requestSuccessBlock completion = nil;
            if (obj != nil) {
                completion = (requestSuccessBlock)obj;
                completion(message);
            }
            if (completion == nil) {
                NSLog(@"%@ ---block为空，没有找到block",messName);
            }
        });
       }
    
    id handleBlock = [self.liveBlockDic objectForKey:messName];
    //收到直播拉流数据的回调
    if (handleBlock != nil) {
        liveVideoAudioPushBlock liveHandle = (liveVideoAudioPushBlock)handleBlock;
        liveHandle(message);
    }
}

- (NSString *)responseConversionRequset:(NSString *)responseString{
    
    NSString *requsetString = @"";
    //设定每一个的请求与响应模型的对应关系
    NSDictionary *correspondingDic = @{@"LiveUsersLoginResponse":@"LiveUsersLoginRequest",
                                       @"LiveUsersLogoutResponse":@"LiveUsersLogoutRequest",
                                       @"LiveUsersOtherLoginResponse":@"LiveUsersOtherLoginRequest"
                                       };
    
    requsetString = [correspondingDic objectForKey:responseString];
    
    return requsetString;
}

@end

@interface liveSocketHeader()

@end

@implementation liveSocketHeader

-(id) initWithFullSockHeader:(NSData *)headData{
    
    self = [super init];
    if (self) {
        uint32_t allLength;
        [headData getBytes:&(allLength) length:sizeof(allLength)];
        NTOHL(allLength);
        _Len = allLength;
    }
    return self;
}


@end
