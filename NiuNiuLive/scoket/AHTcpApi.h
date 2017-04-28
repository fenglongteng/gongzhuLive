//
//  AHTcpApi.h
//  NiuNiuLive
//
//  Created by anhui on 17/4/1.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UsersClassName         @"Users"       //用户相关的类，包含登录 用户信息 关注等类
#define AccoutsClassName       @"Accounts"     //账户信息  充值等
#define ExchangeClassName      @"ExchangeKey"   //加密请求
#define GiftsClassName         @"Gifts"         //礼物需要的类型
#define HandshakeClassName     @"Handshake"      //握手请求响应
#define HeartbeatClssName      @"Heartbeat"      //心跳响应
#define MessageClassName       @"Messages"         //消息类型
#define RoomClassName          @"Rooms"        //房间的创建及列表类
#define TasksClssName          @"Tasks"       //任务类
#define ChatsClassName         @"Chats"        //榜单
#define SystemsClassName       @"LiveSystem"      //广告+服务器ip
#define AreaControlClassName   @"AreaControl"

typedef void(^AHTcpCompletionBlock)(id response,NSString *error);

typedef void (^SocketGiftHandler)(id message, NSData * bodyData);

@interface AHTcpApi : NSObject

//单例
+(AHTcpApi *)shareInstance;

// 发送单个心跳包
- (void)sendHeart;

/*
 **  每次发送消息的时候 传模型GPBMessage类型的模型
 和类所在的那个.h文件。如 FindUser 类查找人 在Users.pbobjc.h中，传值是site为Users
 */

- (void)requsetMessage:(id)messageModel classSite:(NSString *)site completion:(AHTcpCompletionBlock)block;

-(void)query:(NSString *)giftStr andHandler: (SocketGiftHandler)handler;

//连接socket
- (void)connectIp:(NSString *)ip port:(UInt16)port successBlock:(void(^)(int status))success failBlock:(void (^)(NSError *error))failBlock;

@end
