// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Messages.proto

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

GPB_ENUM_FWD_DECLARE(Result);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum MessageType

/** 消息类型 */
typedef GPB_ENUM(MessageType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  MessageType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 普通 */
  MessageType_MessageTypeNormal = 0,

  /** 弹幕 */
  MessageType_MessageTypeFlowText = 1,
};

GPBEnumDescriptor *MessageType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL MessageType_IsValidValue(int32_t value);

#pragma mark - MessagesRoot

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
@interface MessagesRoot : GPBRootObject
@end

#pragma mark - SendMessageRequest

typedef GPB_ENUM(SendMessageRequest_FieldNumber) {
  SendMessageRequest_FieldNumber_Type = 1,
  SendMessageRequest_FieldNumber_ToUserId = 2,
  SendMessageRequest_FieldNumber_Message = 3,
  SendMessageRequest_FieldNumber_NeedAck = 4,
  SendMessageRequest_FieldNumber_JsonParam = 5,
  SendMessageRequest_FieldNumber_SubType = 6,
};

/**
 * 发送消息请求
 **/
@interface SendMessageRequest : GPBMessage

/** 类型 */
@property(nonatomic, readwrite) MessageType type;

/** 消息目的（选填，不填为广播) */
@property(nonatomic, readwrite, copy, null_resettable) NSString *toUserId;

/** 文本 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 是否需要服务器发送响应 */
@property(nonatomic, readwrite) BOOL needAck;

/** json附加参数（选填，客户端自己决定） */
@property(nonatomic, readwrite, copy, null_resettable) NSString *jsonParam;

/** 子类别 */
@property(nonatomic, readwrite) int32_t subType;

@end

/**
 * Fetches the raw value of a @c SendMessageRequest's @c type property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SendMessageRequest_Type_RawValue(SendMessageRequest *message);
/**
 * Sets the raw value of an @c SendMessageRequest's @c type property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSendMessageRequest_Type_RawValue(SendMessageRequest *message, int32_t value);

#pragma mark - SendMessageResponse

typedef GPB_ENUM(SendMessageResponse_FieldNumber) {
  SendMessageResponse_FieldNumber_Result = 1,
  SendMessageResponse_FieldNumber_Message = 2,
  SendMessageResponse_FieldNumber_MessageId = 3,
};

/**
 * 发送消息响应
 **/
@interface SendMessageResponse : GPBMessage

/** 结果 */
@property(nonatomic, readwrite) enum Result result;

/** 结果描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 消息id */
@property(nonatomic, readwrite) int64_t messageId;

@end

/**
 * Fetches the raw value of a @c SendMessageResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SendMessageResponse_Result_RawValue(SendMessageResponse *message);
/**
 * Sets the raw value of an @c SendMessageResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSendMessageResponse_Result_RawValue(SendMessageResponse *message, int32_t value);

#pragma mark - SendInviteMessageRequest

typedef GPB_ENUM(SendInviteMessageRequest_FieldNumber) {
  SendInviteMessageRequest_FieldNumber_ToUserIdArray = 1,
  SendInviteMessageRequest_FieldNumber_RoomId = 2,
  SendInviteMessageRequest_FieldNumber_Message = 3,
  SendInviteMessageRequest_FieldNumber_Password = 4,
  SendInviteMessageRequest_FieldNumber_JsonParam = 5,
  SendInviteMessageRequest_FieldNumber_SubType = 6,
};

/**
 * 发送邀请消息请求
 **/
@interface SendInviteMessageRequest : GPBMessage

/** 消息目的 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *toUserIdArray;
/** The number of items in @c toUserIdArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger toUserIdArray_Count;

/** 房间id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** 文本 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 房间密码 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *password;

/** json附加参数（选填，客户端自己决定） */
@property(nonatomic, readwrite, copy, null_resettable) NSString *jsonParam;

/** 子类别 */
@property(nonatomic, readwrite) int32_t subType;

@end

#pragma mark - SendInviteMessageResponse

typedef GPB_ENUM(SendInviteMessageResponse_FieldNumber) {
  SendInviteMessageResponse_FieldNumber_Result = 1,
  SendInviteMessageResponse_FieldNumber_Message = 2,
};

/**
 * 发送邀请消息响应
 **/
@interface SendInviteMessageResponse : GPBMessage

/** 结果 */
@property(nonatomic, readwrite) enum Result result;

/** 结果描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@end

/**
 * Fetches the raw value of a @c SendInviteMessageResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SendInviteMessageResponse_Result_RawValue(SendInviteMessageResponse *message);
/**
 * Sets the raw value of an @c SendInviteMessageResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSendInviteMessageResponse_Result_RawValue(SendInviteMessageResponse *message, int32_t value);

#pragma mark - OtherLoginPushMessage

typedef GPB_ENUM(OtherLoginPushMessage_FieldNumber) {
  OtherLoginPushMessage_FieldNumber_Address = 1,
};

/**
 * 异地登录消息
 **/
@interface OtherLoginPushMessage : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *address;

@end

#pragma mark - OtherLoginPushMessageAck

typedef GPB_ENUM(OtherLoginPushMessageAck_FieldNumber) {
  OtherLoginPushMessageAck_FieldNumber_Result = 1,
  OtherLoginPushMessageAck_FieldNumber_Message = 2,
};

