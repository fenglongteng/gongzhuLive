// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Rooms.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class Room;
@class Room_Audience;
GPB_ENUM_FWD_DECLARE(Result);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - RoomsRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface RoomsRoot : GPBRootObject
@end

#pragma mark - Room

typedef GPB_ENUM(Room_FieldNumber) {
  Room_FieldNumber_OwnerId = 1,
  Room_FieldNumber_Avatar = 2,
  Room_FieldNumber_NickName = 3,
  Room_FieldNumber_Brief = 4,
  Room_FieldNumber_CityName = 5,
  Room_FieldNumber_GameName = 6,
  Room_FieldNumber_IsPrivate = 7,
  Room_FieldNumber_IsLiving = 8,
  Room_FieldNumber_IsGaming = 9,
  Room_FieldNumber_IsLiked = 10,
  Room_FieldNumber_CharmValue = 11,
  Room_FieldNumber_AudienceTotalCount = 12,
  Room_FieldNumber_Longitude = 13,
  Room_FieldNumber_Latitude = 14,
  Room_FieldNumber_AvatarsArray = 15,
  Room_FieldNumber_AudienceArray = 16,
  Room_FieldNumber_Abstract = 17,
};

/**
 * 房间
 **/
@interface Room : GPBMessage

/** 主播id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *ownerId;

/** 主播头像 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *avatar;

/** 主播昵称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *nickName;

/** 主播简介 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *brief;

/** 主播城市名 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *cityName;

/** 主播正在玩的游戏名字 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameName;

/** 是否私密直播 */
@property(nonatomic, readwrite) BOOL isPrivate;

/** 是否在直播 */
@property(nonatomic, readwrite) BOOL isLiving;

/** 是否在游戏 */
@property(nonatomic, readwrite) BOOL isGaming;

/** 用户是否已关注主播 */
@property(nonatomic, readwrite) BOOL isLiked;

/** 主播的魅力值 */
@property(nonatomic, readwrite) int64_t charmValue;

/** 房间观众总数 */
@property(nonatomic, readwrite) int64_t audienceTotalCount;

/** 经度 */
@property(nonatomic, readwrite) double longitude;

/** 纬度 */
@property(nonatomic, readwrite) double latitude;

/** 房间头像列表（最多20张） */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *avatarsArray;
/** The number of items in @c avatarsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger avatarsArray_Count;

/** 房间用户列表 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Room_Audience*> *audienceArray;
/** The number of items in @c audienceArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger audienceArray_Count;

/** 房间简介 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *abstract;

@end

#pragma mark - Room_Audience

typedef GPB_ENUM(Room_Audience_FieldNumber) {
  Room_Audience_FieldNumber_UserId = 1,
  Room_Audience_FieldNumber_Avatar = 2,
  Room_Audience_FieldNumber_Level = 3,
  Room_Audience_FieldNumber_IsTooHao = 4,
};

/**
 * 房间观众
 **/
@interface Room_Audience : GPBMessage

/** 用户id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

/** 用户头像 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *avatar;

/** 用户等级 */
@property(nonatomic, readwrite) int32_t level;

/** 是否是土豪 */
@property(nonatomic, readwrite) BOOL isTooHao;

@end

#pragma mark - RoomsGetRoomsRequest

typedef GPB_ENUM(RoomsGetRoomsRequest_FieldNumber) {
  RoomsGetRoomsRequest_FieldNumber_Skip = 1,
  RoomsGetRoomsRequest_FieldNumber_Limit = 2,
};

/**
 * 获取公开房间列表请求
 **/
@interface RoomsGetRoomsRequest : GPBMessage

@property(nonatomic, readwrite) int32_t skip;

@property(nonatomic, readwrite) int32_t limit;

@end

#pragma mark - RoomsGetRoomsResponse

typedef GPB_ENUM(RoomsGetRoomsResponse_FieldNumber) {
  RoomsGetRoomsResponse_FieldNumber_Result = 1,
  RoomsGetRoomsResponse_FieldNumber_Message = 2,
  RoomsGetRoomsResponse_FieldNumber_RoomsArray = 3,
};

/**
 * 获取房间列表响应
 **/
@interface RoomsGetRoomsResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Room*> *roomsArray;
/** The number of items in @c roomsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger roomsArray_Count;

@end

/**
 * Fetches the raw value of a @c RoomsGetRoomsResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsGetRoomsResponse_Result_RawValue(RoomsGetRoomsResponse *message);
/**
 * Sets the raw value of an @c RoomsGetRoomsResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsGetRoomsResponse_Result_RawValue(RoomsGetRoomsResponse *message, int32_t value);

#pragma mark - RoomsGetRoomInfoRequest

typedef GPB_ENUM(RoomsGetRoomInfoRequest_FieldNumber) {
  RoomsGetRoomInfoRequest_FieldNumber_UserId = 1,
};

/**
 * 获取房间详情请求
 **/
