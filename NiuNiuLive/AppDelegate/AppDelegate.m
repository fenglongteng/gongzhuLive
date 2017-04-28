//
//  AppDelegate.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AppDelegate.h"
#import "AHBaseTabBarController.h"
#import "AHBaseNavController.h"
#import "AHLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "AHNetworkMonitor.h"
#import "SocketManager.h"
#import "IQKeyboardManager.h"
//MOb
#import <SMS_SDK/SMSSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "GameSocketManager.h"
#import "AHNetworkMonitor.h"
#import "ProtoEcho.pbobjc.h"
#import "MD5.h"
#import "AHAdvertisementManager.h"
#import "MagicalRecord.h"
#import <CoreData/CoreData.h>

static NSString * const kRecipesStoreName = @"ExceptionalModel.sqlite";
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //加载初始化MagicalRecord
    [MagicalRecord setupCoreDataStackWithStoreNamed:kRecipesStoreName];
    //真机播放没有声音时，调用下面代码。
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //设置不自动锁屏
    [application setIdleTimerDisabled:YES];
    [self notificationSocketDisConnet];
    //连接socket
    [self socket];
    //注册sharesdk
    [self registerShareSdk];
    //注册mob
    [self registerMob];
    //网络状态监听
    [AHNetworkMonitor monitorNetwork];
    //IQkeyBoard键盘设置
    [self  setUpKeyBoard];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //自动登录
    AHPersonInfoModel *infoModel = [AHPersonInfoManager alloc].getInfoModel;

  //  NSString *cer = infoModel.certificate;
//    if (cer.length>0 && infoModel.userId.length>0) {
//        //tabController页面
//        [AppDelegate setTabBarControllerBecomeRootViewController];
//        return YES;
//    }
    //登录页面
    [AppDelegate setLogVCBecomeRootViewController];
    
    return YES;
}

#pragma mark -socket断开进行回调
- (void)notificationSocketDisConnet{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectSockeForLogin:) name:kNotifitySocketDisConnect object:nil];
}

- (void)connectSockeForLogin:(NSNotification *)notif{
    //自动登录
   // [self automaticLogin];
}

//连接socket
- (void)socket{
    //连接
    [[AHTcpApi shareInstance]connectIp:apiSocketHost port:socketPort successBlock:^(int status) {
        [AHAdvertisementManager manager];
    } failBlock:nil];
}
/**
 *  注册sharesdk
 */
- (void)registerShareSdk{
    //各个appKey待之后修改测试
    [ShareSDK registerApp:@"1c40659664769"
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"微信Key"
                                            appSecret:@"填写appSecret"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"QQKey"
                                           appKey:@"填写appSecret"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"填写appKey" appSecret:@"填写appSecret" redirectUri:@"" authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
}

-(void)registerMob{
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:MobAppKey
             withSecret:MobAppScrete];
}


-(void)setUpKeyBoard{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

//自动登录
-(BOOL)automaticLogin{
    
    AHPersonInfoModel *infoModel = [AHPersonInfoManager alloc].getInfoModel;
    NSString *cer = infoModel.certificate;
    if (cer.length>0 && infoModel.userId.length>0) {
        UsersLoginRequest *userLog = [[UsersLoginRequest alloc]init];
        userLog.field = 3;//自动登录为3
        userLog.channelUuid = @"cd15fe10-15d8-11e7-a585-00155d010713";
        userLog.userId = infoModel.userId;
        userLog.certificate = infoModel.certificate;
        if ([AHNetworkMonitor monitorNetwork].networkStatus == NotReachable) {
            [[AHTcpApi shareInstance] requsetMessage:userLog classSite:UsersClassName completion:^(id response, NSString *error) {
                //每次根据response进行类模型 进行操作并执行其他
                UsersLoginResponse *logrepsonse = (UsersLoginResponse *)response;
                LOG(@"%@",response);
                if (logrepsonse.result == UsersLoginResponse_UserLoginResult_UserLoginResultSucceeded) {
                    [[AHPersonInfoManager manager] setWithJson:logrepsonse];
                    AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
                    infoModel.isLoginStatus = YES;
                    [[AHPersonInfoManager manager]setInfoModel:infoModel];
                    [self LineToGameSocket:logrepsonse.userId token:logrepsonse.token];
                    //tabController页面
                    [AppDelegate setTabBarControllerBecomeRootViewController];
                    LOG(@"自动登录成功");
                }else{
                    //登录页面
                    [AppDelegate setLogVCBecomeRootViewController];
                   LOG(@"自动登录失败");
                }
            }];
        }
        return YES;
    }else{
        
        return NO;
    }
}

- (void)LineToGameSocket:(NSString *)userid token:(NSString *)tokenStr{
    //连接游戏socket
    [[GameSocketManager instance] connectWithIp:@"10.10.1.153" port:1025];
    //登录请求
    Login * req = [[Login alloc]init];
    NSString* uid = userid;
    NSString* token = tokenStr;//tokenStr;
    req.id_p = uid;
    //req.token = @"zhang";
    [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
        ResponseStatus * res = GetMessage(ResponseStatus ,body);
        if (res.status == 0) {
            //md5
            req.token = [MD5 getStringMd5:[NSString stringWithFormat:@"%lld-%@-%@",res.time,uid,token]];//md5
            //login again
            [[GameSocketManager instance] query:ProtoTypes_PtIdlogin andMessage:req andHandler:^int(PackHeader *h, NSData *b) {
                ResponseStatus * rs = GetMessage(ResponseStatus ,b);
                //NSLog(@"Login: %@", rs);
                if (rs.status == 0) {
                    //login ok
                    [[GameSocketManager instance] startHeartBeat];
                }else{
                    //login failed;
                }
                return 0;
            }];
        }else{
            // login failed;
        }
        return 0;
    }];
    
}

