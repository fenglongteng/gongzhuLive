// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: protoEcho.proto

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

@class DouNiuBanker;
@class DouNiuBet;
@class DouNiuGameHand;
@class DouNiuHistoryHand;
@class DouNiuHistoryItem;
@class DouNiuRoom;
@class DouNiuUserBet;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum PackageTypes

/** Pf short(0-65535) */
typedef GPB_ENUM(PackageTypes) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  PackageTypes_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  PackageTypes_PtNone = 0,
  PackageTypes_PtEcho = 1,
  PackageTypes_PtProtoBuffer = 2,
  PackageTypes_PtJson = 3,
};

GPBEnumDescriptor *PackageTypes_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL PackageTypes_IsValidValue(int32_t value);

#pragma mark - Enum ProtoTypes

/** Pfp1 int32(0-4294967295) //0xffffffff */
typedef GPB_ENUM(ProtoTypes) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  ProtoTypes_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  ProtoTypes_PtIdnone = 0,
  ProtoTypes_PtIdecho = 1,
  ProtoTypes_PtIdresStatus = 2,
  ProtoTypes_PtIdserverTime = 3,
  ProtoTypes_PtIdlogin = 4097,
  ProtoTypes_PtIdloginEvent = 4098,
  ProtoTypes_PtIddouNiu = 33024,
  ProtoTypes_PtIddouNiuCreateRoom = 33025,
  ProtoTypes_PtIddouNiuDestoryRoom = 33026,
  ProtoTypes_PtIddouNiuEnterRoom = 33027,
  ProtoTypes_PtIddouNiuLeaveRoom = 33028,
  ProtoTypes_PtIddouNiuControlRoom = 33029,

  /** s */
  ProtoTypes_PtIddouNiuEventBet = 33041,

  /** s */
  ProtoTypes_PtIddouNiuEventGameResult = 33042,

  /** some one bet we just broadcast this message */
  ProtoTypes_PtIddouNiuEventOnBet = 33043,
  ProtoTypes_PtIddouNiuBetOne = 33056,

  /** not impliment yet */
  ProtoTypes_PtIddouNiuBets = 33057,
  ProtoTypes_PtIddouNiuBankerReq = 33072,
  ProtoTypes_PtIddouNiuHistoryReq = 33073,
  ProtoTypes_PtIdapigetUsersBasicInfo = 40965,
  ProtoTypes_PtIdapigetRewordConfig = 40977,
  ProtoTypes_PtIdapigetGamesInfo = 40978,
};

GPBEnumDescriptor *ProtoTypes_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL ProtoTypes_IsValidValue(int32_t value);

#pragma mark - Enum BetOnTypes

typedef GPB_ENUM(BetOnTypes) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  BetOnTypes_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  BetOnTypes_Botnone = 0,
  BetOnTypes_Botone = 1,
  BetOnTypes_Bottow = 2,
  BetOnTypes_Botthree = 3,
};

GPBEnumDescriptor *BetOnTypes_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL BetOnTypes_IsValidValue(int32_t value);

#pragma mark - Enum Login_ResponseStatus

typedef GPB_ENUM(Login_ResponseStatus) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  Login_ResponseStatus_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  Login_ResponseStatus_Rsok = 0,
  Login_ResponseStatus_Rserror = 1,
};

GPBEnumDescriptor *Login_ResponseStatus_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL Login_ResponseStatus_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuCreateRoom_ResponseStatus

typedef GPB_ENUM(DouNiuCreateRoom_ResponseStatus) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuCreateRoom_ResponseStatus_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuCreateRoom_ResponseStatus_Rsok = 0,

  /** this is an old room */
  DouNiuCreateRoom_ResponseStatus_Rsold = 1,
  DouNiuCreateRoom_ResponseStatus_Rserror = 2,
};

GPBEnumDescriptor *DouNiuCreateRoom_ResponseStatus_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuCreateRoom_ResponseStatus_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuControlRoom_ResponseStatus

