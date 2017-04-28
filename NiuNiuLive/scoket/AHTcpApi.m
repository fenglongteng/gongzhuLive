//
//  AHTcpApi.m
//  NiuNiuLive
//
//  Created by anhui on 17/4/1.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHTcpApi.h"
#import "SocketManager.h"
#import <Protobuf/GPBMessage.h>
#import "Heartbeat.pbobjc.h"
#import "AHPersonInfoManager.h"


@interface AHTcpApi ()<SocketManagerDelegate>

@property (nonatomic,strong)NSTimer *heartTimer;    //心跳定时器
@property (nonatomic,assign)BOOL shouldHeart;       //是否需要心跳
@property (nonatomic,assign)BOOL loginStatus;      //登录状态
@property (strong, nonatomic) dispatch_queue_t apiQueue;
@property (nonatomic,strong)NSMutableDictionary *callBackBlock;//保存请求回调
@property (nonatomic,strong)NSMutableDictionary *giftHanderDict;//保存推送的消息回调 如礼物 消息 红包等

@property (nonatomic,copy) void (^successBlock)(int status);//连接成功的回调

@property (nonatomic,copy) void (^failBlock)(NSError *error);//连接失败的回调

@end

@implementation AHTcpApi

static AHTcpApi *instance = nil;

+(AHTcpApi *)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[AHTcpApi alloc]init];
    });
    return instance;
}

- (id)init{
    
    self = [super init];
    if (self) {
        //创建socket
        [SocketManager instance].delegate = self;
        self.callBackBlock = [NSMutableDictionary dictionary];
        self.giftHanderDict = [NSMutableDictionary dictionaryWithCapacity:3];
        self.shouldHeart = YES;//默认开启心跳
    }
    return self;
}

// 关闭心跳，退出时关闭，关闭后不会自动开启
- (void)closeHeartBeat{
    self.shouldHeart = NO;
}

- (void)connectIp:(NSString *)ip port:(UInt16)port successBlock:(void(^)(int status))success failBlock:(void (^)(NSError *error))failBlock{
    _successBlock = success;
    _failBlock = failBlock;
    [[SocketManager instance]connectWithIp:ip port:port];
}

//发送心跳包
-(void)sendHeart{
    
    HeartbeatRequest *heartBeat = [[HeartbeatRequest alloc]init];
    heartBeat.ping = @"ping";
    [self requsetMessage:heartBeat classSite:HeartbeatClssName completion:^(id response, NSString *error) {
        LOG(@"心跳成功");
    }];
}

-(void)dealloc{
}
//发送请求
- (void)requsetMessage:(id)messageModel classSite:(NSString *)site completion:(AHTcpCompletionBlock)block{
    NSString *blockKey = NSStringFromClass([messageModel class]);
    NSMutableData *mData;
    if ([messageModel isKindOfClass:[GPBMessage class]]) {
        mData  = [self bufferEncodingData:messageModel classSite:site];
    }
    if (self.callBackBlock != nil) {
        if (block) {
            [self.callBackBlock setObject:block forKey:blockKey];
        }
    }
    [[SocketManager instance]send:mData];
}

// 发送消息编码
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

// 收到消息的解码
- (id)deserialize:(NSData *)data{
    //获得消息小于头的4个字节时 返回为空
    if (data.length <= 4) {
        return nil;
    }
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

//收到推送消息的回调
-(void)query:(NSString *)giftStr andHandler: (SocketGiftHandler)handler{
    
    [self.giftHanderDict setObject:handler forKey:giftStr];
    
}

#pragma mark SocketManagerDelegate

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket{
    //socke断开处理
}

//socket 状态改变
- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port{

    //连接成功 进行回调
    if (_successBlock) {
        _successBlock(0);
    }
    //连接成功后处理 通知进行重新登录
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifitySocketDisConnect object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:SocketDidConnect object:nil];
}

