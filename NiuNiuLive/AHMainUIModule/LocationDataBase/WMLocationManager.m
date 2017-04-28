//
//  WMLocationManager.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "WMLocationManager.h"
#import "MagicalRecord.h"
#import "GiftEntities.h"
#import "gift.h"
#import "GiftsEntities.h"

static WMLocationManager *dbManage;

@interface WMLocationManager()

@property(nonatomic,strong)NSMutableArray * allGiftsArray;

@end

@implementation WMLocationManager

+ (instancetype)defaultDBManage{
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dbManage = [[WMLocationManager alloc] init];
    });
    return dbManage;
}

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSMutableArray *)allGiftsArray{
    if (!_allGiftsArray) {
        _allGiftsArray = [NSMutableArray arrayWithArray:[self getAllGiftsData]];
    }
    return _allGiftsArray;
}

- (void)addGiftWithExceptionalModels:(NSArray<RewordConfig *> *)giftArray{
    for (RewordConfig * model in giftArray) {
        [self addGiftWithExceptionalModel:model];
    }
}

- (void)addGiftWithExceptionalModel:(RewordConfig *)giftModel{
    GiftEntities * giftMes = [GiftEntities MR_createEntity];
    giftMes.maxCoin = giftModel.maxCoin;
    giftMes.minCoin = giftModel.minCoin;
    NSMutableArray * giftArray = [NSMutableArray array];
    for (RewordGift * model in giftModel.giftsArray) {
        gift * info = [[gift alloc] init];
        info.giftid = model.id_p;
        info.giftname = model.name;
        [giftArray addObject:info];
    }
    giftMes.giftArray = [NSKeyedArchiver archivedDataWithRootObject:giftArray];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (NSMutableArray *)getExceptionalGiftData{
    NSMutableArray * configArray = [[NSMutableArray alloc] init];
    NSMutableArray * entitiesArray = [NSMutableArray arrayWithArray:[self findAllExceptionsArray]];
    for (GiftEntities * giftentities in entitiesArray) {
        RewordConfig * config = [[RewordConfig alloc] init];
        config.minCoin = giftentities.minCoin;
        config.maxCoin = giftentities.maxCoin;
        NSMutableArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:giftentities.giftArray];
        NSMutableArray * giftArray = [NSMutableArray array];
        for (gift * mes in array) {
            RewordGift * reword = [[RewordGift alloc] init];
            reword.id_p = mes.giftid;
            reword.name = mes.giftname;
            [giftArray addObject:reword];
        }
        config.giftsArray = giftArray;
        [configArray addObject:config];
    }
    return configArray;
}

- (void)addAllGiftWithModel:(NSArray<Gift *> *)allGiftArray{
    for (Gift * gift in allGiftArray) {
        [self addGiftWithModel:gift];
    }
}

- (void)addGiftWithModel:(Gift *)giftModel{
    GiftsEntities * gift = [GiftsEntities MR_createEntity];
    gift.iconUrl = giftModel.icon;
    gift.name = giftModel.name;
    gift.coins = giftModel.goldCoins;
    gift.uid = giftModel.uuid;
    gift.isHidden = giftModel.hidden == YES ? 1 : 0;
    gift.allowContinue = giftModel.allowContinue == YES ? 1 : 0;
    gift.animationType = giftModel.animation;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (NSMutableArray *)getAllGiftsData{
    NSMutableArray * giftsArray = [NSMutableArray array];
    
    NSMutableArray * giftsData = [NSMutableArray arrayWithArray:[self findAllGiftsArray]];
    for (GiftsEntities * gifts in giftsData) {
        Gift * giftMes = [[Gift alloc] init];
        giftMes.icon = gifts.iconUrl;
        giftMes.name = gifts.name;
        giftMes.uuid = gifts.uid;
        giftMes.hidden = gifts.isHidden == 1 ? YES : NO;
        giftMes.goldCoins = gifts.coins;
        giftMes.allowContinue = gifts.allowContinue == 1 ? YES : NO;
        giftMes.animation = gifts.animationType;
        [giftsArray addObject:giftMes];
    }
    return giftsArray;
}
/**
 *  删除所有礼物信息
 */
- (void)deleteAllGiftsData{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" 1 == 1"];
    [GiftsEntities MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
/**
 *  删除所有打赏礼物信息
 */
- (void)deleteAllExceptionGiftData{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" 1 == 1"];
    [GiftEntities MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 *  获取所有打赏礼物信息
 */
- (NSMutableArray *)findAllExceptionsArray{
    return [NSMutableArray arrayWithArray:[GiftEntities MR_findAll]];
}

/**
 *  获取所有礼物信息
 */
- (NSMutableArray *)findAllGiftsArray{
    return [NSMutableArray arrayWithArray:[GiftsEntities MR_findAll]];
}

/**
 *  查询礼物
 */
- (Gift *)getGiftWithGiftId:(NSString *)giftid{
    NSPredicate * key = [NSPredicate predicateWithFormat:@"uid == %@",giftid];
    GiftsEntities * giftData = [GiftsEntities MR_findFirstWithPredicate:key];
    Gift * gift = [[Gift alloc] init];
    if (giftData) {
        gift.uuid = giftData.uid;
        gift.goldCoins = giftData.coins;
        gift.name = giftData.name;
        gift.hidden = giftData.isHidden == 1 ? YES : NO;
        gift.allowContinue = giftData.allowContinue == 1 ? YES : NO;
        gift.animation = giftData.animationType;
        gift.icon = giftData.iconUrl;
    }
    return gift;
}

@end