typedef GPB_ENUM(DouNiuControlRoom_ResponseStatus) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuControlRoom_ResponseStatus_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuControlRoom_ResponseStatus_Rsok = 0,
  DouNiuControlRoom_ResponseStatus_RsnotInRoom = 1,
  DouNiuControlRoom_ResponseStatus_Rsunknown = 2,
  DouNiuControlRoom_ResponseStatus_Rsproto = 16,
};

GPBEnumDescriptor *DouNiuControlRoom_ResponseStatus_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuControlRoom_ResponseStatus_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuRoom_RoomGameSteps

typedef GPB_ENUM(DouNiuRoom_RoomGameSteps) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuRoom_RoomGameSteps_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuRoom_RoomGameSteps_Rgsnone = 0,
  DouNiuRoom_RoomGameSteps_Rgsprepair = 1,
  DouNiuRoom_RoomGameSteps_Rgsbeting = 2,
  DouNiuRoom_RoomGameSteps_RgsdealCards = 3,
};

GPBEnumDescriptor *DouNiuRoom_RoomGameSteps_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuRoom_RoomGameSteps_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuEnterRoomRes_ResponseStatus

typedef GPB_ENUM(DouNiuEnterRoomRes_ResponseStatus) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuEnterRoomRes_ResponseStatus_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuEnterRoomRes_ResponseStatus_Rsok = 0,
  DouNiuEnterRoomRes_ResponseStatus_RsroomNotFound = 1,
  DouNiuEnterRoomRes_ResponseStatus_RsenterFailed = 2,
  DouNiuEnterRoomRes_ResponseStatus_Rsunknown = 3,
};

GPBEnumDescriptor *DouNiuEnterRoomRes_ResponseStatus_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuEnterRoomRes_ResponseStatus_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuBet_ResponseStatus

typedef GPB_ENUM(DouNiuBet_ResponseStatus) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuBet_ResponseStatus_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuBet_ResponseStatus_Rsok = 0,
  DouNiuBet_ResponseStatus_RshandInvalid = 1,
  DouNiuBet_ResponseStatus_RswagerNotEnough = 2,
  DouNiuBet_ResponseStatus_RsbankerRunout = 3,
  DouNiuBet_ResponseStatus_Rsbanker = 4,
  DouNiuBet_ResponseStatus_RsnotInRoom = 5,
  DouNiuBet_ResponseStatus_Rsunknown = 6,
};

GPBEnumDescriptor *DouNiuBet_ResponseStatus_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuBet_ResponseStatus_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuEventBet_DBEBTypes

typedef GPB_ENUM(DouNiuEventBet_DBEBTypes) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuEventBet_DBEBTypes_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuEventBet_DBEBTypes_Dbebtbegin = 0,
  DouNiuEventBet_DBEBTypes_Dbebtend = 1,

  /** the pool Wager changed */
  DouNiuEventBet_DBEBTypes_Dbebtchanged = 2,

  /** a new game started */
  DouNiuEventBet_DBEBTypes_Dbebtnext = 3,

  /** start when stopped */
  DouNiuEventBet_DBEBTypes_Dbebtstart = 4,
};

GPBEnumDescriptor *DouNiuEventBet_DBEBTypes_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuEventBet_DBEBTypes_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuEventGameResult_ResponseStatus

typedef GPB_ENUM(DouNiuEventGameResult_ResponseStatus) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuEventGameResult_ResponseStatus_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuEventGameResult_ResponseStatus_Rsok = 0,
  DouNiuEventGameResult_ResponseStatus_Rserror = 1,
};

GPBEnumDescriptor *DouNiuEventGameResult_ResponseStatus_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuEventGameResult_ResponseStatus_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuBankerReq_DNBOperations

