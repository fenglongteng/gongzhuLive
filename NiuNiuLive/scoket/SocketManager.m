//
//  SocketManager.m
//  GCDAsyncSocket使用
//
//  Created by caokun on 16/7/1.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import "SocketManager.h"
#import <Protobuf/GPBMessage.h>

@interface SocketManager () <GCDAsyncSocketDelegate>
{
    socketHeader* header;//if this is nil we are receiving the header, other wise the body.
    NSMutableData * protuData;
    int16_t length;
    int16_t lengthAll;
    NSData* emptyData;
    NSMutableDictionary* dictProto;//
    NSMutableDictionary* dictResponse;
    int32_t packageIndex;
}

@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) dispatch_queue_t socketQueue;         // 发数据的串行队列
@property (strong, nonatomic) dispatch_queue_t receiveQueue;        // 收数据处理的串行队列
@property (strong, nonatomic) NSString *ip;
@property (assign, nonatomic) UInt16 port;
@property (assign, nonatomic) BOOL isConnecting;

@property (nonatomic,strong)completionResult completionResult;

@end

#define HeaderLeg 4

@implementation SocketManager

static SocketManager *instance = nil;
static NSTimeInterval TimeOut = -1;       // 超时时间, 超时会关闭 socket

+ (SocketManager *)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SocketManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.isConnecting = false;
//        [self resetSocket];
        header = nil;
        protuData = [[NSMutableData alloc] init];//initWithBytes:"" length:0];
        emptyData = [[NSData alloc] init];
        length = 0;
        lengthAll = HeaderLeg;
    }
    return self;
}

- (dispatch_queue_t)socketQueue {
    if (_socketQueue == nil) {
        _socketQueue = dispatch_queue_create("com.sendSocket", DISPATCH_QUEUE_SERIAL);
        
    }
    return _socketQueue;
}

- (dispatch_queue_t)receiveQueue {
    if (_receiveQueue == nil) {
        _receiveQueue = dispatch_queue_create("com.receiveSocket", DISPATCH_QUEUE_SERIAL);
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
        NSLog(@"连接错误：%@", error);
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
        [self.socket writeData:data withTimeout:TimeOut tag:100];
}

- (NSMutableData *)bufferEncodingData:(GPBMessage *)message classSite:(NSString *)site{
    
    NSMutableData *mData = [NSMutableData data];
    // 编码 将buffer编码成data类型
    NSData *data = [message data];
    
    NSString *className = NSStringFromClass(message.class);
    //类长度
    NSString *str =  [NSString stringWithFormat:@"%@%@$%@",BufferHeaderStr,site,className];
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

//判断连接状态
- (BOOL)status {
    
    if (self.socket != nil && self.socket.isConnected) {
        return true;
    }
    return false;
}

// 代理方法 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(socket:didConnect:port:)]) {
        [self.delegate socket:sock didConnect:host port:port];
    }
    if (_isConnecting == true) {
        _isConnecting = false;
    }
    [self.socket readDataWithTimeout:TimeOut tag:100];// 每次都要设置接收数据的时间, tag
}

//连接失败 或连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(socketDidDisconnect:)]) {
            [self.delegate socketDidDisconnect:sock];
        }
        self.socket = nil;
        self.socketQueue = nil;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    [self onData:data];
    [self.socket readDataWithTimeout:TimeOut tag:100];// 每次都要设置接收数据的时间, tag
}

//解析获取到的Data

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
        length = 0;
        if(nil == header){
            //parseing header and then
            header = [[socketHeader alloc]initWithFullSockHeader:protuData];
            if(header == nil){
                //we are going to make a error, and then reset
//                [self.parsingDelegate onError];
                [self reset];
                return;
            }
            if(header.Len == 0){
                //we have a package that, call the xxx
                [self onPackage: header andBody:emptyData];
                [self reset];
            }else{
                lengthAll = header.Len-4;
                [protuData setLength:0];//we are going to make the data as a body now
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
    length = 0;
    lengthAll = HeaderLeg;
    [protuData setLength:0];
}

-(void) onPackage:(socketHeader*) head andBody:(NSData*) dat{
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(socket:didReadData:)]) {
            [self.delegate socket:self.socket didReadData:dat];
        }
}

@end


@interface socketHeader()

@end

@implementation socketHeader

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



