//
//  AHLiveUserPopView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLiveUserPopView.h"
#import "AHPersonInfoVC.h"
#import "Users.pbobjc.h"
#import "UIImage+extension.h"
#import "NSString+Tool.h"

@interface AHLiveUserPopView ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageV;
@property (weak, nonatomic) IBOutlet UILabel *usernameLb;
@property (weak, nonatomic) IBOutlet UILabel *userIdLb;
@property (weak, nonatomic) IBOutlet UILabel *userLvLb;
@property (weak, nonatomic) IBOutlet UILabel *userIntorLb;
@property (weak, nonatomic) IBOutlet UIButton *attentBtn;//关注
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;//主页
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;//举报
@property (weak, nonatomic) IBOutlet UIImageView *genderImageV;//性别
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentBtnLayoutWidth;

@end

@implementation AHLiveUserPopView

+ (id)LiveUserPopView{

     return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self makeImageViewClips];
    [self.attentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] imageSize:CGSizeMake(5, 5)] forState:UIControlStateNormal];
    [self.attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self.attentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor] imageSize:CGSizeMake(5, 5)] forState:UIControlStateSelected];
    [self makeLayerBorderWidth:self.homePageBtn];
    [self makeLayerBorderWidth:self.attentBtn];
    [self makeLayerBorderWidth:self.reportBtn];
    
}

- (void)setUserId:(NSString *)userId{
    _userId = userId;
    NSString * ownerId = [[[AHPersonInfoManager manager] getInfoModel] userId];
    if ([userId isEqualToString:ownerId]) {
        self.attentBtn.hidden = YES;
        self.attentBtnLayoutWidth.constant = 20;
        self.reportBtn.hidden = YES;
    }
    UsersGetInfoRequest *userInfoReq = [[UsersGetInfoRequest alloc]init];
    userInfoReq.userId = userId;
    [[AHTcpApi shareInstance]requsetMessage:userInfoReq classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersGetInfoResponse *userInfoRes = (UsersGetInfoResponse*)response;
        if (userInfoRes.result == 0) {
            
            [self updataUserPopViewFor:userInfoRes];
        }
    }];
    
}

- (void)updataUserPopViewFor:(UsersGetInfoResponse *)userInfoRes{

    [self.userImageV sd_setImageWithURL:[NSString getImageUrlString:userInfoRes.avatarURL] placeholderImage:[UIImage imageNamed:@"logo_500.jpg"]];
    self.usernameLb.text = userInfoRes.nickName;
    self.userIdLb.text = userInfoRes.showId;
    self.userLvLb.text = [NSString stringWithFormat:@"LV%d",userInfoRes.level.level];
    self.userIntorLb.text= userInfoRes.brief;
    NSString *imageName = userInfoRes.gender==1?@"icon_weiwei_man":@"icon_weiwei_woman";
    self.genderImageV.image = [UIImage imageNamed:imageName];
    self.attentBtn.selected = userInfoRes.isLiked;
    
}

- (void)makeImageViewClips{
    self.userImageV.layer.cornerRadius = self.userImageV.height*0.5;
    self.userImageV.userInteractionEnabled = YES;
    self.userImageV.layer.masksToBounds = YES;
}

- (void)makeLayerBorderWidth:(UIView *)view{
    view.layer.borderWidth = 1.5;
    view.layer.cornerRadius = 1.0;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.masksToBounds = YES;
}

//关注
- (IBAction)attentButton:(id)sender {
    
    if (self.closeBlock) {
        self.closeBlock();
    }
    //调关注接口
    UIButton *attentBtn = (UIButton *)sender;
    //已关注 点击取消关注
    if (attentBtn.selected) {
        UsersUnlikeUserRequest *unLikeUserReq = [[UsersUnlikeUserRequest alloc]init];
        unLikeUserReq.userId = self.userId;
        [[AHTcpApi shareInstance]requsetMessage:unLikeUserReq classSite:UsersClassName completion:^(id response, NSString *error) {
            UsersUnlikeUserResponse *unLikeRes = (UsersUnlikeUserResponse *)response;
            if (unLikeRes.result == 0) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotifityUnLikeUser object:nil userInfo:@{@"userid":self.userId}];
            }
        }];
    }
    else{ //关注
        UsersLikeUserRequest *likeUserRequest = [[UsersLikeUserRequest alloc]init];
        GPBStringBoolDictionary *boolDic = [GPBStringBoolDictionary dictionaryWithBool:NO forKey:self.userId];
        likeUserRequest.users = boolDic;
        [[AHTcpApi shareInstance]requsetMessage:likeUserRequest classSite:UsersClassName completion:^(id response, NSString *error) {
            UsersLikeUserResponse *liskeUserRespose = (UsersLikeUserResponse*)response;
            if (liskeUserRespose.result == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotifityLikeUser object:nil userInfo:@{@"userid":self.userId}];
                
            }
        }];
    }
    
    attentBtn.selected = !attentBtn.selected;
}

//主页
- (IBAction)userHomePageClick:(id)sender {
    //进入主页
    AHPersonInfoVC *personVC = [[AHPersonInfoVC alloc]initWithUserId:self.userId];
    [[AppDelegate getNavigationTopController].navigationController pushViewController:personVC animated:YES];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

//举报
- (IBAction)reportClick:(id)sender {
    
    AHAlertView *alertView = [[AHAlertView alloc]initSetAlertViewTitle:@"温馨提示" detailString:@"您确定是否举报" AndLeftBt:@"确定" AndRight:@"取消" cancelAction:^{
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
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if ([touch.view isDescendantOfView:self.userbackView]) {
        return;
    }
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)dealloc{

    NSLog(@"%s",__func__);
}

@end
