// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Systems.proto

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

@class SystemGetADListResponse_AD;
@class SystemGetLiveServerAddressResponse_Address;
GPB_ENUM_FWD_DECLARE(Result);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum SystemGetLiveServerAddressRequest_Role

/** 角色 */
typedef GPB_ENUM(SystemGetLiveServerAddressRequest_Role) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  SystemGetLiveServerAddressRequest_Role_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 推流器 */
  SystemGetLiveServerAddressRequest_Role_Pusher = 0,

  /** 用户 */
  SystemGetLiveServerAddressRequest_Role_User = 1,
};

GPBEnumDescriptor *SystemGetLiveServerAddressRequest_Role_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL SystemGetLiveServerAddressRequest_Role_IsValidValue(int32_t value);

#pragma mark - SystemsRoot

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
@interface SystemsRoot : GPBRootObject
@end

#pragma mark - SystemGetADListRequest

typedef GPB_ENUM(SystemGetADListRequest_FieldNumber) {
  SystemGetADListRequest_FieldNumber_UserId = 1,
};

/**
 * 获取系统广告列表请求
 **/
@interface SystemGetADListRequest : GPBMessage

/** 用户id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@end

#pragma mark - SystemGetADListResponse

typedef GPB_ENUM(SystemGetADListResponse_FieldNumber) {
  SystemGetADListResponse_FieldNumber_Result = 1,
  SystemGetADListResponse_FieldNumber_Message = 2,
  SystemGetADListResponse_FieldNumber_URLPrefix = 3,
  SystemGetADListResponse_FieldNumber_Ad1Array = 4,
  SystemGetADListResponse_FieldNumber_Ad2Array = 5,
  SystemGetADListResponse_FieldNumber_Ad3Array = 6,
};

/**
 * 获取系统广告列表响应
 **/
@interface SystemGetADListResponse : GPBMessage

/** 结果 */
@property(nonatomic, readwrite) enum Result result;

/** 结果描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 地址前缀 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *URLPrefix;

/** 广告位1 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<SystemGetADListResponse_AD*> *ad1Array;
/** The number of items in @c ad1Array without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger ad1Array_Count;

/** 广告位2 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<SystemGetADListResponse_AD*> *ad2Array;
/** The number of items in @c ad2Array without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger ad2Array_Count;

/** 广告位3 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<SystemGetADListResponse_AD*> *ad3Array;
/** The number of items in @c ad3Array without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger ad3Array_Count;

@end

/**
 * Fetches the raw value of a @c SystemGetADListResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SystemGetADListResponse_Result_RawValue(SystemGetADListResponse *message);
/**
 * Sets the raw value of an @c SystemGetADListResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSystemGetADListResponse_Result_RawValue(SystemGetADListResponse *message, int32_t value);

#pragma mark - SystemGetADListResponse_AD

typedef GPB_ENUM(SystemGetADListResponse_AD_FieldNumber) {
  SystemGetADListResponse_AD_FieldNumber_Sort = 1,
  SystemGetADListResponse_AD_FieldNumber_Timestamp = 2,
  SystemGetADListResponse_AD_FieldNumber_Link = 3,
  SystemGetADListResponse_AD_FieldNumber_URL = 4,
};

/**
 * 广告
 **/
@interface SystemGetADListResponse_AD : GPBMessage

/** 小端排序 */
@property(nonatomic, readwrite) int32_t sort;

/** 时间戳大到小排序 */
@property(nonatomic, readwrite) int64_t timestamp;

/** 链接 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *link;

/** 图片url */
@property(nonatomic, readwrite, copy, null_resettable) NSString *URL;

@end

#pragma mark - SystemGetLiveServerAddressRequest

typedef GPB_ENUM(SystemGetLiveServerAddressRequest_FieldNumber) {
  SystemGetLiveServerAddressRequest_FieldNumber_Role = 1,
  SystemGetLiveServerAddressRequest_FieldNumber_Id_p = 2,
};

/**
 * 获取直播服务器地址请求
 **/
@interface SystemGetLiveServerAddressRequest : GPBMessage

/** 角色 */
@property(nonatomic, readwrite) SystemGetLiveServerAddressRequest_Role role;

/** id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

@end

/**
 * Fetches the raw value of a @c SystemGetLiveServerAddressRequest's @c role property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SystemGetLiveServerAddressRequest_Role_RawValue(SystemGetLiveServerAddressRequest *message);
/**
 * Sets the raw value of an @c SystemGetLiveServerAddressRequest's @c role property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSystemGetLiveServerAddressRequest_Role_RawValue(SystemGetLiveServerAddressRequest *message, int32_t value);

#pragma mark - SystemGetLiveServerAddressResponse

typedef GPB_ENUM(SystemGetLiveServerAddressResponse_FieldNumber) {
  SystemGetLiveServerAddressResponse_FieldNumber_Result = 1,
  SystemGetLiveServerAddressResponse_FieldNumber_Message = 2,
  SystemGetLiveServerAddressResponse_FieldNumber_AddressArray = 3,
};

/**
 * 获取直播服务器地址响应
 **/
@interface SystemGetLiveServerAddressResponse : GPBMessage

/** 结果 */
@property(nonatomic, readwrite) enum Result result;