@interface RoomsGetRoomInfoRequest : GPBMessage

/** 用户id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@end

#pragma mark - RoomsGetRoomInfoResponse

typedef GPB_ENUM(RoomsGetRoomInfoResponse_FieldNumber) {
  RoomsGetRoomInfoResponse_FieldNumber_Result = 1,
  RoomsGetRoomInfoResponse_FieldNumber_Message = 2,
  RoomsGetRoomInfoResponse_FieldNumber_Room = 3,
};

/**
 * 获取房间详情响应
 **/
@interface RoomsGetRoomInfoResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, strong, null_resettable) Room *room;
/** Test to see if @c room has been set. */
@property(nonatomic, readwrite) BOOL hasRoom;

@end

/**
 * Fetches the raw value of a @c RoomsGetRoomInfoResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsGetRoomInfoResponse_Result_RawValue(RoomsGetRoomInfoResponse *message);
/**
 * Sets the raw value of an @c RoomsGetRoomInfoResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsGetRoomInfoResponse_Result_RawValue(RoomsGetRoomInfoResponse *message, int32_t value);

#pragma mark - RoomsCreateRoomRequest

typedef GPB_ENUM(RoomsCreateRoomRequest_FieldNumber) {
  RoomsCreateRoomRequest_FieldNumber_UserId = 1,
  RoomsCreateRoomRequest_FieldNumber_Password = 2,
  RoomsCreateRoomRequest_FieldNumber_Abstract = 3,
};

/**
 * 创建房间请求
 **/
@interface RoomsCreateRoomRequest : GPBMessage

/** 用id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

/** 房间密码（可选） */
@property(nonatomic, readwrite, copy, null_resettable) NSString *password;

/** 房间简介 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *abstract;

@end

#pragma mark - RoomsCreateRoomResponse

typedef GPB_ENUM(RoomsCreateRoomResponse_FieldNumber) {
  RoomsCreateRoomResponse_FieldNumber_Result = 1,
  RoomsCreateRoomResponse_FieldNumber_Message = 2,
};

/**
 * 创建房间响应
 **/
@interface RoomsCreateRoomResponse : GPBMessage

/** 结果 */
@property(nonatomic, readwrite) enum Result result;

/** 结果描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@end

/**
 * Fetches the raw value of a @c RoomsCreateRoomResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsCreateRoomResponse_Result_RawValue(RoomsCreateRoomResponse *message);
/**
 * Sets the raw value of an @c RoomsCreateRoomResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsCreateRoomResponse_Result_RawValue(RoomsCreateRoomResponse *message, int32_t value);

#pragma mark - RoomsJoinRoomRequest

typedef GPB_ENUM(RoomsJoinRoomRequest_FieldNumber) {
  RoomsJoinRoomRequest_FieldNumber_UserId = 1,
  RoomsJoinRoomRequest_FieldNumber_Password = 2,
};

/**
 * 加入房间请求
 **/
@interface RoomsJoinRoomRequest : GPBMessage

/** 用户id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

/** 房间密码（可选） */
@property(nonatomic, readwrite, copy, null_resettable) NSString *password;

@end

#pragma mark - RoomsJoinRoomResponse

typedef GPB_ENUM(RoomsJoinRoomResponse_FieldNumber) {
  RoomsJoinRoomResponse_FieldNumber_Result = 1,
  RoomsJoinRoomResponse_FieldNumber_Message = 2,
};

/**
 * 加入房间响应
 **/
@interface RoomsJoinRoomResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@end

/**
 * Fetches the raw value of a @c RoomsJoinRoomResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsJoinRoomResponse_Result_RawValue(RoomsJoinRoomResponse *message);
/**
 * Sets the raw value of an @c RoomsJoinRoomResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsJoinRoomResponse_Result_RawValue(RoomsJoinRoomResponse *message, int32_t value);

#pragma mark - RoomsGetNearestRoomRequest

typedef GPB_ENUM(RoomsGetNearestRoomRequest_FieldNumber) {
  RoomsGetNearestRoomRequest_FieldNumber_Offset = 2,
  RoomsGetNearestRoomRequest_FieldNumber_Limit = 3,
};

/**
 * 获取最近的在线主播房间请求
 **/
