//
//  AHPersonInfoModel.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/6.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.pbobjc.h"

@interface AHPersonInfoModel : NSObject
/** 用户id */
@property(nonatomic, copy) NSString *userId;

//用户名
@property(nonatomic, copy) NSString *nickName;

/** PC通道用户名 */
@property(nonatomic, copy) NSString *userName;

/** 令牌，其余服务登录认证 */
@property(nonatomic, copy) NSString *token;

/** 首次登录 */
@property(nonatomic, assign) BOOL isFirstLogin;

/** 需要加密		field=0x01 */
@property(nonatomic, copy) NSString *password;

/** 性别 0-未知 1-男 2-女  */
@property(nonatomic, assign) Gender gender;

/** 简介 */
@property(nonatomic, copy) NSString *brief;

/** 星座 */
@property(nonatomic, copy) NSString *constellation;

/** 城市名 */
@property(nonatomic, copy) NSString *cityName;

/** 具体名字 */
@property(nonatomic, copy) NSString *detailAdress;

/** 电话号码 */
@property(nonatomic, copy) NSString *telephone;

/** 用户配置 */
@property(nonatomic, copy) NSString *settings;

/** 用户头像 */
@property(nonatomic, strong) NSString *avatarURL;

/** webApi上传头像（相册）地址 */
@property(nonatomic, copy) NSString *webApiUserUploadAvatarURL;

/** webApi获取头相册地址  前缀 */
@property(nonatomic, copy) NSString *webApiUserGetAvatarURL;

/** 经度 */
@property(nonatomic, assign) double longitude;

/** 纬度 */
@property(nonatomic, assign) double latitude;

/** 经验值 */
@property(nonatomic, assign) int64_t experiencePoint;

/** 等级 */
@property(nonatomic, strong) UserLevel * level;

/** 头衔 */
@property(nonatomic, copy) NSString *rank;

/** 收益 */
@property(nonatomic, assign) int64_t income;

/** 支出 */
@property(nonatomic, assign) int64_t outcome;

/** 总金币数 */
@property(nonatomic, assign) int64_t goldCoins;

/** 魅力值 */
@property(nonatomic, assign) int64_t charmValue;

//关注数量
@property(nonatomic, assign) NSUInteger myLikeCount;

//粉丝数量
@property(nonatomic, assign) NSUInteger likeMeCount;

//视频回放数量 --- 照片数 （）
@property(nonatomic, assign) NSUInteger avatarURLArray_Count;

/** 相册列表 */
@property(nonatomic, strong) NSMutableArray<NSString*> *avatarArray;

//相册照片数目
//@property(nonatomic, readonly) NSUInteger avatarURLArray_Count;

/** 自动登录凭证 */
@property(nonatomic, copy) NSString *certificate;

/** 是否手机绑定 */
@property(nonatomic, assign) BOOL isTelephoneBinding;

/** 自己创建的聊天室id，如果我创建房间，然而之前我已经创建了房间那么我就直接进入我创建的房间 */
@property(nonatomic, strong) UsersLoginResponse_Room *myRoom;

/** 自己最后加入的房间id，下次登录的时候如果我断开连接那么我就进入我最后进入的房间 */
@property(nonatomic, strong) UsersLoginResponse_Room *lastJoinRoom;
/** 显示id */
@property(nonatomic, copy) NSString *showId;

//是否被关注
@property (nonatomic,assign)BOOL isLiked;

/** 是否特别关注 */
@property(nonatomic, assign) BOOL isSpecialLike;

/** 主播正在游戏中	 */
@property(nonatomic, assign) BOOL isGaming;

/** 主播正在玩的游戏 */
@property(nonatomic, copy) NSString *gameName;

/** 今天是否签到 */
@property(nonatomic, assign) BOOL signed_p;
#pragma mark 配置属性 自己添加的

//性别字符串
@property(nonatomic,copy)NSString *genderString;

//是否在登录状态
@property(nonatomic,assign)BOOL isLoginStatus;

//利用dic初始化
+(instancetype)initWithJson:(id)json;

@end
