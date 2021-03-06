// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Accounts.proto

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

 #import "Accounts.pbobjc.h"
 #import "Response.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - AccountsRoot

@implementation AccountsRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - AccountsRoot_FileDescriptor

static GPBFileDescriptor *AccountsRoot_FileDescriptor(void) {
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

#pragma mark - AccountsCreateRecordRequest

@implementation AccountsCreateRecordRequest


typedef struct AccountsCreateRecordRequest__storage_ {
  uint32_t _has_storage_[1];
} AccountsCreateRecordRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccountsCreateRecordRequest class]
                                     rootClass:[AccountsRoot class]
                                          file:AccountsRoot_FileDescriptor()
                                        fields:NULL
                                    fieldCount:0
                                   storageSize:sizeof(AccountsCreateRecordRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - AccountsChargeRequest

@implementation AccountsChargeRequest

@dynamic userId;
@dynamic password;
@dynamic money;

typedef struct AccountsChargeRequest__storage_ {
  uint32_t _has_storage_[1];
  int32_t money;
  NSString *userId;
  NSString *password;
} AccountsChargeRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = AccountsChargeRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccountsChargeRequest__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "password",
        .dataTypeSpecific.className = NULL,
        .number = AccountsChargeRequest_FieldNumber_Password,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AccountsChargeRequest__storage_, password),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "money",
        .dataTypeSpecific.className = NULL,
        .number = AccountsChargeRequest_FieldNumber_Money,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(AccountsChargeRequest__storage_, money),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccountsChargeRequest class]
                                     rootClass:[AccountsRoot class]
                                          file:AccountsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccountsChargeRequest__storage_)
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

#pragma mark - AccountsChargeResponse

@implementation AccountsChargeResponse

@dynamic result;
@dynamic message;

typedef struct AccountsChargeResponse__storage_ {
  uint32_t _has_storage_[1];
  Result result;
  NSString *message;
} AccountsChargeResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "result",
        .dataTypeSpecific.enumDescFunc = Result_EnumDescriptor,
        .number = AccountsChargeResponse_FieldNumber_Result,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccountsChargeResponse__storage_, result),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "message",
        .dataTypeSpecific.className = NULL,
        .number = AccountsChargeResponse_FieldNumber_Message,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AccountsChargeResponse__storage_, message),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccountsChargeResponse class]
                                     rootClass:[AccountsRoot class]
                                          file:AccountsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccountsChargeResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t AccountsChargeResponse_Result_RawValue(AccountsChargeResponse *message) {
  GPBDescriptor *descriptor = [AccountsChargeResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AccountsChargeResponse_FieldNumber_Result];
  return GPBGetMessageInt32Field(message, field);
}

void SetAccountsChargeResponse_Result_RawValue(AccountsChargeResponse *message, int32_t value) {
  GPBDescriptor *descriptor = [AccountsChargeResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AccountsChargeResponse_FieldNumber_Result];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - AccountsTransferRequest

@implementation AccountsTransferRequest

@dynamic fromUserId;
@dynamic password;
@dynamic toUserId;
@dynamic goldCoins;

typedef struct AccountsTransferRequest__storage_ {
  uint32_t _has_storage_[1];
  int32_t goldCoins;
  NSString *fromUserId;
  NSString *password;
  NSString *toUserId;
} AccountsTransferRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "fromUserId",
        .dataTypeSpecific.className = NULL,
        .number = AccountsTransferRequest_FieldNumber_FromUserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccountsTransferRequest__storage_, fromUserId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "password",
        .dataTypeSpecific.className = NULL,
        .number = AccountsTransferRequest_FieldNumber_Password,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AccountsTransferRequest__storage_, password),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "toUserId",
        .dataTypeSpecific.className = NULL,
        .number = AccountsTransferRequest_FieldNumber_ToUserId,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(AccountsTransferRequest__storage_, toUserId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "goldCoins",
        .dataTypeSpecific.className = NULL,
        .number = AccountsTransferRequest_FieldNumber_GoldCoins,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(AccountsTransferRequest__storage_, goldCoins),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccountsTransferRequest class]
                                     rootClass:[AccountsRoot class]
                                          file:AccountsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccountsTransferRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\001\n\000\003\010\000\004\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - AccountsTransferResponse

