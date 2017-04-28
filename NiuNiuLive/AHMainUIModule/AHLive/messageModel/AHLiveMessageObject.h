//
//  AHLiveMessageObject.h
//  NiuNiuLive
//
//  Created by anhui on 17/4/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gifts.pbobjc.h"
#import "Messages.pbobjc.h"

@interface AHLiveMessageObject : NSObject

@property (nonatomic,strong)PushMessage *message;

@property (nonatomic,assign)CGFloat cellHeigth;

@end