//重新登录
-(void)LogBackIn{
    //连接成功后如果之前是登录状态那么重新登录
    AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
    if (infoModel.isLoginStatus) {
        UsersLoginRequest *userLog = [[UsersLoginRequest alloc]init];
        userLog.field = 0;
        userLog.channelUuid = @"cd15fe10-15d8-11e7-a585-00155d010713";
        userLog.telephone = @"9";
        userLog.telephoneVerifyCode = @"1345";
        [[AHTcpApi shareInstance] requsetMessage:userLog classSite:@"Users" completion:^(id response, NSString *error) {
            //每次根据response进行类模型 进行操作并执行其他
            UsersLoginResponse *logrepsonse = (UsersLoginResponse *)response;
            if (logrepsonse.result == UsersLoginResponse_UserLoginResult_UserLoginResultSucceeded) {
                [[AHPersonInfoManager manager] setWithJson:logrepsonse];
                AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
                infoModel.isLoginStatus = YES;
                [[AHPersonInfoManager manager]setInfoModel:infoModel];
                
            }else{
                static NSInteger logBackInOfTimeInterval = 0.1;
                if (logBackInOfTimeInterval < 1) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(logBackInOfTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        logBackInOfTimeInterval *= 2;
                        [self LogBackIn];
                    });
                }else{
                    logBackInOfTimeInterval = 0;
                }
            }
        }];
    }
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data{
    //获得消息
    id receiveMessage = [self deserialize:data];
    if (receiveMessage == nil) {
        return;
    }
    NSString *messName = NSStringFromClass([receiveMessage  class]);
    //进行心跳响应
    if ([messName isEqualToString:@"HeartbeatRequest"]) {
        [self sendHeart];
    }
    //需要经key进行转化
    NSString *blockKey = [self responseConversionRequset:messName];
    if (blockKey!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            id obj = [self.callBackBlock objectForKey:blockKey];
            [self.callBackBlock removeObjectForKey:blockKey];
            AHTcpCompletionBlock completion = nil;
            if (obj != nil) {
                completion = (AHTcpCompletionBlock)obj;
                completion(receiveMessage,nil);
            }
            if (completion == nil) {
                LOG(@"%@ ---block为空，没有找到block",messName);
            }
        });
    }
    else{
        //处理获取礼物 消息 红包的推送消息的回调
        id handleBlock = [self.giftHanderDict objectForKey:messName];
        if (handleBlock != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SocketGiftHandler giftHandleBlock = (SocketGiftHandler)handleBlock;
                giftHandleBlock(receiveMessage,data);
            });
        }
    }
}

