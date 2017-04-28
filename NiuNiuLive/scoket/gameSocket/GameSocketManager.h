//
//  GameSocketManager.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/7.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"


#define GetMessage(className, dat) [className parseFromData:dat error:nil]
//[[className alloc]init] initWithData:dat extensionRegistry:nil error:nil]
//数据处理相关
@interface PackHeader : NSObject

@property(nonatomic, readonly) int32_t PackageIndex;
@property(nonatomic, readonly) int32_t ProtoType;
@property(nonatomic, readonly) int8_t  Res;
@property(nonatomic, readonly) int16_t Len;


-(id) initWithFullHeader:(NSData*) pkg;

@end

@protocol GameSocketManagerDelegate <NSObject>

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data;
- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port;
- (void)socketDidDisconnect:(GCDAsyncSocket *)socket;

@end

@protocol ParsingPackageDelegate <NSObject>
//- (void) onPackage:(PackHeader*) header andBody:(NSData*) body;
- (void) onError;
@end

typedef void (^completionResult)(id result);

typedef int (^pfnPackageHandler)(PackHeader* header, NSData * body);

//游戏连接管理
@interface GameSocketManager : NSObject

@property(nonatomic,weak)id<GameSocketManagerDelegate> delegate;

+ (GameSocketManager *)instance;    // 可以使用单例，也可以 alloc 一个新的临时用

- (void)connectWithIp:(NSString *)ip port:(UInt16)port;     // 连接服务器

//收到消息发送回调数据
//- (void)sendMessage:(id)gpbmessage classSite:(NSString *)site;

//断开连接
- (void)disConnect;

- (void)send:(NSData *)data;
//socket状态
- (BOOL)status;

-(void)addHandler:(pfnPackageHandler)handler withProtoType:(int32_t) protoType;

-(void)query:(int32_t) protoType andMessage:(GPBMessage*) msg andHandler: (pfnPackageHandler)handler;
//发送心跳包
- (void)sendHeartPacket;
//开启心跳
- (void)startHeartBeat;
//关闭心跳
- (void)closeHeartBeat;

@end


@interface GameDelegate : NSObject<ParsingPackageDelegate>

@end
