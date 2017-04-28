//
//  AHPreferenceTableViewController.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPreferenceTableVC.h"
#import "UIView+ST.h"
#import "STPickerSingle.h"
#import "LBShareController.h"
#import "AHLocationManager.h"
#import "AHBlackListVC.h"
#import "AHAddressListViewController.h"
#import "AHPersonInfoManager.h"
#import "YYModel.h"
#import "NSObject+AHUntil.h"
#import "NSString+Tool.h"
#import "AHMobilePhoneLoginVC.h"
#import "WKWebViewController.h"
const NSInteger constellationViewTag = 200;
const NSInteger SexViewTag = 300;
@interface AHPreferenceTableVC ()<STPickerSingleDelegate>
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
//昵称identifier
@property (weak, nonatomic) IBOutlet UILabel *nickNameIdentifier;
//copy按钮
@property (weak, nonatomic) IBOutlet UIButton *copybutton;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
//性别名字
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
//城市
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
//星座
@property (weak, nonatomic) IBOutlet UILabel *constellationLabel;
//缓存
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
//绑定手机
@property (weak, nonatomic) IBOutlet UILabel *phoneBindingLabel;
//手机号码
@property (weak, nonatomic) IBOutlet UILabel *phnoneNumberLabel;
//退出登录
@property (weak, nonatomic) IBOutlet UIButton *logoutBt;
//分享
@property (nonatomic,strong) LBShareController *shareView;
//分享图片
@property (nonatomic,strong) UIImage *shareImg;
//分享文字
@property (nonatomic,copy) NSString *shareText;
//仅仅接受特别关心的
@property (weak, nonatomic) IBOutlet UISwitch *onlyAceptAttentionSwitch;
//开通通知声音
@property (weak, nonatomic) IBOutlet UISwitch *openNotificationSoundSwitch;
//通知隐藏聊天内容
@property (weak, nonatomic) IBOutlet UISwitch *NotificationHideChatContentSwitch;

@end

@implementation AHPreferenceTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setUpView];
}

-(void)setUpView{
    [self setHoldTitle:@"设置中心"];
    //城市定位
    AHLocationManager *locationManager = [AHLocationManager sharedInstance];
    self.cityLabel.text = [NSString stringWithFormat:@"%@%@",locationManager.provinces,locationManager.city];
    [_copybutton addBorderColor:UIColorFromRGB(0xfed215) andwidth:1 andCornerRadius:12.5];
    [_logoutBt addCornerRadius:5];
    AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
    _nickNameIdentifier.text = [NSString stringWithFormat:@"%@",infoModel.showId];
    _nicknameLabel.text = @"牛牛直播";
    _userNameLabel.text = infoModel.nickName;
    _constellationLabel.text = infoModel.constellation;
    _sexLabel.text = infoModel.genderString;
    _cityLabel.text = infoModel.cityName;
    //手机号
    NSString *bindingString  = nil;
    if (infoModel.isTelephoneBinding && infoModel.telephone.length>0) {
        bindingString = @"手机号绑定(已绑定)";
        _phoneBindingLabel.text = bindingString;
        _phnoneNumberLabel.text = infoModel.telephone;
    }else{
        bindingString = @"手机号绑定(未绑定)";
        _phoneBindingLabel.text = bindingString;
        _phnoneNumberLabel.text = @"";
    }
    //配置文件
    NSDictionary *setDic = [infoModel.settings getJson];
    [self.onlyAceptAttentionSwitch setOn:[setDic[OnlyAcceptSpecialAttention] boolValue]];
    [self.openNotificationSoundSwitch setOn:[setDic[OpenTheMessageNotificationSound] boolValue]];
    [self.NotificationHideChatContentSwitch setOn:[setDic[InformHideChatContent] boolValue]];
    //缓存大小
    [self getCash];
}

//退出登录
- (IBAction)bt_logoutAction:(id)sender{
    AHAlertView *alertView = [[AHAlertView alloc]initSetAlertViewTitle:@"温馨提示" detailString:@"您确定是否要退出" AndLeftBt:@"确定" AndRight:@"取消" cancelAction:^{
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
            }else{
                AHAlertView *alertView =  [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"非常抱歉，退出登录失败" cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
            }
        }];
    } settingAction:^{
        
        
    }];
    [alertView showAlert];
}

