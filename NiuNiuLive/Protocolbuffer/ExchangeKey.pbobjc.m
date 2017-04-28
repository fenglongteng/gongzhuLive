// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ExchangeKey.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "ExchangeKey.pbobjc.h"
 #import "Response.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - ExchangeKeyRoot

@implementation ExchangeKeyRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - ExchangeKeyRoot_FileDescriptor

static GPBFileDescriptor *ExchangeKeyRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"live"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - ExchangeKeyRequest

@implementation ExchangeKeyRequest

@dynamic aesKey;

typedef struct ExchangeKeyRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *aesKey;
} ExchangeKeyRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "aesKey",
        .dataTypeSpecific.className = NULL,
        .number = ExchangeKeyRequest_FieldNumber_AesKey,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ExchangeKeyRequest__storage_, aesKey),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ExchangeKeyRequest class]
                                     rootClass:[ExchangeKeyRoot class]
                                          file:ExchangeKeyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ExchangeKeyRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\006\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - ExchangeKeyResponse

@implementation ExchangeKeyResponse

@dynamic result;
@dynamic message;

typedef struct ExchangeKeyResponse__storage_ {
  uint32_t _has_storage_[1];
  Result result;
  NSString *message;
} ExchangeKeyResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "result",
        .dataTypeSpecific.enumDescFunc = Result_EnumDescriptor,
        .number = ExchangeKeyResponse_FieldNumber_Result,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ExchangeKeyResponse__storage_, result),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "message",
        .dataTypeSpecific.className = NULL,
        .number = ExchangeKeyResponse_FieldNumber_Message,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ExchangeKeyResponse__storage_, message),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ExchangeKeyResponse class]
                                     rootClass:[ExchangeKeyRoot class]
                                          file:ExchangeKeyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ExchangeKeyResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t ExchangeKeyResponse_Result_RawValue(ExchangeKeyResponse *message) {
  GPBDescriptor *descriptor = [ExchangeKeyResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:ExchangeKeyResponse_FieldNumber_Result];
  return GPBGetMessageInt32Field(message, field);
}

void SetExchangeKeyResponse_Result_RawValue(ExchangeKeyResponse *message, int32_t value) {
  GPBDescriptor *descriptor = [ExchangeKeyResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:ExchangeKeyResponse_FieldNumber_Result];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
