//
//  AHMobilePhoneLoginVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMobilePhoneLoginVC.h"
#import "UIView+ST.h"
#import "NSString+Tool.h"
#import <SMS_SDK/SMSSDK.h>
#import "UIViewController+HUD.h"
#import "AHRecommendAttentionVC.h"
#import "AHEditeMyInfoVC.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"
#import "UserApis.pbobjc.h"
#import "WMLocationManager.h"
#import "AHNetworkMonitor.h"
@interface AHMobilePhoneLoginVC ()<UITextFieldDelegate>
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeBt;
//手机号码
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
//确认按钮
@property (weak, nonatomic) IBOutlet UIButton *completeBt;
//倒计时定时器
@property(nonatomic,strong) NSTimer *timer;
//倒计时
@property(nonatomic,assign) int remainTime;
@end

@implementation AHMobilePhoneLoginVC

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleDefault;
//};
//
//-(BOOL)prefersStatusBarHidden{
//    return NO;
//}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//     [self setNeedsStatusBarAppearanceUpdate];
//}

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view from its nib.
}

//更新UI细节
-(void)setUpView{
    _getCodeBt.layer.cornerRadius = 2.5;
    _getCodeBt.layer.masksToBounds = YES;
    _getCodeBt.layer.borderColor = [UIColor blackColor].CGColor;
    _getCodeBt.layer.borderWidth = 1.5;
    [_completeBt addCornerRadius:4.5];
    self.view.backgroundColor = UIColorFromRGB(0xecedef);
    [self setHoldTitle:@"手机登录"];
    [self.phoneNumberTF becomeFirstResponder];
    self.phoneNumberTF.delegate = self;
}

//获取验证码按钮事件
- (IBAction)bt_getCodeAction:(UIButton*)sender {
    if ([NSString testStringIsPhoneNumber:self.phoneNumberTF.text]) {
        if (!_timer) {
            _remainTime = 121;
            _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(setUpTime:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
            _timer.fireDate = [NSDate distantPast];
            [_timer fire];
            [self getCode];
        }
    }else{
        AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"请输入正确的手机号码" cancelBtnTitle:@"知道了" cancelAction:^{
             [_phoneNumberTF becomeFirstResponder];
        }];
        [alertView showAlert];
       
    }
    
}

//计时器时间
-(void)setUpTime:(NSTimer*)sender{
    _remainTime--;
    if (_remainTime> 0) {
        NSString *title = [NSString stringWithFormat:@"%ds后重新获取",_remainTime];
        [_getCodeBt setTitle:title forState:UIControlStateNormal];
        UIColor *titleColor = UIColorFromRGB(0Xbdbdbd);
        [_getCodeBt setTitleColor:titleColor forState:UIControlStateNormal];
        _getCodeBt.backgroundColor = UIColorFromRGB(0Xe7e7e7);
        _getCodeBt.layer.borderWidth = 0;
    }else{
        _remainTime = 121;
        [_timer invalidate];
        _timer = nil;
        [_getCodeBt setTitle:@"重新获取" forState:UIControlStateNormal];
        [_getCodeBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _getCodeBt.backgroundColor = [UIColor clearColor];
        _getCodeBt.layer.borderWidth = 1.5;
    }
}

//完成
- (IBAction)bt_completeAction:(UIButton *)sender {
    //验证手机号
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    //验证手机号
    if ([NSString testStringIsPhoneNumber:self.phoneNumberTF.text]) {
        //验证验证码是否为空
        if (![self TestCode]) {
            return;
        }
        //验证验证码
//        [SMSSDK commitVerificationCode:self.codeTF.text phoneNumber:self.phoneNumberTF.text     zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
//            
//            {
//                if (!error)
//                {
                    //绑定手机号码
                    [self BindingMobilePhoneNumber];
                    //登录
                    [self login];
//                    
//                }
//                else
//                {
//                    LOG(@"错误信息:%@",error);
//                }
//            }
//        }];
    }else{
        AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"请输入正确的手机号码" cancelBtnTitle:@"知道了" cancelAction:^{
              [_phoneNumberTF becomeFirstResponder];
        }];
        [alertView showAlert];
      
    }
    
}

//是否是用来绑定手机号
-(void)BindingMobilePhoneNumber{
    if (_isUsedToBindingMobilePhoneNumber) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)login{
    if (_isUsedToBindingMobilePhoneNumber) {
        return;
    }
    if ([AHNetworkMonitor monitorNetwork].networkStatus == NotReachable) {
        AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"网络异常" title:@"检查一下你的网络环境是否正常，如果出现信号异常也可以代开飞行模式后再还原网络，是否可以修复。" cancelBtnTitle:@"知道了" cancelAction:nil];
        alertView.alertType = AHAlertViewNoNetwork;
        [alertView showAlert];
        return;
    }
    //登录
    UsersLoginRequest *userLog = [[UsersLoginRequest alloc]init];
    userLog.channelUuid = @"cd15fe10-15d8-11e7-a585-00155d010713";
    userLog.telephone = self.phoneNumberTF.text;
    userLog.telephoneVerifyCode = self.codeTF.text;
    userLog.field = 0 ;
    [[AHTcpApi shareInstance] requsetMessage:userLog classSite:@"Users" completion:^(id response, NSString *error) {
        //每次根据response进行类模型 进行操作并执行其他
        UsersLoginResponse *logrepsonse = (UsersLoginResponse *)response;
        if (logrepsonse.result == UsersLoginResponse_UserLoginResult_UserLoginResultSucceeded) {
            [[AHPersonInfoManager manager] setWithJson:logrepsonse];
            AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
            infoModel.isLoginStatus = YES;
            [[AHPersonInfoManager manager]setInfoModel:infoModel];
            [self LineToGameSocket:logrepsonse.userId token:logrepsonse.token];
            if (logrepsonse.isFirstLogin) {
                [self pushEditeMyInfo];
            }else{
                [AppDelegate setTabBarControllerBecomeRootViewController];
            }
            [_timer invalidate];
            _timer = nil;
            
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


//获得验证码
-(void)getCode{
    if ([NSString testStringIsPhoneNumber:self.phoneNumberTF.text]) {
        //获取验证码
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumberTF.text
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error){
                                         if (!error) {
                                             LOG(@"获取验证码成功");
                                         } else {
                                             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                             [_codeTF becomeFirstResponder];
                                         }}];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [_phoneNumberTF becomeFirstResponder];
    }
}

//验证手机验证码是否为空
-(BOOL)TestCode{
    if ( _codeTF.text.length == 4) {
        return YES;
    }else{
        AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"请输入4位验证码" cancelBtnTitle:@"知道了" cancelAction:nil];
        [alertView showAlert];
        [_codeTF becomeFirstResponder];
        return NO;
    }
}

- (void)pushEditeMyInfo{
    AHEditeMyInfoVC *editMyInfoVC = [[AHEditeMyInfoVC alloc]initWithNibName:@"AHEditeMyInfoVC" bundle:nil];
    [self.navigationController pushViewController:editMyInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length+range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length]+[string length] -range.length;
    return newLength <= 11;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