//复制identifier
- (IBAction)bt_copyNickNameAcion:(id)sender {
    AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"已复制到系统剪贴板" cancelBtnTitle:@"知道了" cancelAction:nil];
    [alertView showAlert];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.nickNameIdentifier.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//仅仅接受关系的通知
- (IBAction)onlyOnlyacceptattentionOnlyacceptattentiononlyAcceptAttentionNotic:(UISwitch *)sender {
    [self uploadSetingsWith:sender];
}

//打开消息通知声音
- (IBAction)openMessageVoice:(UISwitch *)sender {
    [self uploadSetingsWith:sender];
}

//通知隐藏聊天内容
- (IBAction)noticeHideChatContent:(UISwitch *)sender {
    [self uploadSetingsWith:sender];
}

//上传同步配置
-(void)uploadSetingsWith:(UISwitch*)sender{
    AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
    NSMutableDictionary *setDic = [infoModel.settings getJson];
    setDic = [setDic mutableCopy];
    if (!setDic) {
        setDic = [NSMutableDictionary dictionary];
    }
    if (sender.tag == 300) {
        [setDic setValue:@(sender.isOn) forKey:OnlyAcceptSpecialAttention];
    }else if(sender.tag == 400){
        [setDic setValue:@(sender.isOn) forKey:OpenTheMessageNotificationSound ];
    }else if(sender.tag == 500){
        [setDic setValue:@(sender.isOn) forKey:InformHideChatContent];
    }
    NSString *setingString = [setDic yy_modelToJSONString];
     infoModel.settings = setingString;
    //网络同步
    UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
    editeInfoRequst.settings = setingString;
      [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:NO];
    [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
        UsersAlterInfoResponse *editeRespose = response;
        if (editeRespose.result == 0 ) {
              [[AHPersonInfoManager manager]setInfoModel:infoModel];
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"您的设置未能同步到网络" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];
}

//分享UI
- (void)showShareView{
    if (self.shareView) {
        [self.shareView.view removeFromSuperview];
        self.shareView = nil;
    }
    self.shareView =  [LBShareController showShareViewWithMessage:@"分享给自己的朋友"];
    self.shareView.beViewController = self;
    self.shareView.shareImg = [UIImage imageNamed:@"1080-share.jpg"];
    self.shareView.shareText = @"https://itunes.apple.com/cn/app/jian-xing-tian-qi/id1100986251?mt=8";
    [self.shareView showShareViewAnimation];
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 5;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 5;
//            break;
//        case 2:
//            return 3;
//            break;
//        case 3:
//            return 5;
//            break;
//        case 4:
//            return 2;
//            break;
//    }
//    return 0;
//}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    if (section == 0 || section == 1) {
        view.frame = CGRectMake(0, 0, screenWidth, 25);
    }else{
        view.frame = CGRectMake(0, 0, screenWidth, 10);
    }
    view.backgroundColor =  UIColorFromRGB(0xecedef);
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 25;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==4 && indexPath.row == 2) {
        return 100;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 ) {
        //选择性别
        if (indexPath.row == 1) {
            [self.view endEditing:YES];
            STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
            pickerSingle.tag = SexViewTag;
            NSArray * tourDuringTimeArray =@[@"男",@"女"];
            [pickerSingle setArrayData:tourDuringTimeArray];
            [pickerSingle setTitle:@""];
            pickerSingle.widthPickerComponent = 100;
            [pickerSingle setContentMode:STPickerContentModeBottom];
            [pickerSingle setDelegate:self];
            [pickerSingle show];
        }else if (indexPath.row == 2){
            //城市定位
            [[AHLocationManager sharedInstance] startLocation];
            
        }else if ( indexPath.row == 3){
            //选择星座
            NSString *constellationString = @"魔羯座,水瓶座,双鱼座,白羊座,金牛座,双子座,巨蟹座,狮子座,处女座,天秤座,天蝎座,射手座,魔羯座";
            NSArray*constellationArray = [constellationString componentsSeparatedByString:@","];
            [self.view endEditing:YES];
            STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
            pickerSingle.tag = constellationViewTag;
            [pickerSingle setArrayData:constellationArray];
            [pickerSingle setTitle:@""];
            pickerSingle.widthPickerComponent = 100;
            [pickerSingle setContentMode:STPickerContentModeBottom];
            [pickerSingle setDelegate:self];
            [pickerSingle show];
            
        }
        
    }else if (indexPath.section == 3){
        switch (indexPath.row ) {
            case 0:{
                //分享软件给好友
                [self showShareView];
            }
                
                break;
            case 1:
            {
                //意见反馈 跳转微信公众号
                
                
            }
                break;
            case 2:
            {
                //设置隐私权限 跳转官网
                WKWebViewController *wkVC = [[WKWebViewController alloc]init];
                [wkVC loadWebURLSring:@"https://www.baidu.com"];
                [self.navigationController pushViewController:wkVC animated:YES];
                
            }
                break;
            case 3:
            {
                //清空文件缓存
                NSMutableArray *array = [NSMutableArray array];
                [[AHPersonInfoManager manager]setLikeMeArray:array];
                [[AHPersonInfoManager manager]setMyLikeArray:array];
                //图片缓存
                [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                    [self getCash];
                }];
            }
                break;
            case 4:
            {
                //关于我们 也是个网页
//                [NSObject pushFromVC:self toVCWithName:@"AHAboutUsVC" InTheStoryboardWithName:@"AHStoryboard"];
                WKWebViewController *wkVC = [[WKWebViewController alloc]init];
                [wkVC loadWebURLSring:@"https://www.baidu.com"];
                [self.navigationController pushViewController:wkVC animated:YES];
            }
                break;
        }
        
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            //手机号绑定
                AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
            if (infoModel.isTelephoneBinding && infoModel.telephone.length>0) {
              
            }else{
                AHMobilePhoneLoginVC *mobilePhoneLoginVC = [[AHMobilePhoneLoginVC alloc]init];
                [self.navigationController pushViewController:mobilePhoneLoginVC animated:YES];
            }
            
            