typedef GPB_ENUM(DouNiuBankerReq_DNBOperations) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuBankerReq_DNBOperations_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuBankerReq_DNBOperations_Dnbonone = 0,
  DouNiuBankerReq_DNBOperations_DnbogetBankerList = 1,
  DouNiuBankerReq_DNBOperations_DnboapplyBanker = 2,
  DouNiuBankerReq_DNBOperations_DnboapplyUnBanker = 3,
};

GPBEnumDescriptor *DouNiuBankerReq_DNBOperations_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuBankerReq_DNBOperations_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuBankerRes_ResponseStatus

typedef GPB_ENUM(DouNiuBankerRes_ResponseStatus) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuBankerRes_ResponseStatus_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuBankerRes_ResponseStatus_Rsnone = 0,
  DouNiuBankerRes_ResponseStatus_Rserror = 1,
  DouNiuBankerRes_ResponseStatus_Rscoin = 2,
  DouNiuBankerRes_ResponseStatus_Rsroom = 3,
};

GPBEnumDescriptor *DouNiuBankerRes_ResponseStatus_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuBankerRes_ResponseStatus_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuHistoryReq_HistoryType

typedef GPB_ENUM(DouNiuHistoryReq_HistoryType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuHistoryReq_HistoryType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** my history */
  DouNiuHistoryReq_HistoryType_Htself = 0,

  /** room game 1-2-3 -win */
  DouNiuHistoryReq_HistoryType_Htgames = 1,

  /** game coin top n */
  DouNiuHistoryReq_HistoryType_HtgameWinCoin = 2,
};

GPBEnumDescriptor *DouNiuHistoryReq_HistoryType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuHistoryReq_HistoryType_IsValidValue(int32_t value);

#pragma mark - Enum DouNiuHistoryRes_ResponseStatus

typedef GPB_ENUM(DouNiuHistoryRes_ResponseStatus) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  DouNiuHistoryRes_ResponseStatus_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  DouNiuHistoryRes_ResponseStatus_Rsnone = 0,
  DouNiuHistoryRes_ResponseStatus_Rserror = 1,

  /** database */
  DouNiuHistoryRes_ResponseStatus_Rsdb = 2,
};

GPBEnumDescriptor *DouNiuHistoryRes_ResponseStatus_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DouNiuHistoryRes_ResponseStatus_IsValidValue(int32_t value);

#pragma mark - ProtoEchoRoot

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
@interface ProtoEchoRoot : GPBRootObject
@end

#pragma mark - EchoBuf

typedef GPB_ENUM(EchoBuf_FieldNumber) {
  EchoBuf_FieldNumber_Hello = 1,
};

/**
 * echo message
 **/
@interface EchoBuf : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *hello;

@end

#pragma mark - ResponseStatus

typedef GPB_ENUM(ResponseStatus_FieldNumber) {
  ResponseStatus_FieldNumber_Status = 1,
  ResponseStatus_FieldNumber_Info = 2,
  ResponseStatus_FieldNumber_Time = 3,
};

/**
 * normally all
 **/
@interface ResponseStatus : GPBMessage

@property(nonatomic, readwrite) int32_t status;

@property(nonatomic, readwrite, copy, null_resettable) NSString *info;

@property(nonatomic, readwrite) int64_t time;

@end

#pragma mark - UserInfo

typedef GPB_ENUM(UserInfo_FieldNumber) {
  UserInfo_FieldNumber_Id_p = 1,
  UserInfo_FieldNumber_Token = 2,
};

/**
 * //////////////////////////////////////////////////////////////////////////////
 **/
@interface UserInfo : GPBMessage

/** ID, by which we can find its related info */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** Token, we check if User is authentic */
@property(nonatomic, readwrite, copy, null_resettable) NSString *token;

@end

#pragma mark - Login

typedef GPB_ENUM(Login_FieldNumber) {
  Login_FieldNumber_Id_p = 1,
  Login_FieldNumber_Token = 2,
};

/**
 * //////////////////////////////////////////////////////////////////////////////
 **/
@interface Login : GPBMessage

