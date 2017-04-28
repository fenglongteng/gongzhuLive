//
//  AHLoginViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLoginViewController.h"
#import "AppDelegate.h"
#import "AHBaseTabBarController.h"
#import "AHMobilePhoneLoginVC.h"
#import "AHEditeMyInfoVC.h"
#import "AHPersonInfoVC.h"
#import "AHRecommendAttentionVC.h"
#import "AHPersonInfoManager.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"
#import "AHAdvertisementManager.h"
#import "UserApis.pbobjc.h"
#import "WMLocationManager.h"

@interface AHLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backGroudImageView;

@end

@implementation AHLoginViewController

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//};
//
//-(BOOL)prefersStatusBarHidden{
//    return NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    AHAdvertisementManager *manager =   [AHAdvertisementManager manager];
    if (manager.ad1Array.count > 0) {
        SystemGetADListResponse_AD *ad  = manager.ad1Array[0];
        [_backGroudImageView sd_setImageWithURL:[NSURL URLWithString:ad.URL]  placeholderImage:[UIImage imageNamed:@"image_login.jpg"]];
    }else{
        AHWeakSelf(manager);
        manager.updata = ^(){
            if (weakmanager.ad1Array.count>0) {
                SystemGetADListResponse_AD *ad  = weakmanager.ad1Array[0];
                [_backGroudImageView sd_setImageWithURL:[NSURL URLWithString:ad.URL]  placeholderImage:[UIImage imageNamed:@"image_login.jpg"]];
            }
        };
    }
}