#pragma mark - 获取topViewController

+ (UIWindow *)getAppdelegateWindow{
    
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
}

+ (UIViewController *)getAppdelegateRootViewControoler{
    
    AppDelegate *appdelegate = [AppDelegate getSelf];
    
    return appdelegate.window.rootViewController;
}

+ (UIViewController *)getNavigationTopController{
    
    UINavigationController *rootVC = [AppDelegate getAppdelegateRootViewControoler];
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        AHBaseNavController *nav = (AHBaseNavController *)tabBarVC.selectedViewController;
        return nav.topViewController;
    }else{
        return rootVC.topViewController;
    }
    
}

+(AppDelegate *)getSelf{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//设置登录控制器为根控制器
+(void)setLogVCBecomeRootViewController{
    UIWindow *window =  [self getSelf].window;
    AHLoginViewController *loginVC = [[AHLoginViewController alloc]initWithNibName:@"AHLoginViewController" bundle:nil];
    AHBaseNavController *nav = [[AHBaseNavController alloc]initWithRootViewController:loginVC];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
}

//设置TabBarController为跟控制器
+(void)setTabBarControllerBecomeRootViewController{
    UIWindow *window =  [self getSelf].window;
    window.rootViewController = [[AHBaseTabBarController alloc]init];
    [window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark iOS后台3分钟发送主播离开

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 标记一个长时间运行的后台任务将开始
    // 通过调试，发现，iOS给了我们额外的10分钟（600s）来执行这个任务。
    self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^(void) {
        // 当应用程序留给后台的时间快要到结束时（应用程序留给后台执行的时间是有限的）， 这个Block块将被执行
        // 我们需要在次Block块中执行一些清理工作。
        // 如果清理工作失败了，那么将导致程序挂掉
        
        // 清理工作需要在主线程中用同步的方式来进行
        [self endBackgroundTask];
    }];
    // 模拟一个Long-Running Task
    self.myTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f
                                                   target:self
                                                 selector:@selector(timerMethod:)     userInfo:nil
                                                  repeats:YES];
}

- (void) endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void) {
        AppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil){
            [strongSelf.myTimer invalidate];// 停止定时器
            // 每个对 beginBackgroundTaskWithExpirationHandler:方法的调用,必须要相应的调用 endBackgroundTask:方法。这样，来告诉应用程序你已经执行完成了。
            // 也就是说,我们向 iOS 要更多时间来完成一个任务,那么我们必须告诉 iOS 你什么时候能完成那个任务。
            // 也就是要告诉应用程序：“好借好还”嘛。
            // 标记指定的后台任务完成
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            // 销毁后台任务标识符
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

// 模拟的一个 Long-Running Task 方法
- (void) timerMethod:(NSTimer *)paramSender{
    // backgroundTimeRemaining 属性包含了程序留给的我们的时间
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX){
        NSLog(@"Background Time Remaining = Undetermined");
    } else {
        NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self endBackgroundTask];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