/** ID, by which we can find its related info */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** Token, we check if User is authentic */
@property(nonatomic, readwrite, copy, null_resettable) NSString *token;

@end

#pragma mark - LoginEvent

typedef GPB_ENUM(LoginEvent_FieldNumber) {
  LoginEvent_FieldNumber_Ip = 1,
  LoginEvent_FieldNumber_Time = 2,
};

@interface LoginEvent : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *ip;

@property(nonatomic, readwrite) int64_t time;

@end

#pragma mark - DouNiuCreateRoom

typedef GPB_ENUM(DouNiuCreateRoom_FieldNumber) {
  DouNiuCreateRoom_FieldNumber_Flags = 1,
};

@interface DouNiuCreateRoom : GPBMessage

/** 0x01 stop the game, no game running, just make a room */
@property(nonatomic, readwrite) int32_t flags;

@end

#pragma mark - DouNiuControlRoom

typedef GPB_ENUM(DouNiuControlRoom_FieldNumber) {
  DouNiuControlRoom_FieldNumber_Flags = 1,
};

@interface DouNiuControlRoom : GPBMessage

/** 0x01 stop the game, no game running, just make a room */
@property(nonatomic, readwrite) int32_t flags;

@end

#pragma mark - DouNiuEnterRoom

typedef GPB_ENUM(DouNiuEnterRoom_FieldNumber) {
  DouNiuEnterRoom_FieldNumber_RoomId = 1,
};

@interface DouNiuEnterRoom : GPBMessage

/** may be the user-id who create the room */
@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

@end

#pragma mark - DouNiuRoom

typedef GPB_ENUM(DouNiuRoom_FieldNumber) {
  DouNiuRoom_FieldNumber_RoomId = 1,
  DouNiuRoom_FieldNumber_Banker = 2,
  DouNiuRoom_FieldNumber_GameStep = 3,
  DouNiuRoom_FieldNumber_GameStepTickLeft = 4,
  DouNiuRoom_FieldNumber_Flags = 5,
  DouNiuRoom_FieldNumber_HandArray = 6,
};

@interface DouNiuRoom : GPBMessage

/** room status */
@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/**
 * string BankerID = 2;
 * int64  BankerLeftWager = 3;
 **/
@property(nonatomic, readwrite, strong, null_resettable) DouNiuBanker *banker;
/** Test to see if @c banker has been set. */
@property(nonatomic, readwrite) BOOL hasBanker;

@property(nonatomic, readwrite) DouNiuRoom_RoomGameSteps gameStep;

@property(nonatomic, readwrite) int32_t gameStepTickLeft;

/** 0x01, if game is stop by room creator */
@property(nonatomic, readwrite) int32_t flags;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuGameHand*> *handArray;
/** The number of items in @c handArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger handArray_Count;

@end

/**
 * Fetches the raw value of a @c DouNiuRoom's @c gameStep property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t DouNiuRoom_GameStep_RawValue(DouNiuRoom *message);
/**
 * Sets the raw value of an @c DouNiuRoom's @c gameStep property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetDouNiuRoom_GameStep_RawValue(DouNiuRoom *message, int32_t value);

#pragma mark - DouNiuEnterRoomRes

typedef GPB_ENUM(DouNiuEnterRoomRes_FieldNumber) {
  DouNiuEnterRoomRes_FieldNumber_Status = 1,
  DouNiuEnterRoomRes_FieldNumber_Room = 2,
};

@interface DouNiuEnterRoomRes : GPBMessage

@property(nonatomic, readwrite) int32_t status;

@property(nonatomic, readwrite, strong, null_resettable) DouNiuRoom *room;
/** Test to see if @c room has been set. */
@property(nonatomic, readwrite) BOOL hasRoom;

@end

#pragma mark - DouNiuBet

typedef GPB_ENUM(DouNiuBet_FieldNumber) {
  DouNiuBet_FieldNumber_BetOn = 1,
  DouNiuBet_FieldNumber_Coin = 2,
  DouNiuBet_FieldNumber_Jetton = 3,
};