/**
 * 异地登录消息响应
 **/
@interface OtherLoginPushMessageAck : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@end

/**
 * Fetches the raw value of a @c OtherLoginPushMessageAck's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t OtherLoginPushMessageAck_Result_RawValue(OtherLoginPushMessageAck *message);
/**
 * Sets the raw value of an @c OtherLoginPushMessageAck's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetOtherLoginPushMessageAck_Result_RawValue(OtherLoginPushMessageAck *message, int32_t value);

#pragma mark - PushInviteMessage

typedef GPB_ENUM(PushInviteMessage_FieldNumber) {
  PushInviteMessage_FieldNumber_FromUserId = 1,
  PushInviteMessage_FieldNumber_NickName = 2,
  PushInviteMessage_FieldNumber_Avatar = 3,
  PushInviteMessage_FieldNumber_Message = 4,
  PushInviteMessage_FieldNumber_RoomId = 5,
  PushInviteMessage_FieldNumber_Password = 6,
  PushInviteMessage_FieldNumber_JsonParam = 7,
  PushInviteMessage_FieldNumber_SubType = 8,
};

/**
 * 邀请推送消息
 **/
@interface PushInviteMessage : GPBMessage

/** 发送者 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *fromUserId;

/** 昵称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *nickName;

/** 头像 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *avatar;

/** 消息 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 房间id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** 房间密码 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *password;

/** json附加参数（选填，客户端自己决定） */
@property(nonatomic, readwrite, copy, null_resettable) NSString *jsonParam;

/** 子类别 */
@property(nonatomic, readwrite) int32_t subType;

@end

#pragma mark - PushMessage

typedef GPB_ENUM(PushMessage_FieldNumber) {
  PushMessage_FieldNumber_Type = 1,
  PushMessage_FieldNumber_MessageId = 2,
  PushMessage_FieldNumber_FromUserId = 3,
  PushMessage_FieldNumber_Level = 4,
  PushMessage_FieldNumber_NickName = 5,
  PushMessage_FieldNumber_Avatar = 6,
  PushMessage_FieldNumber_Message = 7,
  PushMessage_FieldNumber_NeedAck = 8,
  PushMessage_FieldNumber_JsonParam = 9,
  PushMessage_FieldNumber_SubType = 10,
};

/**
 * 消息推送通知
 **/
@interface PushMessage : GPBMessage

/** 消息类型 */
@property(nonatomic, readwrite) MessageType type;

/** 消息id */
@property(nonatomic, readwrite) int64_t messageId;

/** 发送者id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *fromUserId;

/** 发送者等级 */
@property(nonatomic, readwrite) int32_t level;

/** 昵称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *nickName;

/** 头像 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *avatar;

/** 消息 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 需要确认 */
@property(nonatomic, readwrite) BOOL needAck;

/** json附加参数（选填，客户端自己决定） */
@property(nonatomic, readwrite, copy, null_resettable) NSString *jsonParam;

/** 子类别 */
@property(nonatomic, readwrite) int32_t subType;

@end

/**
 * Fetches the raw value of a @c PushMessage's @c type property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t PushMessage_Type_RawValue(PushMessage *message);
/**
 * Sets the raw value of an @c PushMessage's @c type property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetPushMessage_Type_RawValue(PushMessage *message, int32_t value);

#pragma mark - PushMessageAck

typedef GPB_ENUM(PushMessageAck_FieldNumber) {
  PushMessageAck_FieldNumber_FromUserId = 1,
  PushMessageAck_FieldNumber_MessageId = 2,
};

/**
 * 消息推送确认
 **/
@interface PushMessageAck : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *fromUserId;

@property(nonatomic, readwrite) int64_t messageId;

@end

#pragma mark - LikePush

typedef GPB_ENUM(LikePush_FieldNumber) {
  LikePush_FieldNumber_FromUserid = 1,
  LikePush_FieldNumber_NickName = 2,
  LikePush_FieldNumber_Avatar = 3,
  LikePush_FieldNumber_Timestamp = 4,
  LikePush_FieldNumber_JsonParam = 5,
  LikePush_FieldNumber_SubType = 6,
};

/**
 * 关注推送
 **/
@interface LikePush : GPBMessage

/** 关注的人的id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *fromUserid;

/** 关注人的昵称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *nickName;

/** 头像 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *avatar;

/** 关注时间戳 */
@property(nonatomic, readwrite) int64_t timestamp;

/** json附加参数（选填，客户端自己决定） */
@property(nonatomic, readwrite, copy, null_resettable) NSString *jsonParam;

/** 子类别 */
@property(nonatomic, readwrite) int32_t subType;

@end

#pragma mark - PushLive

typedef GPB_ENUM(PushLive_FieldNumber) {
  PushLive_FieldNumber_Id_p = 1,
  PushLive_FieldNumber_Name = 2,
  PushLive_FieldNumber_NickName = 3,
  PushLive_FieldNumber_Avatar = 4,
};

/**
 * 主播开播消息
 **/
@interface PushLive : GPBMessage

/** string roomId		= 1;	//房间id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** zhubo */
@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

/** 昵称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *nickName;

/** 头像 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *avatar;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