@interface RoomsGetNearestRoomRequest : GPBMessage

/** 略过 */
@property(nonatomic, readwrite) int32_t offset;

/** 限制 */
@property(nonatomic, readwrite) int32_t limit;

@end

#pragma mark - RoomsGetNearestRoomResponse

typedef GPB_ENUM(RoomsGetNearestRoomResponse_FieldNumber) {
  RoomsGetNearestRoomResponse_FieldNumber_Result = 1,
  RoomsGetNearestRoomResponse_FieldNumber_Message = 2,
  RoomsGetNearestRoomResponse_FieldNumber_RoomsArray = 3,
};

/**
 * 获取最近的在线主播房间响应
 **/
@interface RoomsGetNearestRoomResponse : GPBMessage

/** 结果 */
@property(nonatomic, readwrite) enum Result result;

/** 结果描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 房间列表 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Room*> *roomsArray;
/** The number of items in @c roomsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger roomsArray_Count;

@end

/**
 * Fetches the raw value of a @c RoomsGetNearestRoomResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsGetNearestRoomResponse_Result_RawValue(RoomsGetNearestRoomResponse *message);
/**
 * Sets the raw value of an @c RoomsGetNearestRoomResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsGetNearestRoomResponse_Result_RawValue(RoomsGetNearestRoomResponse *message, int32_t value);

#pragma mark - RoomsGetLikeRoomsRequest

typedef GPB_ENUM(RoomsGetLikeRoomsRequest_FieldNumber) {
  RoomsGetLikeRoomsRequest_FieldNumber_UserId = 1,
  RoomsGetLikeRoomsRequest_FieldNumber_Skip = 2,
  RoomsGetLikeRoomsRequest_FieldNumber_Limit = 3,
};

/**
 * 获取关注房间列表请求
 **/
@interface RoomsGetLikeRoomsRequest : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@property(nonatomic, readwrite) int32_t skip;

@property(nonatomic, readwrite) int32_t limit;

@end

#pragma mark - RoomsGetLikeRoomsResponse

typedef GPB_ENUM(RoomsGetLikeRoomsResponse_FieldNumber) {
  RoomsGetLikeRoomsResponse_FieldNumber_Result = 1,
  RoomsGetLikeRoomsResponse_FieldNumber_Message = 2,
  RoomsGetLikeRoomsResponse_FieldNumber_RoomsArray = 3,
};

/**
 * 获取关注房间列表响应
 **/
@interface RoomsGetLikeRoomsResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Room*> *roomsArray;
/** The number of items in @c roomsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger roomsArray_Count;

@end

/**
 * Fetches the raw value of a @c RoomsGetLikeRoomsResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsGetLikeRoomsResponse_Result_RawValue(RoomsGetLikeRoomsResponse *message);
/**
 * Sets the raw value of an @c RoomsGetLikeRoomsResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsGetLikeRoomsResponse_Result_RawValue(RoomsGetLikeRoomsResponse *message, int32_t value);

#pragma mark - RoomsGetHotRoomsRequest

typedef GPB_ENUM(RoomsGetHotRoomsRequest_FieldNumber) {
  RoomsGetHotRoomsRequest_FieldNumber_Skip = 1,
  RoomsGetHotRoomsRequest_FieldNumber_Limit = 2,
};

/**
 * 获取在线最热房间列表请求
 **/
@interface RoomsGetHotRoomsRequest : GPBMessage

@property(nonatomic, readwrite) int32_t skip;

@property(nonatomic, readwrite) int32_t limit;

@end

#pragma mark - RoomsGetHotRoomsResponse

typedef GPB_ENUM(RoomsGetHotRoomsResponse_FieldNumber) {
  RoomsGetHotRoomsResponse_FieldNumber_Result = 1,
  RoomsGetHotRoomsResponse_FieldNumber_Message = 2,
  RoomsGetHotRoomsResponse_FieldNumber_RoomsArray = 3,
};

/**
 * 获取在线最热房间列表响应
 **/
@interface RoomsGetHotRoomsResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Room*> *roomsArray;
/** The number of items in @c roomsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger roomsArray_Count;

@end

/**
 * Fetches the raw value of a @c RoomsGetHotRoomsResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsGetHotRoomsResponse_Result_RawValue(RoomsGetHotRoomsResponse *message);
/**
 * Sets the raw value of an @c RoomsGetHotRoomsResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsGetHotRoomsResponse_Result_RawValue(RoomsGetHotRoomsResponse *message, int32_t value);

#pragma mark - RoomsGetRecommendRoomsRequest

typedef GPB_ENUM(RoomsGetRecommendRoomsRequest_FieldNumber) {
  RoomsGetRecommendRoomsRequest_FieldNumber_Skip = 1,
  RoomsGetRecommendRoomsRequest_FieldNumber_Limit = 2,
};

/**
 * 获取推荐房间列表请求
 **/