@interface DouNiuBet : GPBMessage

/** BetOn player 1/2/3 */
@property(nonatomic, readwrite) BetOnTypes betOn;

/** unit of Wager */
@property(nonatomic, readwrite) int64_t coin;

@property(nonatomic, readwrite) int32_t jetton;

@end

/**
 * Fetches the raw value of a @c DouNiuBet's @c betOn property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t DouNiuBet_BetOn_RawValue(DouNiuBet *message);
/**
 * Sets the raw value of an @c DouNiuBet's @c betOn property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetDouNiuBet_BetOn_RawValue(DouNiuBet *message, int32_t value);

#pragma mark - DouNiuBetOne

typedef GPB_ENUM(DouNiuBetOne_FieldNumber) {
  DouNiuBetOne_FieldNumber_RoomId = 1,
  DouNiuBetOne_FieldNumber_GameId = 2,
  DouNiuBetOne_FieldNumber_Bet = 3,
};

@interface DouNiuBetOne : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** this game id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameId;

@property(nonatomic, readwrite, strong, null_resettable) DouNiuBet *bet;
/** Test to see if @c bet has been set. */
@property(nonatomic, readwrite) BOOL hasBet;

@end

#pragma mark - DouNiuBets

typedef GPB_ENUM(DouNiuBets_FieldNumber) {
  DouNiuBets_FieldNumber_RoomId = 1,
  DouNiuBets_FieldNumber_GameId = 2,
  DouNiuBets_FieldNumber_BetsArray = 3,
};

@interface DouNiuBets : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** this game id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameId;

/** ResponseStatus BetsN failed Status= 0,1,2,4 or their combinations */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuBet*> *betsArray;
/** The number of items in @c betsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger betsArray_Count;

@end

#pragma mark - DouNiuUserBet

typedef GPB_ENUM(DouNiuUserBet_FieldNumber) {
  DouNiuUserBet_FieldNumber_UserId = 3,
  DouNiuUserBet_FieldNumber_Bet = 4,
};

/**
 * ///////////////////////////////////////////////
 **/
@interface DouNiuUserBet : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@property(nonatomic, readwrite, strong, null_resettable) DouNiuBet *bet;
/** Test to see if @c bet has been set. */
@property(nonatomic, readwrite) BOOL hasBet;

@end

#pragma mark - DouNiuEventOnBet

typedef GPB_ENUM(DouNiuEventOnBet_FieldNumber) {
  DouNiuEventOnBet_FieldNumber_RoomId = 1,
  DouNiuEventOnBet_FieldNumber_GameId = 2,
  DouNiuEventOnBet_FieldNumber_UserBet = 3,
  DouNiuEventOnBet_FieldNumber_AllBetsArray = 4,
};

@interface DouNiuEventOnBet : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** this game id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameId;

@property(nonatomic, readwrite, strong, null_resettable) DouNiuUserBet *userBet;
/** Test to see if @c userBet has been set. */
@property(nonatomic, readwrite) BOOL hasUserBet;

/** 0,1,2 total coin */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuBet*> *allBetsArray;
/** The number of items in @c allBetsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger allBetsArray_Count;

@end

#pragma mark - DouNiuEventOnBets

typedef GPB_ENUM(DouNiuEventOnBets_FieldNumber) {
  DouNiuEventOnBets_FieldNumber_RoomId = 1,
  DouNiuEventOnBets_FieldNumber_GameId = 2,
  DouNiuEventOnBets_FieldNumber_UserBetsArray = 3,
  DouNiuEventOnBets_FieldNumber_AllBetsArray = 4,
};

@interface DouNiuEventOnBets : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** this game id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameId;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuUserBet*> *userBetsArray;
/** The number of items in @c userBetsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userBetsArray_Count;

/** 0,1,2 total coin */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuBet*> *allBetsArray;
/** The number of items in @c allBetsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger allBetsArray_Count;

@end

#pragma mark - DouNiuEventBet

typedef GPB_ENUM(DouNiuEventBet_FieldNumber) {
  DouNiuEventBet_FieldNumber_RoomId = 1,
  DouNiuEventBet_FieldNumber_GameId = 2,
  DouNiuEventBet_FieldNumber_Time = 3,
  DouNiuEventBet_FieldNumber_Dneb = 4,
  DouNiuEventBet_FieldNumber_Banker = 5,
  DouNiuEventBet_FieldNumber_TickLeft = 6,
  DouNiuEventBet_FieldNumber_AllBetsArray = 7,
  DouNiuEventBet_FieldNumber_Room = 8,
};

/**
 * Server
 **/
