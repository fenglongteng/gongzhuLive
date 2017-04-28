//
//  AHMessageModel.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+YYAdd.h"
@interface AHMessageModel : NSObject
/** 昵称 */
@property(nonatomic, copy) NSString *nickName;
/** 消息 */
@property(nonatomic, copy) NSString *message;
/** 接受的时间 */
@property(nonatomic, copy) NSString *acceptTime;
@end