- (NSString *)responseConversionRequset:(NSString *)responseString{
    
    NSString *requsetString = @"";
    //设定每一个的请求与响应模型的对应关系
    NSDictionary *correspondingDic = @{@"UsersGetLikeMeUserInfoResponse":@"UsersGetLikeMeUserInfoRequest",
                                       @"UsersGetMeLikeUserInfoResponse":@"UsersGetMeLikeUserInfoRequest",
                                       @"UsersRemoveAvatarResponse":@"UsersRemoveAvatarRequest",
                                       @"HeartbeatResponse":@"HeartbeatRequest",
                                       @"UsersLoginResponse":@"UsersLoginRequest",
                                       @"RoomsGetRoomsResponse":@"RoomsGetRoomsRequest",
                                       @"RoomsGetNearestRoomResponse":@"RoomsGetNearestRoomRequest",
                                       @"RoomsGetRoomInfoResponse":@"RoomsGetRoomInfoRequest",
                                       @"RoomsCreateRoomResponse":@"RoomsCreateRoomRequest",
                                       @"RoomsGetLikeRoomsResponse":@"RoomsGetLikeRoomsRequest",
                                       @"RoomsGetHotRoomsResponse":@"RoomsGetHotRoomsRequest",
                                       @"RoomsGetGamingRoomsResponse":@"RoomsGetGamingRoomsRequest",
                                       @"RoomsGetRecommendRoomsResponse":@"RoomsGetRecommendRoomsRequest",
                                       @"GiftChartsForWeeksResponse":@"GiftChartsForWeeksRequest",
                                       @"GiftChatsForMonthResponse":@"GiftChatsForMonthRequest",
                                       @"GiftChatsResponse":@"GiftChatsRequest",
                                       @"OutcomeChatsForWeekResponse":@"OutcomeChatsForWeekRequest",
                                       @"OutcomeChatsForMonthResponse":@"OutcomeChatsForMonthRequest",
                                       @"OutcomeChatsResponse":@"OutcomeChatsRequest",
                                       @"LikeChatsResponse":@"LikeChatsRequest",
                                       @"RoomsJoinRoomResponse":@"RoomsJoinRoomRequest",
                                       @"RoomsLeaveRoomResponse":@"RoomsLeaveRoomRequest",
                                       @"RoomsAlterRoomPasswordResponse":@"RoomsAlterRoomPasswordRequest",
                                       @"UsersGetInfoResponse":@"UsersGetInfoRequest",
                                       @"UsersAlterInfoResponse":@"UsersAlterInfoRequest",
                                       @"UsersSignedInResponse":@"UsersSignedInRequest",
                                       @"UsersLogoutResponse":@"UsersLogoutRequest",
                                       @"UsersFindOtherResponse":@"UsersFindOtherRequest",
                                       @"UsersFindNearbyResponse":@"UsersFindNearbyRequest",
                                       @"SendMessageResponse":@"SendMessageRequest",
                                       @"SendInviteMessageResponse":@"SendInviteMessageRequest",
                                       @"TasksResponse":@"TasksRequest",
                                       @"GetGiftListResponse":@"GetGiftListRequest",
                                       @"SendGiftResponse":@"SendGiftRequest",
                                       @"GrabRedPackagesResponse":@"GrabRedPackagesRequest",
                                       @"UsersAccusationOtherResponse":@"UsersAccusationOtherRequest",
                                       @"UsersGetRecommendUserResponse":@"UsersGetRecommendUserRequest",
                                       @"UsersChangeLikeStateResponse":@"UsersChangeLikeStateRequest",
                                       @"UsersLikeUserResponse":@"UsersLikeUserRequest",
                                       @"UsersUnlikeUserResponse":@"UsersUnlikeUserRequest",
                                       @"UsersGetSignedInInfoResponse":@"UsersGetSignedInInfoRequest",
                                       @"UsersGetChargeCorrespondingTableResponse":@"UsersGetChargeCorrespondingTableRequest",
                                       @"UsersVerifyIsRegisteredUserResponse":@"UsersVerifyIsRegisteredUserRequest",
                                       @"UsersValidateTokenResponse":@"UsersValidateTokenRequest",
                                       @"UsersOtherLoginRequest":@"UsersOtherLoginResponse",
                                       @"UsersAddRecommendUserResponse":@"UsersAddRecommendUserRequest",
                                       @"UsersRemoveRecommendUserResponse":@"UsersRemoveRecommendUserRequest",
                                       @"TasksGetTaskListResponse":@"TasksGetTaskListRequest",
                                       @"HandshakeResponse":@"HandshakeRequest",
                                       @"ExchangeKeyResponse":@"ExchangeKeyRequest",
                                       @"AccountsChargeResponse":@"AccountsChargeRequest",
                                       @"AccountsTransferResponse":@"AccountsTransferRequest",
                                       @"AccountsLogResponse":@"AccountsLogRequest",
                                       @"SystemGetADListResponse":@"SystemGetADListRequest",
                                       @"GetGrabRedPackagesResultResponse":@"GetGrabRedPackagesResultRequest",
                                       @"AreaControlAuthorizationResponse":@"AreaControlAuthorizationRequest",
                                       @"AreaControlBannedResponse":@"AreaControlBannedRequest",
                                       @"AreaControlKickOutResponse":@"AreaControlKickOutRequest"};
    
    requsetString = [correspondingDic objectForKey:responseString];
    
    return requsetString;
}

@end