@interface DouNiuEventBet : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** this game id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameId;

/** time stamp of the event */
@property(nonatomic, readwrite) int64_t time;

/** Begin/end betting */
@property(nonatomic, readwrite) DouNiuEventBet_DBEBTypes dneb;

/**
 * string BankerID = 5; //DBEBTBegin
 * int64 BankerLeftCoin = 6;
 **/
@property(nonatomic, readwrite, strong, null_resettable) DouNiuBanker *banker;
/** Test to see if @c banker has been set. */
@property(nonatomic, readwrite) BOOL hasBanker;

@property(nonatomic, readwrite) int32_t tickLeft;

/** valid only if Dneb==DBEBTEnd,DBEBTChanged, All wager. */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuBet*> *allBetsArray;
/** The number of items in @c allBetsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger allBetsArray_Count;

@property(nonatomic, readwrite, strong, null_resettable) DouNiuRoom *room;
/** Test to see if @c room has been set. */
@property(nonatomic, readwrite) BOOL hasRoom;

@end

/**
 * Fetches the raw value of a @c DouNiuEventBet's @c dneb property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t DouNiuEventBet_Dneb_RawValue(DouNiuEventBet *message);
/**
 * Sets the raw value of an @c DouNiuEventBet's @c dneb property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetDouNiuEventBet_Dneb_RawValue(DouNiuEventBet *message, int32_t value);

#pragma mark - DouNiuGameHand

typedef GPB_ENUM(DouNiuGameHand_FieldNumber) {
  DouNiuGameHand_FieldNumber_CardsArray = 1,
  DouNiuGameHand_FieldNumber_NiuN = 2,
  DouNiuGameHand_FieldNumber_MaxCard = 3,
  DouNiuGameHand_FieldNumber_Five = 4,
  DouNiuGameHand_FieldNumber_Rate = 5,
  DouNiuGameHand_FieldNumber_WinBanker = 6,
};

@interface DouNiuGameHand : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) GPBInt32Array *cardsArray;
/** The number of items in @c cardsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger cardsArray_Count;

@property(nonatomic, readwrite) int32_t niuN;

/** if niun==, the MaxCard is needs */
@property(nonatomic, readwrite) int32_t maxCard;

/** is Five is 5, it is a 5-NIUNIU */
@property(nonatomic, readwrite) int32_t five;

@property(nonatomic, readwrite) int64_t rate;

@property(nonatomic, readwrite) int32_t winBanker;

@end

#pragma mark - DouNiuEventGameResult

typedef GPB_ENUM(DouNiuEventGameResult_FieldNumber) {
  DouNiuEventGameResult_FieldNumber_RoomId = 1,
  DouNiuEventGameResult_FieldNumber_GameId = 2,
  DouNiuEventGameResult_FieldNumber_Time = 3,
  DouNiuEventGameResult_FieldNumber_HandArray = 4,
  DouNiuEventGameResult_FieldNumber_WinnerId = 5,
  DouNiuEventGameResult_FieldNumber_BankerWinCoin = 6,
  DouNiuEventGameResult_FieldNumber_SelfWinCoin = 8,
  DouNiuEventGameResult_FieldNumber_Status = 9,
  DouNiuEventGameResult_FieldNumber_Reserve = 10,
  DouNiuEventGameResult_FieldNumber_AllBetsArray = 11,
};

