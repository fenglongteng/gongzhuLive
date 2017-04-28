//
//  GiftsEntities.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/25.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftsEntities : NSManagedObject<NSCoding>

@property(nonatomic)int64_t coins;

@property(nullable,nonatomic,retain)NSString * name;

@property(nonatomic)int16_t isHidden;

@property(nullable,nonatomic,retain)NSString *iconUrl;

@property(nullable,nonatomic,retain)NSString *uid;

@property(nonatomic)int16_t animationType;

@property(nonatomic)int16_t allowContinue;

@end

NS_ASSUME_NONNULL_END
