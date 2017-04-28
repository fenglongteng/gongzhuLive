// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: LiveResponse.proto

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

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum LiveResult

/** 响应码 */
typedef GPB_ENUM(LiveResult) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  LiveResult_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 成功 */
  LiveResult_Succeeded = 0,

  /** 服务器内部错误 */
  LiveResult_InternalServerError = 1,

  /** 未知错误 */
  LiveResult_UnknownError = 2,

  /** 无效的用户信息 */
  LiveResult_InvalidUserInfo = 3,

  /** 无效的用户名或密码 */
  LiveResult_InvalidUserIdOrPassword = 4,

  /** 账户余额不足 */
  LiveResult_InsufficientBalance = 5,

  /** 用户已存在错误 */
  LiveResult_UserExistsError = 6,

  /** 用户不存在错误 */
  LiveResult_UserNotExistsError = 7,

  /** 无效的参数错误 */
  LiveResult_InvalidParameters = 8,

  /** 房间不存在错误 */
  LiveResult_RoomNotExistsError = 9,

  /** 用户未进入任何房间错误 */
  LiveResult_UserNotInTheRoomError = 10,

  /** 今天已签到错误 */
  LiveResult_IsSignedInToday = 11,

  /** 未知的任务UUID错误 */
  LiveResult_UnknownTaskUuid = 12,

  /** 用户还未登陆错误 */
  LiveResult_UserNotLogged = 13,
};

GPBEnumDescriptor *LiveResult_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL LiveResult_IsValidValue(int32_t value);

#pragma mark - LiveResponseRoot

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
@interface LiveResponseRoot : GPBRootObject
@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