/** 结果描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** 地址列表 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<SystemGetLiveServerAddressResponse_Address*> *addressArray;
/** The number of items in @c addressArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger addressArray_Count;

@end

/**
 * Fetches the raw value of a @c SystemGetLiveServerAddressResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SystemGetLiveServerAddressResponse_Result_RawValue(SystemGetLiveServerAddressResponse *message);
/**
 * Sets the raw value of an @c SystemGetLiveServerAddressResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSystemGetLiveServerAddressResponse_Result_RawValue(SystemGetLiveServerAddressResponse *message, int32_t value);

#pragma mark - SystemGetLiveServerAddressResponse_Address

typedef GPB_ENUM(SystemGetLiveServerAddressResponse_Address_FieldNumber) {
  SystemGetLiveServerAddressResponse_Address_FieldNumber_Ip = 1,
  SystemGetLiveServerAddressResponse_Address_FieldNumber_Port = 2,
};

/**
 * 地址
 **/
@interface SystemGetLiveServerAddressResponse_Address : GPBMessage

/** ip */
@property(nonatomic, readwrite, copy, null_resettable) NSString *ip;

/** 端口 */
@property(nonatomic, readwrite) int32_t port;

@end

#pragma mark - SystemLiveServerRegisterRequest

typedef GPB_ENUM(SystemLiveServerRegisterRequest_FieldNumber) {
  SystemLiveServerRegisterRequest_FieldNumber_Uuid = 1,
};

/**
 * 直播服务器注册请求
 **/
@interface SystemLiveServerRegisterRequest : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *uuid;

@end

#pragma mark - SystemLiveServerRegisterResponse

typedef GPB_ENUM(SystemLiveServerRegisterResponse_FieldNumber) {
  SystemLiveServerRegisterResponse_FieldNumber_Result = 1,
  SystemLiveServerRegisterResponse_FieldNumber_Message = 2,
  SystemLiveServerRegisterResponse_FieldNumber_Token = 3,
};

/**
 * 直播服务器注册响应
 **/
@interface SystemLiveServerRegisterResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, copy, null_resettable) NSString *token;

@end

/**
 * Fetches the raw value of a @c SystemLiveServerRegisterResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SystemLiveServerRegisterResponse_Result_RawValue(SystemLiveServerRegisterResponse *message);
/**
 * Sets the raw value of an @c SystemLiveServerRegisterResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSystemLiveServerRegisterResponse_Result_RawValue(SystemLiveServerRegisterResponse *message, int32_t value);

#pragma mark - SystemLiveVerifyTokenRequest

typedef GPB_ENUM(SystemLiveVerifyTokenRequest_FieldNumber) {
  SystemLiveVerifyTokenRequest_FieldNumber_UserId = 1,
  SystemLiveVerifyTokenRequest_FieldNumber_Token = 2,
};

/**
 * 用户token验证请求
 **/
@interface SystemLiveVerifyTokenRequest : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *token;

@end

#pragma mark - SystemLiveVerifyTokenResponse

typedef GPB_ENUM(SystemLiveVerifyTokenResponse_FieldNumber) {
  SystemLiveVerifyTokenResponse_FieldNumber_Result = 1,
  SystemLiveVerifyTokenResponse_FieldNumber_Message = 2,
  SystemLiveVerifyTokenResponse_FieldNumber_UserId = 3,
  SystemLiveVerifyTokenResponse_FieldNumber_Valid = 4,
};

/**
 * 用户token验证响应
 **/
@interface SystemLiveVerifyTokenResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@property(nonatomic, readwrite) BOOL valid;

@end

/**
 * Fetches the raw value of a @c SystemLiveVerifyTokenResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SystemLiveVerifyTokenResponse_Result_RawValue(SystemLiveVerifyTokenResponse *message);
/**
 * Sets the raw value of an @c SystemLiveVerifyTokenResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSystemLiveVerifyTokenResponse_Result_RawValue(SystemLiveVerifyTokenResponse *message, int32_t value);

#pragma mark - SystemUpdateLiveStateRequest

typedef GPB_ENUM(SystemUpdateLiveStateRequest_FieldNumber) {
  SystemUpdateLiveStateRequest_FieldNumber_UserId = 1,
  SystemUpdateLiveStateRequest_FieldNumber_IsLiving = 2,
};

/**
 * 更新直播状态请求
 **/
@interface SystemUpdateLiveStateRequest : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@property(nonatomic, readwrite) BOOL isLiving;

@end

#pragma mark - SystemUpdateLiveStateResponse

typedef GPB_ENUM(SystemUpdateLiveStateResponse_FieldNumber) {
  SystemUpdateLiveStateResponse_FieldNumber_Result = 1,
  SystemUpdateLiveStateResponse_FieldNumber_Message = 2,
  SystemUpdateLiveStateResponse_FieldNumber_UserId = 3,
};

/**
 * 更新直播状态响应
 **/
@interface SystemUpdateLiveStateResponse : GPBMessage

@property(nonatomic, readwrite) enum Result result;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@end

/**
 * Fetches the raw value of a @c SystemUpdateLiveStateResponse's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SystemUpdateLiveStateResponse_Result_RawValue(SystemUpdateLiveStateResponse *message);
/**
 * Sets the raw value of an @c SystemUpdateLiveStateResponse's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSystemUpdateLiveStateResponse_Result_RawValue(SystemUpdateLiveStateResponse *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
