//
//  WMLocationManager.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserApis.pbobjc.h"
#import "Gifts.pbobjc.h"

/**
 *  打赏礼物本地数据库
 */
@interface WMLocationManager : NSObject

/**
 *  初始化数据管理
 *
 *  @return 数据管理器
 */
+ (instancetype)defaultDBManage;

@property (nonatomic,strong) NSManagedObjectContext *managedContext;

//保存打赏礼物
- (void)addGiftWithExceptionalModels:(NSArray<RewordConfig *> *)giftArray;

//获取打赏礼物数据
- (NSMutableArray *)getExceptionalGiftData;

//获取所有礼物信息
- (NSMutableArray *)getAllGiftsData;

//保存所有礼物信息
- (void)addAllGiftWithModel:(NSArray<Gift *> *)allGiftArray;

//删除所有打赏礼物信息(有新数据时，先删除旧的)
- (void)deleteAllExceptionGiftData;

//删除所有礼物信息(有新数据时，先删除旧的)
- (void)deleteAllGiftsData;

//查询礼物信息
- (Gift *)getGiftWithGiftId:(NSString *)giftid;


@end
