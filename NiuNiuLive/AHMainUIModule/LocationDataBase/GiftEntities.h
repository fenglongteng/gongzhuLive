//
//  GiftEntities.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftEntities : NSManagedObject<NSCoding>

@property(nonatomic)int64_t minCoin;

@property(nonatomic)int64_t maxCoin;

@property(nonatomic,nullable)NSData * giftArray;

@end

NS_ASSUME_NONNULL_END
