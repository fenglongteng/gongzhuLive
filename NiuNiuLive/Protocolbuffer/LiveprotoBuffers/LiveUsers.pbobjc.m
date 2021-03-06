// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: LiveUsers.proto

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

 #import "LiveUsers.pbobjc.h"
 #import "LiveResponse.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - LiveUsersRoot

@implementation LiveUsersRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - LiveUsersRoot_FileDescriptor

static GPBFileDescriptor *LiveUsersRoot_FileDescriptor(void) {
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

#pragma mark - LiveUsersLoginRequest

@implementation LiveUsersLoginRequest

@dynamic type;
@dynamic userId;
@dynamic token;
@dynamic roomId;

typedef struct LiveUsersLoginRequest__storage_ {
  uint32_t _has_storage_[1];
  LiveUsersLoginRequest_Type type;
  NSString *userId;
  NSString *token;
  NSString *roomId;
} LiveUsersLoginRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "type",
        .dataTypeSpecific.enumDescFunc = LiveUsersLoginRequest_Type_EnumDescriptor,
        .number = LiveUsersLoginRequest_FieldNumber_Type,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LiveUsersLoginRequest__storage_, type),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = LiveUsersLoginRequest_FieldNumber_UserId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(LiveUsersLoginRequest__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "token",
        .dataTypeSpecific.className = NULL,
        .number = LiveUsersLoginRequest_FieldNumber_Token,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(LiveUsersLoginRequest__storage_, token),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "roomId",
        .dataTypeSpecific.className = NULL,
        .number = LiveUsersLoginRequest_FieldNumber_RoomId,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(LiveUsersLoginRequest__storage_, roomId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LiveUsersLoginRequest class]
                                     rootClass:[LiveUsersRoot class]
                                          file:LiveUsersRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LiveUsersLoginRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\002\006\000\004\006\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t LiveUsersLoginRequest_Type_RawValue(LiveUsersLoginRequest *message) {
  GPBDescriptor *descriptor = [LiveUsersLoginRequest descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LiveUsersLoginRequest_FieldNumber_Type];
  return GPBGetMessageInt32Field(message, field);
}

void SetLiveUsersLoginRequest_Type_RawValue(LiveUsersLoginRequest *message, int32_t value) {
  GPBDescriptor *descriptor = [LiveUsersLoginRequest descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LiveUsersLoginRequest_FieldNumber_Type];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - Enum LiveUsersLoginRequest_Type

GPBEnumDescriptor *LiveUsersLoginRequest_Type_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Pusher\000Puller\000";
    static const int32_t values[] = {
        LiveUsersLoginRequest_Type_Pusher,
        LiveUsersLoginRequest_Type_Puller,
    };
    static const char *extraTextFormatInfo = "\002\000\006\000\001\006\000";
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(LiveUsersLoginRequest_Type)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:LiveUsersLoginRequest_Type_IsValidValue
                              extraTextFormatInfo:extraTextFormatInfo];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL LiveUsersLoginRequest_Type_IsValidValue(int32_t value__) {
  switch (value__) {
    case LiveUsersLoginRequest_Type_Pusher:
    case LiveUsersLoginRequest_Type_Puller:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - LiveUsersLoginResponse

@implementation LiveUsersLoginResponse

@dynamic result;
@dynamic message;

typedef struct LiveUsersLoginResponse__storage_ {
  uint32_t _has_storage_[1];
  LiveUsersLoginResponse_Result result;
  NSString *message;
} LiveUsersLoginResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "result",
        .dataTypeSpecific.enumDescFunc = LiveUsersLoginResponse_Result_EnumDescriptor,
        .number = LiveUsersLoginResponse_FieldNumber_Result,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LiveUsersLoginResponse__storage_, result),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "message",
        .dataTypeSpecific.className = NULL,
        .number = LiveUsersLoginResponse_FieldNumber_Message,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(LiveUsersLoginResponse__storage_, message),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LiveUsersLoginResponse class]
                                     rootClass:[LiveUsersRoot class]
                                          file:LiveUsersRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LiveUsersLoginResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t LiveUsersLoginResponse_Result_RawValue(LiveUsersLoginResponse *message) {
  GPBDescriptor *descriptor = [LiveUsersLoginResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LiveUsersLoginResponse_FieldNumber_Result];
  return GPBGetMessageInt32Field(message, field);
}

void SetLiveUsersLoginResponse_Result_RawValue(LiveUsersLoginResponse *message, int32_t value) {
  GPBDescriptor *descriptor = [LiveUsersLoginResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LiveUsersLoginResponse_FieldNumber_Result];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - Enum LiveUsersLoginResponse_Result

GPBEnumDescriptor *LiveUsersLoginResponse_Result_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "UnknownError\000Succeeded\000InvalidParameter\000"
        "UserNotLogged\000InvalidUserIdOrPassword\000In"
        "ternalServerError\000";
    static const int32_t values[] = {
        LiveUsersLoginResponse_Result_UnknownError,
        LiveUsersLoginResponse_Result_Succeeded,
        LiveUsersLoginResponse_Result_InvalidParameter,
        LiveUsersLoginResponse_Result_UserNotLogged,
        LiveUsersLoginResponse_Result_InvalidUserIdOrPassword,
        LiveUsersLoginResponse_Result_InternalServerError,
    };
    static const char *extraTextFormatInfo = "\006\000\014\000\001\t\000\002\020\000\003\r\000\004\027\000\005\023\000";
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(LiveUsersLoginResponse_Result)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:LiveUsersLoginResponse_Result_IsValidValue
                              extraTextFormatInfo:extraTextFormatInfo];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL LiveUsersLoginResponse_Result_IsValidValue(int32_t value__) {
  switch (value__) {
    case LiveUsersLoginResponse_Result_UnknownError:
    case LiveUsersLoginResponse_Result_Succeeded:
    case LiveUsersLoginResponse_Result_InvalidParameter:
    case LiveUsersLoginResponse_Result_UserNotLogged:
    case LiveUsersLoginResponse_Result_InvalidUserIdOrPassword:
    case LiveUsersLoginResponse_Result_InternalServerError:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - LiveUsersLogoutRequest

@implementation LiveUsersLogoutRequest

@dynamic userId;

typedef struct LiveUsersLogoutRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *userId;
} LiveUsersLogoutRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = LiveUsersLogoutRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LiveUsersLogoutRequest__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LiveUsersLogoutRequest class]
                                     rootClass:[LiveUsersRoot class]
                                          file:LiveUsersRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LiveUsersLogoutRequest__storage_)
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