@implementation AccountsTransferResponse

@dynamic result;
@dynamic message;

typedef struct AccountsTransferResponse__storage_ {
  uint32_t _has_storage_[1];
  Result result;
  NSString *message;
} AccountsTransferResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "result",
        .dataTypeSpecific.enumDescFunc = Result_EnumDescriptor,
        .number = AccountsTransferResponse_FieldNumber_Result,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccountsTransferResponse__storage_, result),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "message",
        .dataTypeSpecific.className = NULL,
        .number = AccountsTransferResponse_FieldNumber_Message,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AccountsTransferResponse__storage_, message),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccountsTransferResponse class]
                                     rootClass:[AccountsRoot class]
                                          file:AccountsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccountsTransferResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t AccountsTransferResponse_Result_RawValue(AccountsTransferResponse *message) {
  GPBDescriptor *descriptor = [AccountsTransferResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AccountsTransferResponse_FieldNumber_Result];
  return GPBGetMessageInt32Field(message, field);
}

void SetAccountsTransferResponse_Result_RawValue(AccountsTransferResponse *message, int32_t value) {
  GPBDescriptor *descriptor = [AccountsTransferResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AccountsTransferResponse_FieldNumber_Result];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - AccountsLogRequest

@implementation AccountsLogRequest

@dynamic userId;
@dynamic skip;
@dynamic limit;

typedef struct AccountsLogRequest__storage_ {
  uint32_t _has_storage_[1];
  int32_t skip;
  int32_t limit;
  NSString *userId;
} AccountsLogRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccountsLogRequest__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "skip",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogRequest_FieldNumber_Skip,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AccountsLogRequest__storage_, skip),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "limit",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogRequest_FieldNumber_Limit,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(AccountsLogRequest__storage_, limit),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccountsLogRequest class]
                                     rootClass:[AccountsRoot class]
                                          file:AccountsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccountsLogRequest__storage_)
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

#pragma mark - AccountsLogResponse

@implementation AccountsLogResponse

@dynamic result;
@dynamic message;
@dynamic accountsLogArray, accountsLogArray_Count;

typedef struct AccountsLogResponse__storage_ {
  uint32_t _has_storage_[1];
  Result result;
  NSString *message;
  NSMutableArray *accountsLogArray;
} AccountsLogResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "result",
        .dataTypeSpecific.enumDescFunc = Result_EnumDescriptor,
        .number = AccountsLogResponse_FieldNumber_Result,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccountsLogResponse__storage_, result),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "message",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogResponse_FieldNumber_Message,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AccountsLogResponse__storage_, message),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "accountsLogArray",
        .dataTypeSpecific.className = GPBStringifySymbol(AccountsLogResponse_AccountsLog),
        .number = AccountsLogResponse_FieldNumber_AccountsLogArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(AccountsLogResponse__storage_, accountsLogArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccountsLogResponse class]
                                     rootClass:[AccountsRoot class]
                                          file:AccountsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccountsLogResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\003\000accountsLog\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t AccountsLogResponse_Result_RawValue(AccountsLogResponse *message) {
  GPBDescriptor *descriptor = [AccountsLogResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AccountsLogResponse_FieldNumber_Result];
  return GPBGetMessageInt32Field(message, field);
}

