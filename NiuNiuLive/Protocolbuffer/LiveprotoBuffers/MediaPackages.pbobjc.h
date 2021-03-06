// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MediaPackages.proto

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

#pragma mark - Enum MediaPackageConst

/** 静态 */
typedef GPB_ENUM(MediaPackageConst) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  MediaPackageConst_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  MediaPackageConst_MediaPackageConstZero = 0,

  /** 以太网MTU为1500，预留300给序列化结构 */
  MediaPackageConst_MediaPackageConstMtu = 1200,
};

GPBEnumDescriptor *MediaPackageConst_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL MediaPackageConst_IsValidValue(int32_t value);

#pragma mark - Enum MediaPackageMediaType

/** 媒体类型 */
typedef GPB_ENUM(MediaPackageMediaType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  MediaPackageMediaType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 未知 */
  MediaPackageMediaType_MediaPackageMediaTypeUnknown = 0,

  /** 视频 */
  MediaPackageMediaType_MediaPackageMediaTypeVideo = 1,

  /** 音频 */
  MediaPackageMediaType_MediaPackageMediaTypeAudio = 2,
};

GPBEnumDescriptor *MediaPackageMediaType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL MediaPackageMediaType_IsValidValue(int32_t value);

#pragma mark - Enum H264FrameType

/** H264帧类型 */
typedef GPB_ENUM(H264FrameType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  H264FrameType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 未知 */
  H264FrameType_H264FrameTypeUnknown = 0,

  /** SPS帧 */
  H264FrameType_H264FrameTypeSps = 1,

  /** PPS帧 */
  H264FrameType_H264FrameTypePps = 2,

  /** I帧 */
  H264FrameType_H264FrameTypeI = 3,

  /** B帧 */
  H264FrameType_H264FrameTypeB = 4,

  /** P帧 */
  H264FrameType_H264FrameTypeP = 5,
};

GPBEnumDescriptor *H264FrameType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL H264FrameType_IsValidValue(int32_t value);

#pragma mark - Enum MediaPackageCodecType

/** 编解码类型 */
typedef GPB_ENUM(MediaPackageCodecType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  MediaPackageCodecType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 未知 */
  MediaPackageCodecType_MediaPackageCodecTypeUnknown = 0,

  /** H264 */
  MediaPackageCodecType_MediaPackageCodecTypeH264 = 1,

  /** AAC */
  MediaPackageCodecType_MediaPackageCodecTypeAac = 2,
};

GPBEnumDescriptor *MediaPackageCodecType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL MediaPackageCodecType_IsValidValue(int32_t value);

#pragma mark - MediaPackagesRoot

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
@interface MediaPackagesRoot : GPBRootObject
@end

#pragma mark - MediaPackage

typedef GPB_ENUM(MediaPackage_FieldNumber) {
  MediaPackage_FieldNumber_MediaType = 1,
  MediaPackage_FieldNumber_CodecType = 2,
  MediaPackage_FieldNumber_H264FrameType = 3,
  MediaPackage_FieldNumber_RoomId = 4,
  MediaPackage_FieldNumber_FrameId = 5,
  MediaPackage_FieldNumber_PackageId = 6,
  MediaPackage_FieldNumber_HasRemain = 7,
  MediaPackage_FieldNumber_Width = 8,
  MediaPackage_FieldNumber_Height = 9,
  MediaPackage_FieldNumber_Timestamp = 10,
  MediaPackage_FieldNumber_TotalSize = 11,
  MediaPackage_FieldNumber_Size = 12,
  MediaPackage_FieldNumber_Data_p = 13,
};

/**
 * 媒体数据包
 **/
@interface MediaPackage : GPBMessage

/** 媒体类型 */
@property(nonatomic, readwrite) MediaPackageMediaType mediaType;

/** 解码器类型 */
@property(nonatomic, readwrite) MediaPackageCodecType codecType;

/** H264帧类型 */
@property(nonatomic, readwrite) H264FrameType h264FrameType;

/** 房间Id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** 帧编号 */
@property(nonatomic, readwrite) int64_t frameId;

/** 包序号 */
@property(nonatomic, readwrite) int64_t packageId;

/** 是否还有帧内数据 */
@property(nonatomic, readwrite) BOOL hasRemain;

/** 视频宽 */
@property(nonatomic, readwrite) int32_t width;

/** 视频高 */
@property(nonatomic, readwrite) int32_t height;

/** 时间戳 */
@property(nonatomic, readwrite) int64_t timestamp;

/** 帧总大小 */
@property(nonatomic, readwrite) int32_t totalSize;

/** 数据大小 */
@property(nonatomic, readwrite) int32_t size;

/** 数据 */
@property(nonatomic, readwrite, copy, null_resettable) NSData *data_p;

@end

/**
 * Fetches the raw value of a @c MediaPackage's @c mediaType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t MediaPackage_MediaType_RawValue(MediaPackage *message);
/**
 * Sets the raw value of an @c MediaPackage's @c mediaType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetMediaPackage_MediaType_RawValue(MediaPackage *message, int32_t value);

/**
 * Fetches the raw value of a @c MediaPackage's @c codecType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t MediaPackage_CodecType_RawValue(MediaPackage *message);
/**
 * Sets the raw value of an @c MediaPackage's @c codecType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetMediaPackage_CodecType_RawValue(MediaPackage *message, int32_t value);

/**
 * Fetches the raw value of a @c MediaPackage's @c h264FrameType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t MediaPackage_H264FrameType_RawValue(MediaPackage *message);
/**
 * Sets the raw value of an @c MediaPackage's @c h264FrameType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetMediaPackage_H264FrameType_RawValue(MediaPackage *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