//            AHAddressListViewController *addressListVC = [[AHAddressListViewController alloc]initWithNibName:@"AHAddressListViewController" bundle:nil];
//            [self.navigationController pushViewController:addressListVC animated:YES];
        }else{
            //黑名单管理
//            AHBlackListVC *blackListVC = [[AHBlackListVC alloc]init];
//            [self.navigationController pushViewController:blackListVC animated:YES];
        }
    }
}

//得到缓存
-(void)getCash{
    SDImageCache *imageCaches = [SDImageCache sharedImageCache];
    NSUInteger cashSize  =[imageCaches getSize]/1000.0/1000.0;
    _cacheLabel.text  = [NSString stringWithFormat:@"清空本地缓存（%ldM）",(unsigned long)cashSize];
}

#pragma mark————————————性别、星座选择代理————————————————
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    if (pickerSingle.tag == SexViewTag) {
        
        Gender gender = 0;
        if ([selectedTitle isEqualToString:@"男"]) {
            gender = 1;
        }else if([selectedTitle isEqualToString:@"女"]){
            gender = 2;
        }else{
            gender = 0;
        }
        if (gender != [[AHPersonInfoManager manager]getInfoModel].gender) {
            UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
            editeInfoRequst.gender = gender;
              [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:YES];
            [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
                UsersAlterInfoResponse *editeRespose = response;
                if (editeRespose.result == 0 ) {
                    AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
                    infoModel.gender = gender;
                    _sexLabel.text = selectedTitle;
                    [[AHPersonInfoManager manager]setInfoModel:infoModel];
                }else{
                    AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:editeRespose.message cancelBtnTitle:@"知道了" cancelAction:nil];
                    [alertView showAlert];
                }
            }];
            
        }
        
    }else{
        TasksRequest_ConstellationParams *constellationTask = [[TasksRequest_ConstellationParams alloc]init];
        constellationTask.constellation = selectedTitle;
        [[AHTcpApi shareInstance]requsetMessage:constellationTask classSite:TasksClssName completion:^(id response, NSString *error) {
            LOG(@"星座：%@",response);
        }];
        if (![selectedTitle isEqualToString: [[AHPersonInfoManager manager]getInfoModel].constellation]) {
//            UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
//            editeInfoRequst.field = 32;
//            [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
//                UsersAlterInfoResponse *editeRespose = response;
//                if (editeRespose.result == 0 ) {
                    AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
                    infoModel.constellation = selectedTitle;
                    [[AHPersonInfoManager manager]setInfoModel:infoModel];
                    _constellationLabel.text = selectedTitle;
//                }else{
//                    AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:editeRespose.message cancelBtnTitle:@"知道了" cancelAction:nil];
//                    [alertView showAlert];
//                }
//            }];
            
        }
        
    }
    [self.tableView reloadData];
    
}



/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