void SetAccountsLogResponse_Result_RawValue(AccountsLogResponse *message, int32_t value) {
  GPBDescriptor *descriptor = [AccountsLogResponse descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AccountsLogResponse_FieldNumber_Result];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - AccountsLogResponse_AccountsLog

@implementation AccountsLogResponse_AccountsLog

@dynamic id_p;
@dynamic createTimestamp;
@dynamic modifyType;
@dynamic fromUserId;
@dynamic toUserId;
@dynamic money;
@dynamic goldCoins;

typedef struct AccountsLogResponse_AccountsLog__storage_ {
  uint32_t _has_storage_[1];
  AccountsLogResponse_AccountsLog_ModifyType modifyType;
  int32_t money;
  NSString *id_p;
  NSString *fromUserId;
  NSString *toUserId;
  int64_t createTimestamp;
  int64_t goldCoins;
} AccountsLogResponse_AccountsLog__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogResponse_AccountsLog_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccountsLogResponse_AccountsLog__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "createTimestamp",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogResponse_AccountsLog_FieldNumber_CreateTimestamp,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AccountsLogResponse_AccountsLog__storage_, createTimestamp),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "modifyType",
        .dataTypeSpecific.enumDescFunc = AccountsLogResponse_AccountsLog_ModifyType_EnumDescriptor,
        .number = AccountsLogResponse_AccountsLog_FieldNumber_ModifyType,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(AccountsLogResponse_AccountsLog__storage_, modifyType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "fromUserId",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogResponse_AccountsLog_FieldNumber_FromUserId,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(AccountsLogResponse_AccountsLog__storage_, fromUserId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "toUserId",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogResponse_AccountsLog_FieldNumber_ToUserId,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(AccountsLogResponse_AccountsLog__storage_, toUserId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "money",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogResponse_AccountsLog_FieldNumber_Money,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(AccountsLogResponse_AccountsLog__storage_, money),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "goldCoins",
        .dataTypeSpecific.className = NULL,
        .number = AccountsLogResponse_AccountsLog_FieldNumber_GoldCoins,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(AccountsLogResponse_AccountsLog__storage_, goldCoins),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccountsLogResponse_AccountsLog class]
                                     rootClass:[AccountsRoot class]
                                          file:AccountsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccountsLogResponse_AccountsLog__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\005\002\017\000\003\n\000\004\n\000\005\010\000\007\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    [localDescriptor setupContainingMessageClassName:GPBStringifySymbol(AccountsLogResponse)];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t AccountsLogResponse_AccountsLog_ModifyType_RawValue(AccountsLogResponse_AccountsLog *message) {
  GPBDescriptor *descriptor = [AccountsLogResponse_AccountsLog descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AccountsLogResponse_AccountsLog_FieldNumber_ModifyType];
  return GPBGetMessageInt32Field(message, field);
}

void SetAccountsLogResponse_AccountsLog_ModifyType_RawValue(AccountsLogResponse_AccountsLog *message, int32_t value) {
  GPBDescriptor *descriptor = [AccountsLogResponse_AccountsLog descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AccountsLogResponse_AccountsLog_FieldNumber_ModifyType];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - Enum AccountsLogResponse_AccountsLog_ModifyType

GPBEnumDescriptor *AccountsLogResponse_AccountsLog_ModifyType_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Transfer\000RedPackage\000FlowText\000Gift\000Charge"
        "\000SignedIn\000Upgraded\000ManualCharge\000";
    static const int32_t values[] = {
        AccountsLogResponse_AccountsLog_ModifyType_Transfer,
        AccountsLogResponse_AccountsLog_ModifyType_RedPackage,
        AccountsLogResponse_AccountsLog_ModifyType_FlowText,
        AccountsLogResponse_AccountsLog_ModifyType_Gift,
        AccountsLogResponse_AccountsLog_ModifyType_Charge,
        AccountsLogResponse_AccountsLog_ModifyType_SignedIn,
        AccountsLogResponse_AccountsLog_ModifyType_Upgraded,
        AccountsLogResponse_AccountsLog_ModifyType_ManualCharge,
    };
    static const char *extraTextFormatInfo = "\010\000\010\000\001\n\000\002\010\000\003\004\000\004\006\000\005\010\000\006\010\000\007\014\000";
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(AccountsLogResponse_AccountsLog_ModifyType)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:AccountsLogResponse_AccountsLog_ModifyType_IsValidValue
                              extraTextFormatInfo:extraTextFormatInfo];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL AccountsLogResponse_AccountsLog_ModifyType_IsValidValue(int32_t value__) {
  switch (value__) {
    case AccountsLogResponse_AccountsLog_ModifyType_Transfer:
    case AccountsLogResponse_AccountsLog_ModifyType_RedPackage:
    case AccountsLogResponse_AccountsLog_ModifyType_FlowText:
    case AccountsLogResponse_AccountsLog_ModifyType_Gift:
    case AccountsLogResponse_AccountsLog_ModifyType_Charge:
    case AccountsLogResponse_AccountsLog_ModifyType_SignedIn:
    case AccountsLogResponse_AccountsLog_ModifyType_Upgraded:
    case AccountsLogResponse_AccountsLog_ModifyType_ManualCharge:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