@interface DouNiuEventGameResult : GPBMessage

/** game info */
@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** this game id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameId;

/** time stamp of the event */
@property(nonatomic, readwrite) int64_t time;

/** the hands (0,1,2,3), zero is the banker */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuGameHand*> *handArray;
/** The number of items in @c handArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger handArray_Count;

/** (0,1,2,3) */
@property(nonatomic, readwrite) int32_t winnerId;

/** banker infor */
@property(nonatomic, readwrite) int64_t bankerWinCoin;

/**
 * int64 BankerLeftCoin = 7;
 * user info
 **/
@property(nonatomic, readwrite) int64_t selfWinCoin;

@property(nonatomic, readwrite) int32_t status;

@property(nonatomic, readwrite) int32_t reserve;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuBet*> *allBetsArray;
/** The number of items in @c allBetsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger allBetsArray_Count;

@end

#pragma mark - DouNiuBankerReq

typedef GPB_ENUM(DouNiuBankerReq_FieldNumber) {
  DouNiuBankerReq_FieldNumber_Opt = 1,
  DouNiuBankerReq_FieldNumber_RoomId = 2,
};

@interface DouNiuBankerReq : GPBMessage

@property(nonatomic, readwrite) DouNiuBankerReq_DNBOperations opt;

@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

@end

/**
 * Fetches the raw value of a @c DouNiuBankerReq's @c opt property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t DouNiuBankerReq_Opt_RawValue(DouNiuBankerReq *message);
/**
 * Sets the raw value of an @c DouNiuBankerReq's @c opt property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetDouNiuBankerReq_Opt_RawValue(DouNiuBankerReq *message, int32_t value);

#pragma mark - DouNiuBanker

typedef GPB_ENUM(DouNiuBanker_FieldNumber) {
  DouNiuBanker_FieldNumber_Id_p = 1,
  DouNiuBanker_FieldNumber_Coin = 2,
  DouNiuBanker_FieldNumber_NickName = 3,
  DouNiuBanker_FieldNumber_Icon = 4,
  DouNiuBanker_FieldNumber_IsSystem = 5,
};

@interface DouNiuBanker : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** Coin when he/she apply to be a banker */
@property(nonatomic, readwrite) int64_t coin;

@property(nonatomic, readwrite, copy, null_resettable) NSString *nickName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *icon;

@property(nonatomic, readwrite) BOOL isSystem;

@end

#pragma mark - DouNiuBankerRes

typedef GPB_ENUM(DouNiuBankerRes_FieldNumber) {
  DouNiuBankerRes_FieldNumber_Status = 1,
  DouNiuBankerRes_FieldNumber_BankersArray = 2,
};

@interface DouNiuBankerRes : GPBMessage

@property(nonatomic, readwrite) DouNiuBankerRes_ResponseStatus status;

/** the banker candidates */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuBanker*> *bankersArray;
/** The number of items in @c bankersArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger bankersArray_Count;

@end

/**
 * Fetches the raw value of a @c DouNiuBankerRes's @c status property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t DouNiuBankerRes_Status_RawValue(DouNiuBankerRes *message);
/**
 * Sets the raw value of an @c DouNiuBankerRes's @c status property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetDouNiuBankerRes_Status_RawValue(DouNiuBankerRes *message, int32_t value);

#pragma mark - DouNiuHistoryReq

typedef GPB_ENUM(DouNiuHistoryReq_FieldNumber) {
  DouNiuHistoryReq_FieldNumber_Start = 1,
  DouNiuHistoryReq_FieldNumber_Count = 2,
  DouNiuHistoryReq_FieldNumber_Htype = 3,
  DouNiuHistoryReq_FieldNumber_RoomId = 4,
  DouNiuHistoryReq_FieldNumber_GameId = 5,
};

@interface DouNiuHistoryReq : GPBMessage

/** start from N */
@property(nonatomic, readwrite) int32_t start;

