// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Accounts.proto

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

@class AccountsLogResponse_AccountsLog;
GPB_ENUM_FWD_DECLARE(Result);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum AccountsLogResponse_AccountsLog_ModifyType

/** 账户修改方式 */
typedef GPB_ENUM(AccountsLogResponse_AccountsLog_ModifyType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  AccountsLogResponse_AccountsLog_ModifyType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 转账 */
  AccountsLogResponse_AccountsLog_ModifyType_Transfer = 0,

  /** 红包 */
  AccountsLogResponse_AccountsLog_ModifyType_RedPackage = 1,

  /** 弹幕 */
  AccountsLogResponse_AccountsLog_ModifyType_FlowText = 2,

  /** 礼物 */
  AccountsLogResponse_AccountsLog_ModifyType_Gift = 3,

  /** 充值 */
  AccountsLogResponse_AccountsLog_ModifyType_Charge = 4,

  /** 签到 */
  AccountsLogResponse_AccountsLog_ModifyType_SignedIn = 5,

  /** 升级 */
  AccountsLogResponse_AccountsLog_ModifyType_Upgraded = 6,

  /** 手动充值 */
  AccountsLogResponse_AccountsLog_ModifyType_ManualCharge = 7,
};

GPBEnumDescriptor *AccountsLogResponse_AccountsLog_ModifyType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL AccountsLogResponse_AccountsLog_ModifyType_IsValidValue(int32_t value);

#pragma mark - AccountsRoot

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
@interface AccountsRoot : GPBRootObject
@end

#pragma mark - AccountsCreateRecordRequest

/**
 * 创建账户充值记录
 **/
@interface AccountsCreateRecordRequest : GPBMessage

@end

#pragma mark - AccountsChargeRequest

typedef GPB_ENUM(AccountsChargeRequest_FieldNumber) {
  AccountsChargeRequest_FieldNumber_UserId = 1,
  AccountsChargeRequest_FieldNumber_Password = 2,
  AccountsChargeRequest_FieldNumber_Money = 3,
};

/**
 * 账户充值请求
 **/
@interface AccountsChargeRequest : GPBMessage

/** 用户id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

/** 需要加密 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *password;

/** 充值人民币 */
@property(nonatomic, readwrite) int32_t money;

@end

#pragma mark - AccountsChargeResponse

typedef GPB_ENUM(AccountsChargeResponse_FieldNumber) {
  AccountsChargeResponse_FieldNumber_Result = 1,
  AccountsChargeResponse_FieldNumber_Message = 2,
};

/**
 * 账户充值响应
 **/
@interface AccountsChargeResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@end

/**
 * Fetches the raw value of a @c AccountsChargeResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t AccountsChargeResponse_Result_RawValue(AccountsChargeResponse *message);
/**
 * Sets the raw value of an @c AccountsChargeResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetAccountsChargeResponse_Result_RawValue(AccountsChargeResponse *message, int32_t value);

#pragma mark - AccountsTransferRequest

typedef GPB_ENUM(AccountsTransferRequest_FieldNumber) {
  AccountsTransferRequest_FieldNumber_FromUserId = 1,
  AccountsTransferRequest_FieldNumber_Password = 2,
  AccountsTransferRequest_FieldNumber_ToUserId = 3,
  AccountsTransferRequest_FieldNumber_GoldCoins = 4,
};

/**
 * 账户转账请求
 **/
@interface AccountsTransferRequest : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *fromUserId;

/** 需要加密 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *password;

@property(nonatomic, readwrite, copy, null_resettable) NSString *toUserId;

@property(nonatomic, readwrite) int32_t goldCoins;

@end

#pragma mark - AccountsTransferResponse

typedef GPB_ENUM(AccountsTransferResponse_FieldNumber) {
  AccountsTransferResponse_FieldNumber_Result = 1,
  AccountsTransferResponse_FieldNumber_Message = 2,
};

/**
 * 账户转账响应
 **/
@interface AccountsTransferResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@end

/**
 * Fetches the raw value of a @c AccountsTransferResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t AccountsTransferResponse_Result_RawValue(AccountsTransferResponse *message);
/**
 * Sets the raw value of an @c AccountsTransferResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetAccountsTransferResponse_Result_RawValue(AccountsTransferResponse *message, int32_t value);

#pragma mark - AccountsLogRequest

typedef GPB_ENUM(AccountsLogRequest_FieldNumber) {
  AccountsLogRequest_FieldNumber_UserId = 1,
  AccountsLogRequest_FieldNumber_Skip = 2,
  AccountsLogRequest_FieldNumber_Limit = 3,
};

/**
 * 账户日志请求
 **/
@interface AccountsLogRequest : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@property(nonatomic, readwrite) int32_t skip;

@property(nonatomic, readwrite) int32_t limit;

@end

#pragma mark - AccountsLogResponse

typedef GPB_ENUM(AccountsLogResponse_FieldNumber) {
  AccountsLogResponse_FieldNumber_Result = 1,
  AccountsLogResponse_FieldNumber_Message = 2,
  AccountsLogResponse_FieldNumber_AccountsLogArray = 3,
};

/**
 * 账户日志响应
 **/
@interface AccountsLogResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 账户日志 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<AccountsLogResponse_AccountsLog*> *accountsLogArray;
/** The number of items in @c accountsLogArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger accountsLogArray_Count;

@end

/**
 * Fetches the raw value of a @c AccountsLogResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t AccountsLogResponse_Result_RawValue(AccountsLogResponse *message);
/**
 * Sets the raw value of an @c AccountsLogResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetAccountsLogResponse_Result_RawValue(AccountsLogResponse *message, int32_t value);

#pragma mark - AccountsLogResponse_AccountsLog

typedef GPB_ENUM(AccountsLogResponse_AccountsLog_FieldNumber) {
  AccountsLogResponse_AccountsLog_FieldNumber_Id_p = 1,
  AccountsLogResponse_AccountsLog_FieldNumber_CreateTimestamp = 2,
  AccountsLogResponse_AccountsLog_FieldNumber_ModifyType = 3,
  AccountsLogResponse_AccountsLog_FieldNumber_FromUserId = 4,
  AccountsLogResponse_AccountsLog_FieldNumber_ToUserId = 5,
  AccountsLogResponse_AccountsLog_FieldNumber_Money = 6,
  AccountsLogResponse_AccountsLog_FieldNumber_GoldCoins = 7,
};

/**
 * 账户日志
 **/
@interface AccountsLogResponse_AccountsLog : GPBMessage

/** 日志id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** 创建时间 */
@property(nonatomic, readwrite) int64_t createTimestamp;

/** 修改类型 */
@property(nonatomic, readwrite) AccountsLogResponse_AccountsLog_ModifyType modifyType;

/** 来源 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *fromUserId;

/** 目的 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *toUserId;

/** 价格 */
@property(nonatomic, readwrite) int32_t money;

/** 金币数 */
@property(nonatomic, readwrite) int64_t goldCoins;

@end

/**
 * Fetches the raw value of a @c AccountsLogResponse_AccountsLog's @c modifyType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t AccountsLogResponse_AccountsLog_ModifyType_RawValue(AccountsLogResponse_AccountsLog *message);
/**
 * Sets the raw value of an @c AccountsLogResponse_AccountsLog's @c modifyType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetAccountsLogResponse_AccountsLog_ModifyType_RawValue(AccountsLogResponse_AccountsLog *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
