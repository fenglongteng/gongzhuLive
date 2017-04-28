//
//  AHFriendSetVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHFriendSetVC.h"

@interface AHFriendSetVC ()
//关注开关
@property (weak, nonatomic) IBOutlet UISwitch *attentionSwitch;
//id Label
@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
//copy按钮
@property (weak, nonatomic) IBOutlet UIButton *scopyBt;
//userid
@property(nonatomic,strong)AHPersonInfoModel *infoModel;
//是否特别关注
@property(nonatomic,assign)BOOL isSpecialAttention;
//举报view
@property (weak, nonatomic) IBOutlet UIView *reportView;
//userid
@property(nonatomic,strong)NSString *userId;

@end

@implementation AHFriendSetVC

-(BOOL)fd_prefersNavigationBarHidden{
    return NO;
}

-(instancetype)initWithUserId:(NSString*)userId  AndPersonInfo:(AHPersonInfoModel*)infoModel AndSpecialAttention:(BOOL)isSpecialAttention{
    if ([super init]) {
        self.infoModel = infoModel;
        self.isSpecialAttention = isSpecialAttention;
        self.userId = userId;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHoldTitle:@"好友设置"];
    self.identifierLabel.text = self.infoModel.showId;
    [self.attentionSwitch setOn: self.isSpecialAttention];
    [_scopyBt addBorderColor:UIColorFromRGB(0xfed215) andwidth:1 andCornerRadius:12.5];
    [self.reportView addTarget:self action:@selector(bt_report:)];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)bt_copyID:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"已复制到系统剪贴板"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.identifierLabel.text];
}

-(void)bt_report:(id)sender{
    AHAlertView *alertView = [[AHAlertView alloc]initSetAlertViewTitle:@"温馨提示" detailString:@"您确定是否要举报" AndLeftBt:@"确定" AndRight:@"取消" cancelAction:^{
        UsersAccusationOtherRequest *reportRequest = [[UsersAccusationOtherRequest alloc]init];
        reportRequest.otherId = self.userId;
        [[AHTcpApi shareInstance]requsetMessage:reportRequest classSite:UsersClassName completion:^(id response, NSString *error) {
            UsersAccusationOtherResponse *reportResponse = response;
            if (reportResponse.result == 0) {
                AHAlertView *alertView =   [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"举报成功" cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
            }else{
                AHAlertView *alertView =   [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"很抱歉举报失败" cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
            }
        }];
        
    } settingAction:^{
        
        
    }];
    
    [alertView showAlert];
}

//改变关注状态
- (IBAction)changeAttentionType:(UISwitch *)sender {
    UsersChangeLikeStateRequest *changeLikeStatus = [[UsersChangeLikeStateRequest alloc]init];
    changeLikeStatus.state = sender.isOn?UsersChangeLikeStateRequest_State_Special: UsersChangeLikeStateRequest_State_Normal;
    changeLikeStatus.userId = self.userId;
    [[AHTcpApi shareInstance]requsetMessage:changeLikeStatus classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersChangeLikeStateResponse *changeStatusRespose = response;
        if (changeStatusRespose.result != 0) {
            [sender setOn:!sender.isOn];
        }else{
           
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