- (BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

//跟控制器
- (void)changeWindowRootView{
    [AppDelegate setTabBarControllerBecomeRootViewController];
}

//push到推荐关注页面
-(void)pushRecommendAttentionVC{
    AHEditeMyInfoVC *editMyInfoVC = [[AHEditeMyInfoVC alloc]initWithNibName:@"AHEditeMyInfoVC" bundle:nil];
    [self.navigationController pushViewController:editMyInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)weixinLogin:(id)sender {
    UsersLoginRequest *userLog = [[UsersLoginRequest alloc]init];
    userLog.field = 0;
    userLog.channelUuid = @"cd15fe10-15d8-11e7-a585-00155d010713";
    userLog.telephone = @"9";
    userLog.telephoneZone = @"86";
    userLog.telephoneVerifyCode = @"2980";
    [[AHTcpApi shareInstance] requsetMessage:userLog classSite:UsersClassName completion:^(id response, NSString *error) {
        //每次根据response进行类模型 进行操作并执行其他
        UsersLoginResponse *logrepsonse = (UsersLoginResponse *)response;
        LOG(@"%@",response);
        if (logrepsonse.result == UsersLoginResponse_UserLoginResult_UserLoginResultSucceeded) {
            [[AHPersonInfoManager manager] setWithJson:logrepsonse];
            AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
            infoModel.isLoginStatus = YES;
            [self LineToGameSocket:logrepsonse.userId token:logrepsonse.token];
            [[AHPersonInfoManager manager]setInfoModel:infoModel];
            if (infoModel.isFirstLogin) {
                [self pushRecommendAttentionVC];
            }else{
                [self changeWindowRootView];
            }
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:logrepsonse.message cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];
}


- (void)LineToGameSocket:(NSString *)userid token:(NSString *)tokenStr{
    //连接游戏socket
    [[GameSocketManager instance] connectWithIp:@"10.10.1.153" port:1025];
    //登录请求
    Login * req = [[Login alloc]init];
    NSString* uid = userid;
    NSString* token = tokenStr;//tokenStr;
    req.id_p = uid;
    req.token = token;
    [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
        ResponseStatus * res = GetMessage(ResponseStatus ,body);
        if (res.status == 0) {
            [[GameSocketManager instance] startHeartBeat];
            [self firstLoginToSaveAllGiftMessage];
        }
        return 0;
    }];
}
//第一次登录成功之后保存打赏礼物信息 和 所有礼物信息
- (void)firstLoginToSaveAllGiftMessage{
    //获取打赏礼物信息，并保存。有数据就不存
    [[WMLocationManager defaultDBManage] deleteAllExceptionGiftData];
    if ([[WMLocationManager defaultDBManage] getExceptionalGiftData].count <= 0) {
        RewordConfigReq * config = [[RewordConfigReq alloc] init];
        [[GameSocketManager instance] query:ProtoTypes_PtIdapigetRewordConfig andMessage:config andHandler:^int(PackHeader *header, NSData *body) {
            RewordConfigRes * infoRes = GetMessage(RewordConfigRes ,body);
            if (infoRes.status == 0) {
                [[WMLocationManager defaultDBManage] addGiftWithExceptionalModels:infoRes.configArray];
            }
            return 0 ;
        }];
    }
    //获取所有礼物信息并保存。
    if ([[WMLocationManager defaultDBManage]  getAllGiftsData].count <= 0) {
        GetGiftListRequest * gift = [[GetGiftListRequest alloc] init];
        gift.userId = [AHPersonInfoManager manager].getInfoModel.userId;
        
        [[AHTcpApi shareInstance] requsetMessage:gift classSite:GiftsClassName completion:^(id response, NSString *error) {
            GetGiftListResponse * gifts = (GetGiftListResponse *)response;
            //成功
            if (gifts.result == Result_Succeeded) {
                [[WMLocationManager defaultDBManage] addAllGiftWithModel:gifts.giftArray];
            }
        }];
    }

}

- (IBAction)tencentQQLogin:(id)sender {
    UsersLoginRequest *userLog = [[UsersLoginRequest alloc]init];
    userLog.field = 0;
    userLog.channelUuid = @"cd15fe10-15d8-11e7-a585-00155d010713";
    userLog.telephone = @"101";
    userLog.telephoneZone = @"86";
    userLog.telephoneVerifyCode = @"2980";
    [[AHTcpApi shareInstance] requsetMessage:userLog classSite:UsersClassName completion:^(id response, NSString *error) {
        //每次根据response进行类模型 进行操作并执行其他
        UsersLoginResponse *logrepsonse = (UsersLoginResponse *)response;
        LOG(@"%@",response);
        if (logrepsonse.result == UsersLoginResponse_UserLoginResult_UserLoginResultSucceeded) {
            [[AHPersonInfoManager manager] setWithJson:logrepsonse];
            AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
            infoModel.isLoginStatus = YES;
            [self LineToGameSocket:logrepsonse.userId token:logrepsonse.token];
            [[AHPersonInfoManager manager]setInfoModel:infoModel];
            if (infoModel.isFirstLogin) {
                [self pushRecommendAttentionVC];
            }else{
                [self changeWindowRootView];
            }
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:logrepsonse.message cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];

}

- (IBAction)weiboLogin:(id)sender {
    UsersLoginRequest *userLog = [[UsersLoginRequest alloc]init];
    userLog.field = 0;
    userLog.channelUuid = @"cd15fe10-15d8-11e7-a585-00155d010713";
    userLog.telephone = @"37";
    userLog.telephoneZone = @"86";
    userLog.telephoneVerifyCode = @"2980";
    [[AHTcpApi shareInstance] requsetMessage:userLog classSite:UsersClassName completion:^(id response, NSString *error) {
        //每次根据response进行类模型 进行操作并执行其他
        UsersLoginResponse *logrepsonse = (UsersLoginResponse *)response;
        LOG(@"%@",response);
        if (logrepsonse.result == UsersLoginResponse_UserLoginResult_UserLoginResultSucceeded) {
            [[AHPersonInfoManager manager] setWithJson:logrepsonse];
            AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
            infoModel.isLoginStatus = YES;
            [self LineToGameSocket:logrepsonse.userId token:logrepsonse.token];
            [[AHPersonInfoManager manager]setInfoModel:infoModel];
            if (infoModel.isFirstLogin) {
                [self pushRecommendAttentionVC];
            }else{
                [self changeWindowRootView];
            }
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:logrepsonse.message cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];

}

- (IBAction)phoneLogin:(id)sender {
    AHMobilePhoneLoginVC *mobilePhoneLoginVC = [[AHMobilePhoneLoginVC alloc]init];
    [self.navigationController pushViewController:mobilePhoneLoginVC animated:YES];
}

@end
