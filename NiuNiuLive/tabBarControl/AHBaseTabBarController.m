//
//  AHBaseTabBarController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTabBarController.h"
#import "AHBaseNavController.h"
#import "AHHomeViewController.h"
#import "AHDiscoverViewController.h"
#import "AHMessageViewController.h"
#import "AHMeAccoutViewController.h"
#import "AHTabBarView.h"
#import "AHTabBar.h"
#import "UIImage+extension.h"
#import "AHCreateLiveViewController.h"
#import "AHLocationManager.h"
#import "PPGetAddressBook.h"
#import "NSObject+AHUntil.h"
#import "AHAlertView.h"
#import "AHLiveViewController.h"
#import "Messages.pbobjc.h"
#import "GameSocketManager.h"
#import "AppDelegate.h"
#import "AHLoginViewController.h"

@interface AHBaseTabBarController ()<AHTabBarDelegate>

@end

@implementation AHBaseTabBarController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //定位
    [self locationMange];
    //请求用户获取通讯录权限
    [PPGetAddressBook requestAddressBookAuthorization];
}

//定位
- (void)locationMange{
    AHLocationManager * locationManger = [AHLocationManager sharedInstance];
    locationManger.locationSuccBlock = ^(NSString *detailString){
        //网络传送地址
        UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
        editeInfoRequst.cityName = detailString;
        editeInfoRequst = [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:NO];
        [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
            UsersAlterInfoResponse *editeRespose = response;
            if (editeRespose.result == 0 ) {
                AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
                infoModel.cityName = detailString;
                [[AHPersonInfoManager manager]setInfoModel:infoModel];
            }else{
                AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:editeRespose.message cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
            }
        }];
    };
    [locationManger startLocation];
}

//获取用户数据
-(void)getUserInfo{
    UsersGetInfoRequest *getInfoReuqust = [[UsersGetInfoRequest alloc]init];
    getInfoReuqust.userId = [AHPersonInfoManager manager].getInfoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:getInfoReuqust classSite:@"Users" completion:^(id response, NSString *error) {
        UsersGetInfoResponse *infoRespose = response;
        if (infoRespose.result == 0) {
            [[AHPersonInfoManager manager]setWithJson:infoRespose];
        }
        
    }];
}

- (void)viewDidLoad {
    
   [super viewDidLoad];
 
   [self createChildViewControl:[[AHHomeViewController alloc]initWithNibName:@"AHHomeViewController" bundle:nil] nomalImage:@"btn_iconhome1" selectImage:@"btn_iconhome0" title:@"首页"];
   [self createChildViewControl:[[AHDiscoverViewController alloc]initWithNibName:@"AHDiscoverViewController" bundle:nil] nomalImage:@"btn_iconfind1" selectImage:@"btn_iconfind0" title:@"发现"];
   [self createChildViewControl:[[AHMessageViewController alloc]initWithNibName:@"AHMessageViewController" bundle:nil] nomalImage:@"btn_iconnews1" selectImage:@"btn_iconnews0" title:@"消息"];
   [self createChildViewControl:[[AHMeAccoutViewController alloc]initWithNibName:@"AHMeAccoutViewController" bundle:nil] nomalImage:@"btn_iconme1" selectImage:@"btn_iconme0" title:@"我的"];
    
    AHTabBar *tabBar = [[AHTabBar alloc]init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    [self.tabBar setValue:@(YES) forKeyPath:@"hidesShadow"];

    //设置全局消息展现
    [self showPushGlobalMessage];
    //获取个人信息
    [self getUserInfo];
    //账号被另一个设备登录了
    [self didLoginFromOtherDevice];
}

- (void)showPushGlobalMessage{

    [[AHTcpApi shareInstance]query:@"PushInviteMessage" andHandler:^(id message, NSData *bodyData) {
        
        PushInviteMessage *inviteMes = (PushInviteMessage *)message;
        
        [self showMessageAlert:inviteMes];
        
    }];
}

- (void)showMessageAlert:(PushInviteMessage *)message{

    AHAlertView *alerView = [[AHAlertView alloc]initLiveNoticeAlertViewHeadImage:@"" Status:@"私密直播中" Title:message.message detailString:@"正在直播中，快快进入围观吧" AndLeftBt:@"取消" AndRight:@"立即进入" cancelAction:^{
    } settingAction:^{
        Room *room = [[Room alloc]init];
        room.ownerId = message.roomId;
        AHLiveViewController *liveVC = [[AHLiveViewController alloc]initWithRoom:room];
        liveVC.roomPassW = message.password;//房间的密码
        [[AppDelegate getNavigationTopController].navigationController pushViewController:liveVC animated:YES];
    }];
    [alerView showAlert];
}

- (void )createChildViewControl:(UIViewController *)viewController nomalImage:(NSString *)imagestr selectImage:(NSString *)selectImageStr title:(NSString *)title{
    UIImage *image = [UIImage imageNamed:imagestr];
    UIImage *selectImage = [UIImage imageNamed:selectImageStr];
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x7f648b)} forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)} forState:UIControlStateSelected];//点击字体的显示颜色
     AHBaseNavController *navC = [[AHBaseNavController alloc]initWithRootViewController:viewController];
    [self addChildViewController:navC];
}

#pragma mark -AHTabBarDelegete
- (void)tabBarDidClickPlusButton:(AHTabBar *)tabBar{
    AHCreateLiveViewController *createLiveVC = [[AHCreateLiveViewController alloc]initWithNibName:@"AHCreateLiveViewController" bundle:nil];
    [self.selectedViewController pushViewController:createLiveVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/*
 *  账号被另一个设置登录了
 */
- (void)didLoginFromOtherDevice{
    [[AHTcpApi shareInstance] query:@"OtherLoginPushMessage" andHandler:^(id message, NSData *bodyData) {
        AHAlertView * alert = [[AHAlertView alloc] initAlertViewReminderTitle:@"警告" title:@"您的账号被另一个设备登录了!" cancelBtnTitle:@"确定" cancelAction:^{
            //退出登录
            UsersLogoutRequest *logoutRequest = [[UsersLogoutRequest alloc]init];
            logoutRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
            logoutRequest.password = @"";
            [[AHTcpApi shareInstance]requsetMessage:logoutRequest classSite:UsersClassName completion:^(id response, NSString *error) {
                UsersLogoutResponse *logoutResponse = response;
                if (logoutResponse.result== 0) {
                    AHPersonInfoModel *model = [[AHPersonInfoModel alloc]init];
                    [[AHPersonInfoManager manager]setInfoModel:model];
                    NSMutableArray *array = [NSMutableArray array];
                    [[AHPersonInfoManager manager]setLikeMeArray:array];
                    [[AHPersonInfoManager manager]setMyLikeArray:array];
                    [[AHPersonInfoManager manager]setMyMessageArray:array];
                    [AppDelegate setLogVCBecomeRootViewController];
                }
            }];
            UIWindow *window =  [UIApplication sharedApplication].delegate.window;
            window.rootViewController = [[AHLoginViewController alloc]init];
            [window makeKeyAndVisible];
        }];
        [alert showAlert];
    }];
}


@end
