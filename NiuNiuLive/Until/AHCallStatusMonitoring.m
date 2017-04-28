//
//  AHCallStatusMonitoring.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/26.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHCallStatusMonitoring.h"
#import "AHAlertView.h"
@import CoreTelephony;
//#import <CoreTelephony/CTCallCenter.h>
//#import <CoreTelephony/CTCall.h>
@interface AHCallStatusMonitoring ()
@property (nonatomic, strong) CTCallCenter *callCenter;
@end

@implementation AHCallStatusMonitoring

-(void)begingMonitoring{
    [self getCarrierInfo];
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            LOG(@"挂断了电话咯Call has been disconnected");
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            LOG(@"电话通了Call has just been connected");
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"" title:@"" cancelBtnTitle:@"" cancelAction:nil];
            alertView.alertType = AHAlertAnchorPhone;
            [alertView showAlert];
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            LOG(@"来电话了Call is incoming");
            
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            LOG(@"正在播出电话call is dialing");
        }
        else
        {
            LOG(@"嘛都没做Nothing is done");
        }
    };
    
}


- (void)getCarrierInfo {
    // 获取运营商信息
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    LOG(@"carrier:%@", [carrier description]);
    
    // 如果运营商变化将更新运营商输出
    info.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier) {
        LOG(@"carrier:%@", [carrier description]);
    };
    
    // 输出手机的数据业务信息
    LOG(@"Radio Access Technology:%@", info.currentRadioAccessTechnology);
}


-(void)endMonitoring{
    _callCenter = nil;
}

@end