/** how many history record you request. */
@property(nonatomic, readwrite) int32_t count;

@property(nonatomic, readwrite) DouNiuHistoryReq_HistoryType htype;

/** if needed, HTGame, HTWin */
@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** if needed, HTWin */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameId;

@end

/**
 * Fetches the raw value of a @c DouNiuHistoryReq's @c htype property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t DouNiuHistoryReq_Htype_RawValue(DouNiuHistoryReq *message);
/**
 * Sets the raw value of an @c DouNiuHistoryReq's @c htype property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetDouNiuHistoryReq_Htype_RawValue(DouNiuHistoryReq *message, int32_t value);

#pragma mark - DouNiuHistoryHand

typedef GPB_ENUM(DouNiuHistoryHand_FieldNumber) {
  DouNiuHistoryHand_FieldNumber_Win = 1,
  DouNiuHistoryHand_FieldNumber_NiuN = 2,
  DouNiuHistoryHand_FieldNumber_Rate = 3,
  DouNiuHistoryHand_FieldNumber_Coin = 4,
};

@interface DouNiuHistoryHand : GPBMessage

/** this hand win */
@property(nonatomic, readwrite) int32_t win;

/** N niu */
@property(nonatomic, readwrite) int32_t niuN;

/**
 * int32 MaxCard
 * int32 Five     //yes five
 **/
@property(nonatomic, readwrite) int64_t rate;

/** coin i beton */
@property(nonatomic, readwrite) int64_t coin;

@end

#pragma mark - DouNiuHistoryItem

typedef GPB_ENUM(DouNiuHistoryItem_FieldNumber) {
  DouNiuHistoryItem_FieldNumber_BankerId = 1,
  DouNiuHistoryItem_FieldNumber_RoomId = 2,
  DouNiuHistoryItem_FieldNumber_GameId = 3,
  DouNiuHistoryItem_FieldNumber_UserId = 4,
  DouNiuHistoryItem_FieldNumber_Time = 5,
  DouNiuHistoryItem_FieldNumber_WinCoin = 6,
  DouNiuHistoryItem_FieldNumber_HandsArray = 7,
  DouNiuHistoryItem_FieldNumber_BankerNiuN = 8,
  DouNiuHistoryItem_FieldNumber_BankerRate = 9,
};

@interface DouNiuHistoryItem : GPBMessage

/** banker id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *bankerId;

/** room id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *roomId;

/** game id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *gameId;

/** user id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

/** game time */
@property(nonatomic, readwrite) int64_t time;

@property(nonatomic, readwrite) int64_t winCoin;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuHistoryHand*> *handsArray;
/** The number of items in @c handsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger handsArray_Count;

@property(nonatomic, readwrite) int32_t bankerNiuN;

@property(nonatomic, readwrite) int32_t bankerRate;

@end

#pragma mark - DouNiuHistoryRes

typedef GPB_ENUM(DouNiuHistoryRes_FieldNumber) {
  DouNiuHistoryRes_FieldNumber_Status = 1,
  DouNiuHistoryRes_FieldNumber_HistoryArray = 2,
};

@interface DouNiuHistoryRes : GPBMessage

@property(nonatomic, readwrite) DouNiuHistoryRes_ResponseStatus status;

/** the banker candidates */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<DouNiuHistoryItem*> *historyArray;
/** The number of items in @c historyArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger historyArray_Count;

@end

/**
 * Fetches the raw value of a @c DouNiuHistoryRes's @c status property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t DouNiuHistoryRes_Status_RawValue(DouNiuHistoryRes *message);
/**
 * Sets the raw value of an @c DouNiuHistoryRes's @c status property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetDouNiuHistoryRes_Status_RawValue(DouNiuHistoryRes *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
