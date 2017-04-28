//
//  AHNetworkManager.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/29.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHNetworkMonitor.h"
#import "AHAlertView.h"
static AHNetworkMonitor *networkMonitor = nil;

@interface AHNetworkMonitor()

/**
 网络监测器
 */
@property (nonatomic, strong) Reachability *conn;

@end
@implementation AHNetworkMonitor
+(instancetype)monitorNetwork{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkMonitor = [[AHNetworkMonitor alloc]init];
        networkMonitor.conn = [Reachability reachabilityWithHostName:@"www.baidu.com"];;
        [networkMonitor.conn startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:networkMonitor selector:@selector(networkStateChange:) name:kReachabilityChangedNotification object:nil];
    });
    return networkMonitor;
}

- (void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)networkStateChange:(NSNotification *)note
{
    Reachability *currentReach = [note object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    //判断网络状态
    switch (self.conn.currentReachabilityStatus) {
        case NotReachable:
        {
            self.networkStatus = NotReachable;
            // 没有网络
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"网络异常" title:@"检查一下你的网络环境是否正常，如果出现信号异常也可以代开飞行模式后再还原网络，是否可以修复。" cancelBtnTitle:@"知道了" cancelAction:nil];
            alertView.alertType = AHAlertViewNoNetwork;
            [alertView showAlert];
        }
            break;
        case ReachableViaWiFi:
            self.networkStatus = ReachableViaWiFi;
            break;
        case ReachableViaWWAN:
             self.networkStatus = ReachableViaWWAN;
            break;
        default:
            break;
    }
}

// 用WIFI
// [wifi currentReachabilityStatus] != NotReachable
// [conn currentReachabilityStatus] != NotReachable
// 没有用WIFI, 只用了手机网络
// [wifi currentReachabilityStatus] == NotReachable
// [conn currentReachabilityStatus] != NotReachable
// 没有网络
// [wifi currentReachabilityStatus] == NotReachable
// [conn currentReachabilityStatus] == NotReachable

@end


