//
//  GameTcpApi.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/7.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GameTcpCompletionBlock)(id response,NSString *error);


@interface GameTcpApi : NSObject

//单例
+(GameTcpApi *)shareInstance;


//请求
- (void)requsetMessage:(id)messageModel piTag:(NSInteger)piTag requestType:(NSString *)type completion:(AHTcpCompletionBlock)block;


+ (NSData *)encodingWithPacketIndex:(int32_t)pi prototype:(int32_t)pt response:(int8_t)res message:(GPBMessage *)message;
@end







