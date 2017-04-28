//
//  SocketManager.h
//  GCDAsyncSocket使用
//
//  Created by caokun on 16/7/1.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#define BufferHeaderStr   @"com.lewang.live.protocol."

@class socketHeader;

@protocol SocketManagerDelegate <NSObject>

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data;
- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port;
- (void)socketDidDisconnect:(GCDAsyncSocket *)socket;

@end

typedef void (^completionResult)(id result);

// socket 连接管理类
@interface SocketManager : NSObject

@property (weak, nonatomic) id<SocketManagerDelegate> delegate;

+ (SocketManager *)instance;    // 可以使用单例，也可以 alloc 一个新的临时用

- (void)connectWithIp:(NSString *)ip port:(UInt16)port;     // 连接服务器

//断开连接
- (void)disConnect;

- (void)send:(NSData *)data;

//socket状态
- (BOOL)status;


@end

@interface socketHeader : NSObject

@property(nonatomic, readonly) int32_t Len;

-(id) initWithFullSockHeader:(NSData*) headData;

@end

