//
//  AHLiveSocketManager.h
//  NiuNiuLive
//
//  Created by anhui on 17/4/8.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#define LiveBufferHeaderStr   @"com.hewei.live.protocol."

typedef void(^liveVideoAudioPushBlock)(id message);

@interface AHLiveSocketManager : NSObject

+ (AHLiveSocketManager *)instance;    // 可以使用单例，也可以 alloc 一个新的临时用

- (void)connectWithIp:(NSString *)ip port:(UInt16)port connectSuccess:(void(^)(int status))block;     // 连接服务器

//收到消息发送回调数据
- (void)sendMessage:(id)bufferMessage classSite:(NSString *)site block:(void(^)(id response))requestBlock;

//断开连接
- (void)disConnect;

//socket状态
- (BOOL)status;

//直播拉流的数据 视频 音频
- (void)qureyHandle:(liveVideoAudioPushBlock)handleBlock messageStr:(NSString *)message;

@end

@interface liveSocketHeader : NSObject

@property(nonatomic, readonly) int32_t Len;

-(id) initWithFullSockHeader:(NSData*) headData;

@end
