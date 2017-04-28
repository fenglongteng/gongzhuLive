//
//  AHAdvertisementManager.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/19.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Systems.pbobjc.h"

typedef void (^UpData)();

@interface AHAdvertisementManager : NSObject

/** 广告位1 */
@property(nonatomic, strong) NSMutableArray *ad1Array;

/** 广告位2 */
@property(nonatomic, strong) NSMutableArray*ad2Array;

/** 广告位3 */
@property(nonatomic, strong) NSMutableArray*ad3Array;

+(instancetype)manager;

//更新数据block
@property(nonatomic,copy)UpData updata;

@end
