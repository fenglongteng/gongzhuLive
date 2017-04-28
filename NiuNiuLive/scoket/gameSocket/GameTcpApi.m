//
//  GameTcpApi.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/7.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "GameTcpApi.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"

@interface GameTcpApi()<GameSocketManagerDelegate>{
    NSNumber * _blockKey;
}

@property (nonatomic,assign)BOOL loginStatus;      //登录状态
@property (strong, nonatomic) dispatch_queue_t apiQueue;
@property (nonatomic,strong)NSMutableDictionary *callBackBlock;//保存请求回调

@end
static GameTcpApi * gameTcp = nil;
@implementation GameTcpApi

+(GameTcpApi *)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        gameTcp = [[GameTcpApi alloc]init];
    });
    return gameTcp;
}

- (id)init{
    
    self = [super init];
    if (self) {
        //创建socket
        [GameSocketManager instance].delegate = self;
        _blockKey = 0;
        self.callBackBlock = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)requsetMessage:(id)messageModel piTag:(NSInteger)piTag requestType:(NSString *)type completion:(GameTcpCompletionBlock)block{
    
    NSMutableData *mData;
    if ([messageModel isKindOfClass:[GPBMessage class]]) {
        mData  = [self bufferEncodingData:messageModel requestType:type];
    }
    if (self.callBackBlock != nil) {
        [self.callBackBlock setObject:block forKey:@(piTag)];
        
    }
    [[GameSocketManager instance] send:mData];
    
}

// 发送消息编码
//int32_t PackageIndex;
//int32_t ProtoType;
//int8_t Res;
// GPBMessage  message;

+ (NSData *)encodingWithPacketIndex:(int32_t)pi prototype:(int32_t)pt response:(int8_t)res message:(GPBMessage *)message{
    NSMutableData *mData = [NSMutableData data];
    // 编码 将buffer编码成data类型
    NSData *data = [message data];
    //protocolbuffer 长度
    //NSInteger dataLength = [data length];
    //0x1fff
    
    //总长转化
    const char bytes[] = "\x4e\x42";
    //size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:2];
    
    [mData appendData:ByteHeader];
    NSInteger ver = 0;
    uint16_t verLeng = 0xff &ver;
    HTONS(verLeng);
    [mData appendBytes:&verLeng length:sizeof(verLeng)];
    NSInteger Ec = 0;
    uint16_t EcLeg = 0xff &Ec;
    HTONS(EcLeg);
    [mData appendBytes:&EcLeg length:sizeof(EcLeg)];
    int pf = 2;//PackageTypes_PtProtoBuffer
    uint16_t pfLeg = 0xff & pf;
    HTONS(pfLeg);
    [mData appendBytes:&pfLeg length:sizeof(pfLeg)];

    uint32_t piLeg = 0xffff &pi;
    HTONL(piLeg);
    [mData appendBytes:&piLeg length:sizeof(piLeg)];
    
    HTONL(pt);
    [mData appendBytes:&pt length:sizeof(pt)];
    
    [mData appendBytes:&res length:sizeof(res)];
    
    [mData appendBytes:&res length:sizeof(res)];
    
    int len = (int)data.length;
    uint16_t lenData = 0xffff & len;
    HTONS(lenData);
    
    [mData appendBytes:&lenData length:sizeof(lenData)];
    
    [mData appendData:data];
    
    return mData;

}

- (NSMutableData *)bufferEncodingData:(GPBMessage *)message requestType:(NSString *)type{
    
    NSMutableData *mData = [NSMutableData data];
    // 编码 将buffer编码成data类型
    NSData *data = [message data];
    //protocolbuffer 长度
//    NSInteger dataLength = [data length];
    //总长转化
    const char bytes[] = "\x4e\x42";
    size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    
    [mData appendData:ByteHeader];
    NSInteger ver = 0;
    uint16_t verLeng = 0xff &ver;
    HTONS(verLeng);
    [mData appendBytes:&verLeng length:sizeof(verLeng)];
    NSInteger Ec = 0;
    uint16_t EcLeg = 0xff &Ec;
    HTONS(EcLeg);
    [mData appendBytes:&EcLeg length:sizeof(EcLeg)];
    int pf = 2;//PackageTypes_PtProtoBuffer
    uint16_t pfLeg = 0xff & pf;
    HTONS(pfLeg);
    [mData appendBytes:&pfLeg length:sizeof(pfLeg)];
    int pi = 2;
    uint32_t piLeg = 0xffff &pi;
    HTONL(piLeg);
    [mData appendBytes:&piLeg length:sizeof(piLeg)];
    
    const char pfpiByte[] = "\x00\x00\x10\x01";
    [mData appendBytes:pfpiByte length:(sizeof(pfpiByte)-1)];
    
    const char resLegbyte[] = "\x00";
    [mData appendBytes:resLegbyte length:(sizeof(resLegbyte)-1)];
    
    const char pfp2Legbyte[] = "\x02";
    [mData appendBytes:pfp2Legbyte length:(sizeof(pfp2Legbyte)-1)];
    
    int len = (int)data.length;
    uint16_t lenData = 0xff & len;
    HTONS(lenData);
    
    [mData appendBytes:&lenData length:sizeof(lenData)];
    
    [mData appendData:data];
    
    return mData;
}


// 收到消息的解码
- (id)deserialize:(NSData *)data{
    //取出data头
    NSData *bufferData = data;
    ResponseStatus *message = [[ResponseStatus alloc]init];
    message =  [message initWithData:bufferData extensionRegistry:nil error:nil];
    return message;
}

#pragma mark GameSocketManagerDelegate

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket{
    //连接断开后处理
}

//socket 状态改变
- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port{
    //连接成功
    LOG(@"连接成功");
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data{
    //获得消息
    id receiveMessage = [self deserialize:data];
    //需要经key进行转化
    if (data.length == 20 && [self isHeardData:data]) {
       _blockKey = @([self getPiTag:data]);
    }else{
        if ([_blockKey integerValue] != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                id obj = [self.callBackBlock objectForKey:_blockKey];
                [self.callBackBlock removeObjectForKey:_blockKey];
                AHTcpCompletionBlock completion = nil;
                if (obj != nil) {
                    completion = (AHTcpCompletionBlock)obj;
                    completion(receiveMessage,nil);
                }
                if (completion == nil) {
                    NSLog(@"block为空，没有找到block");
                }
            });
         }
    }
    
}

- (uint32_t)getPiTag:(NSData *)data{
    //取出data头
    NSData *piLegData = [data subdataWithRange:NSMakeRange(8, 4)];
    uint32_t pitagLength;
    [piLegData getBytes:&(pitagLength) length:sizeof(pitagLength)];
    
    NTOHL(pitagLength);
    
    return pitagLength;
}

- (BOOL)isHeardData:(NSData *)headerData{
    if (headerData.length == 20) {
        NSData * headData = [headerData subdataWithRange:NSMakeRange(0, 2)];
        NSString * headStr = [[NSString alloc]initWithData:headData encoding:NSUTF8StringEncoding];
        if ([headStr isEqualToString:@"NB"]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end







