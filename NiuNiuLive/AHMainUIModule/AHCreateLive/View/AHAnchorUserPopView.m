//
//  AHAnchorUserPopView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
// 可以设为场控 踢人 禁言等userPopView

#import "AHAnchorUserPopView.h"
#import "Users.pbobjc.h"
#import "UIImage+extension.h"
#import "AHPersonInfoVC.h"
#import "AreaControl.pbobjc.h"

@interface AHAnchorUserPopView ()
@property (weak, nonatomic) IBOutlet UIButton *tirenBtn;
@property (weak, nonatomic) IBOutlet UIButton *courtyardBtn;//场控
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIView *userBackView;
@property (weak, nonatomic) IBOutlet UIView *homebackView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageV;
@property (weak, nonatomic) IBOutlet UILabel *userBriefLb;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *userIdLb;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLb;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageV;
@end

@implementation AHAnchorUserPopView

+ (id)shareLiveUserPopView{

    return [[NSBundle mainBundle] loadNibNamed:@"AHAnchorUserPopView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self.attentionBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] imageSize:CGSizeMake(5, 5)] forState:UIControlStateNormal];
    [self.attentionBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor] imageSize:CGSizeMake(5, 5)] forState:UIControlStateSelected];
    self.userImageV.layer.cornerRadius = self.userImageV.height *0.5;
    [self setAllCorner:self.tirenBtn];
    [self setAllCorner:self.courtyardBtn];
    [self setAllCorner:self.attentionBtn];
    [self setAllCorner:self.homebackView];
}

- (void)setAllCorner:(UIView *)cornerView{
    
    cornerView.layer.cornerRadius = 2.0;
    cornerView.layer.masksToBounds = YES;
    cornerView.layer.borderColor = [UIColor blackColor].CGColor;
    cornerView.layer.borderWidth = 1.0;
}

- (void)showAnchorUserPopViewUserid:(NSString *)userid{
    // 1.获得最上面的窗口
    _userId = userid;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 2.转化
    self.frame = window.bounds;
    
    [window addSubview: self];
    
    [self getUserInfoFromUserid:userid];
}

//获得
- (void)getUserInfoFromUserid:(NSString *)userid{
    
    UsersGetInfoRequest *userInfoReq = [[UsersGetInfoRequest alloc]init];
    userInfoReq.userId = userid;
    
    [[AHTcpApi shareInstance]requsetMessage:userInfoReq classSite:UsersClassName completion:^(id response, NSString *error) {
        
        UsersGetInfoResponse *userInfoRes = (UsersGetInfoResponse*)response;
        
        if (userInfoRes.result == 0) {
            
            [self updataUserPopViewFor:userInfoRes];
        }
    }];
}

- (void)updataUserPopViewFor:(UsersGetInfoResponse *)userInfoRes{
    
    [self.userImageV sd_setImageWithURL:[NSURL URLWithString:userInfoRes.avatarURL] placeholderImage:[UIImage imageNamed:@"logo_500.jpg"]];
    self.userNickNameLb.text = userInfoRes.nickName;
    self.userIdLb.text = userInfoRes.showId;
    self.userLevelLb.text = [NSString stringWithFormat:@"LV%d",userInfoRes.level.level];
    self.userBriefLb.text= userInfoRes.brief;
    NSString *imageName = userInfoRes.gender==1?@"icon_weiwei_man":@"icon_weiwei_woman";
    self.genderImageV.image = [UIImage imageNamed:imageName];
    self.attentionBtn.selected = userInfoRes.isLiked;
}


- (void)dismissAnchorView{

    [self removeFromSuperview];
}

//关注
- (IBAction)attentionClick:(id)sender {
    
    UIButton *attenBtn = (UIButton *)sender;
   
   //  已关注 点击取消关注
    if (attenBtn.selected) {
        UsersUnlikeUserRequest *unLikeUserReq = [[UsersUnlikeUserRequest alloc]init];
        unLikeUserReq.userId = self.userId;
        [[AHTcpApi shareInstance]requsetMessage:unLikeUserReq classSite:UsersClassName completion:^(id response, NSString *error) {
            UsersUnlikeUserResponse *unLikeRes = (UsersUnlikeUserResponse *)response;
            if (unLikeRes.result == 0) {
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
                
            }
        }];
    }
    attenBtn.selected = !attenBtn.selected;
    
    [self dismissAnchorView];
}

//设为场控
- (IBAction)courtyarClick:(id)sender {
    
    AreaControlAuthorizationRequest *areaAuthReq = [[AreaControlAuthorizationRequest alloc]init];
    areaAuthReq.userId = self.userId;
    areaAuthReq.tobe = YES;
    [[AHTcpApi shareInstance]requsetMessage:areaAuthReq classSite:AreaControlClassName completion:^(id response, NSString *error) {
        AreaControlAuthorizationResponse *authorRes = (AreaControlAuthorizationResponse *)response;
        LOG(@"%@",authorRes);
        
    }];
    
     [self dismissAnchorView];
}

//踢人
- (IBAction)tirenClick:(id)sender {
    
    AreaControlKickOutRequest *kickOutReq = [[AreaControlKickOutRequest alloc]init];
    kickOutReq.userId = self.userId;
    kickOutReq.tobe = YES;
    [[AHTcpApi shareInstance]requsetMessage:kickOutReq classSite:AreaControlClassName completion:^(id response, NSString *error) {
        
        AreaControlKickOutResponse *kickoutRes = (AreaControlKickOutResponse *)response;
        
        
    }];
    
     [self dismissAnchorView];
}

//主页
- (IBAction)homePageClick:(id)sender {
    
     [self dismissAnchorView];
    //进入主页
    AHPersonInfoVC *personVC = [[AHPersonInfoVC alloc]initWithUserId:self.userId];
    
    [[AppDelegate getNavigationTopController].navigationController pushViewController:personVC animated:YES];
}

//禁言
- (IBAction)jinyanClick:(id)sender {
    
    UIButton *jinyanBtn = (UIButton *)sender;
    AreaControlBannedRequest *bannedReq = [[AreaControlBannedRequest alloc]init];
    bannedReq.userId = self.userId;
    bannedReq.tobe = YES;
    [[AHTcpApi shareInstance]requsetMessage:bannedReq classSite:AreaControlClassName completion:^(id response, NSString *error) {
        
        AreaControlBannedResponse *bannedRes = (AreaControlBannedResponse *)response;
        
    }];
    
    jinyanBtn.selected = !jinyanBtn.selected;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if ([touch.view isDescendantOfView:self.userBackView]) {
        return;
    }
    [self dismissAnchorView];
}

- (void)dealloc{

    LOG(@"%s",__func__);
}

@end
