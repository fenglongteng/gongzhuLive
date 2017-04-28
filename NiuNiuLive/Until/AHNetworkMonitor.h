//
//  AHNetworkManager.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/29.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface AHNetworkMonitor : NSObject

//    NotReachable  0 不可达 表示无连接
//    ReachableViaWiFi 2 使用WiFi网络连接
//    ReachableViaWWAN 1 使用3G / GPRS网络
/**
 当前网络状态，可通过获取单利得到该属性
 */
@property(nonatomic,assign)NetworkStatus networkStatus;

+(instancetype)monitorNetwork;
@end