@interface RoomsGetRecommendRoomsRequest : GPBMessage

@property(nonatomic, readwrite) int32_t skip;

@property(nonatomic, readwrite) int32_t limit;

@end

#pragma mark - RoomsGetRecommendRoomsResponse

typedef GPB_ENUM(RoomsGetRecommendRoomsResponse_FieldNumber) {
  RoomsGetRecommendRoomsResponse_FieldNumber_Result = 1,
  RoomsGetRecommendRoomsResponse_FieldNumber_Message = 2,
  RoomsGetRecommendRoomsResponse_FieldNumber_RoomsArray = 3,
};

/**
 * 获取关注房间列表响应
 **/
@interface RoomsGetRecommendRoomsResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Room*> *roomsArray;
/** The number of items in @c roomsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger roomsArray_Count;

@end

/**
 * Fetches the raw value of a @c RoomsGetRecommendRoomsResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsGetRecommendRoomsResponse_Result_RawValue(RoomsGetRecommendRoomsResponse *message);
/**
 * Sets the raw value of an @c RoomsGetRecommendRoomsResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsGetRecommendRoomsResponse_Result_RawValue(RoomsGetRecommendRoomsResponse *message, int32_t value);

#pragma mark - RoomsGetGamingRoomsRequest

typedef GPB_ENUM(RoomsGetGamingRoomsRequest_FieldNumber) {
  RoomsGetGamingRoomsRequest_FieldNumber_GameName = 1,
  RoomsGetGamingRoomsRequest_FieldNumber_Skip = 2,
  RoomsGetGamingRoomsRequest_FieldNumber_Limit = 3,
};

/**
 * 获取正在游戏的房间列表请求
 **/
@interface RoomsGetGamingRoomsRequest : GPBMessage

/** 游戏名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameName;

/** 略过 */
@property(nonatomic, readwrite) int32_t skip;

/** 限制 */
@property(nonatomic, readwrite) int32_t limit;

@end

#pragma mark - RoomsGetGamingRoomsResponse

typedef GPB_ENUM(RoomsGetGamingRoomsResponse_FieldNumber) {
  RoomsGetGamingRoomsResponse_FieldNumber_Result = 1,
  RoomsGetGamingRoomsResponse_FieldNumber_Message = 2,
  RoomsGetGamingRoomsResponse_FieldNumber_RoomsArray = 3,
};

/**
 * 获取正在游戏的房间列表响应
 **/
@interface RoomsGetGamingRoomsResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Room*> *roomsArray;
/** The number of items in @c roomsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger roomsArray_Count;

@end

/**
 * Fetches the raw value of a @c RoomsGetGamingRoomsResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsGetGamingRoomsResponse_Result_RawValue(RoomsGetGamingRoomsResponse *message);
/**
 * Sets the raw value of an @c RoomsGetGamingRoomsResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsGetGamingRoomsResponse_Result_RawValue(RoomsGetGamingRoomsResponse *message, int32_t value);

#pragma mark - RoomsAlterRoomPasswordRequest

typedef GPB_ENUM(RoomsAlterRoomPasswordRequest_FieldNumber) {
  RoomsAlterRoomPasswordRequest_FieldNumber_Password = 1,
};

/**
 * 修改房间密码请求
 **/
@interface RoomsAlterRoomPasswordRequest : GPBMessage

/** 房间密码 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *password;

@end

#pragma mark - RoomsAlterRoomPasswordResponse

typedef GPB_ENUM(RoomsAlterRoomPasswordResponse_FieldNumber) {
  RoomsAlterRoomPasswordResponse_FieldNumber_Result = 1,
  RoomsAlterRoomPasswordResponse_FieldNumber_Message = 2,
};

/**
 * 修改房间密码响应
 **/
@interface RoomsAlterRoomPasswordResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@end

/**
 * Fetches the raw value of a @c RoomsAlterRoomPasswordResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t RoomsAlterRoomPasswordResponse_Result_RawValue(RoomsAlterRoomPasswordResponse *message);
/**
 * Sets the raw value of an @c RoomsAlterRoomPasswordResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetRoomsAlterRoomPasswordResponse_Result_RawValue(RoomsAlterRoomPasswordResponse *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