#pragma mark - LiveUsersLogoutResponse

@implementation LiveUsersLogoutResponse

@dynamic result;
@dynamic message;

typedef struct LiveUsersLogoutResponse__storage_ {
  uint32_t _has_storage_[1];
  LiveResult result;
  NSString *message;
} LiveUsersLogoutResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "result",
        .dataTypeSpecific.enumDescFunc = LiveResult_EnumDescriptor,
        .number = LiveUsersLogoutResponse_FieldNumber_Result,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LiveUsersLogoutResponse__storage_, result),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "message",
        .dataTypeSpecific.className = NULL,
        .number = LiveUsersLogoutResponse_FieldNumber_Message,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(LiveUsersLogoutResponse__storage_, message),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LiveUsersLogoutResponse class]
                                     rootClass:[LiveUsersRoot class]
                                          file:LiveUsersRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LiveUsersLogoutResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t LiveUsersLogoutResponse_Result_RawValue(LiveUsersLogoutResponse *message) {
  GPBDescriptor *descriptor = [LiveUsersLogoutResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LiveUsersLogoutResponse_FieldNumber_Result];
  return GPBGetMessageInt32Field(message, field);
}

void SetLiveUsersLogoutResponse_Result_RawValue(LiveUsersLogoutResponse *message, int32_t value) {
  GPBDescriptor *descriptor = [LiveUsersLogoutResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LiveUsersLogoutResponse_FieldNumber_Result];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - LiveUsersOtherLoginRequest

@implementation LiveUsersOtherLoginRequest

@dynamic address;

typedef struct LiveUsersOtherLoginRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *address;
} LiveUsersOtherLoginRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "address",
        .dataTypeSpecific.className = NULL,
        .number = LiveUsersOtherLoginRequest_FieldNumber_Address,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LiveUsersOtherLoginRequest__storage_, address),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LiveUsersOtherLoginRequest class]
                                     rootClass:[LiveUsersRoot class]
                                          file:LiveUsersRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LiveUsersOtherLoginRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - LiveUsersOtherLoginResponse

@implementation LiveUsersOtherLoginResponse

@dynamic result;
@dynamic message;

typedef struct LiveUsersOtherLoginResponse__storage_ {
  uint32_t _has_storage_[1];
  LiveResult result;
  NSString *message;
} LiveUsersOtherLoginResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "result",
        .dataTypeSpecific.enumDescFunc = LiveResult_EnumDescriptor,
        .number = LiveUsersOtherLoginResponse_FieldNumber_Result,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LiveUsersOtherLoginResponse__storage_, result),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "message",
        .dataTypeSpecific.className = NULL,
        .number = LiveUsersOtherLoginResponse_FieldNumber_Message,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(LiveUsersOtherLoginResponse__storage_, message),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LiveUsersOtherLoginResponse class]
                                     rootClass:[LiveUsersRoot class]
                                          file:LiveUsersRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LiveUsersOtherLoginResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t LiveUsersOtherLoginResponse_Result_RawValue(LiveUsersOtherLoginResponse *message) {
  GPBDescriptor *descriptor = [LiveUsersOtherLoginResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LiveUsersOtherLoginResponse_FieldNumber_Result];
  return GPBGetMessageInt32Field(message, field);
}

void SetLiveUsersOtherLoginResponse_Result_RawValue(LiveUsersOtherLoginResponse *message, int32_t value) {
  GPBDescriptor *descriptor = [LiveUsersOtherLoginResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LiveUsersOtherLoginResponse_FieldNumber_Result];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
