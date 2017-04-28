//
//  AHLiveAnchorView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLiveAnchorView.h"
#import "AHuserImageView.h"
#import "Rooms.pbobjc.h"
#import "NSString+Tool.h"

@interface AHLiveAnchorView()
@property (weak, nonatomic) IBOutlet UIView *userBackView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageV;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *charmView;

@property (weak, nonatomic) IBOutlet UILabel *charmLabel;//魅力
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;//关注
@property (weak, nonatomic) IBOutlet UILabel *usernameLb;
@property (weak, nonatomic) IBOutlet UILabel *popularityLb;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentionBtnWidth;

@property (nonatomic,strong)Room *roominfo;

@end

@implementation AHLiveAnchorView

+ (instancetype)liveAnchorView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self makeViewCornerRadius:self.userBackView];
    [self makeViewCornerRadius:self.userImageV];
    [self makeViewCornerRadius:self.attentionBtn];
    [self makeViewCornerRadius:self.charmView];
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.userBackView addGestureRecognizer:tapClick];
    UITapGestureRecognizer *tapContribute = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contributeTap:)];
    [self.charmView addGestureRecognizer:tapContribute];
    
    //关注了主播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeUser:) name:kNotifityLikeUser object:nil];
    //取消了关注主播
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unLikeUser:) name:kNotifityUnLikeUser object:nil];
}

- (void)setRoomId:(NSString *)roomId{
    _roomId  = roomId;
    RoomsGetRoomInfoRequest *roomInfoReq = [[RoomsGetRoomInfoRequest alloc]init];
    roomInfoReq.userId = roomId;
    [[AHTcpApi shareInstance]requsetMessage:roomInfoReq classSite:RoomClassName completion:^(id response, NSString *error) {
        RoomsGetRoomInfoResponse *roomRes = (RoomsGetRoomInfoResponse *)response;
        self.roominfo = roomRes.room;
        [self showAnchorInfo:roomRes.room];
        [self createIntoLiveUserImage:roomRes.room.audienceArray];
    }];
}

- (void)showAnchorInfo:(Room*)model{
    
    [self.userImageV sd_setImageWithURL:[NSString getImageUrlString:model.avatar] placeholderImage:[UIImage imageNamed:@"image_gongzhuuser"]];
    self.usernameLb.text = model.nickName;
    self.popularityLb.text = [NSString stringWithFormat:@"%lld 人气",model.audienceTotalCount];
    self.charmLabel.text = [NSString stringWithFormat:@"魅力%lld",model.charmValue];
    if (model.isLiked) {
        self.attentionBtnWidth.constant = 0;
        self.attentionBtn.hidden = YES;
    }
    if (self.isBanker) {
        self.attentionBtnWidth.constant = 0;
        self.attentionBtn.hidden = YES;
    }
}

- (void)createIntoLiveUserImage:(NSMutableArray<Room_Audience*> *)roomArr{

    for (int i = 0; i < roomArr.count; i++) {
        
        AHuserImageView *userImageV = [[AHuserImageView alloc]initWithFrame:CGRectMake(i*36+5*i, 0, 36, 36)];
        
        userImageV.roomAudieModel = [roomArr objectAtIndex:i];

        [self.scrollView addSubview:userImageV];
    }
    self.scrollView.contentSize = CGSizeMake(40*roomArr.count, 0);
}

//贡献榜
- (void)contributeTap:(UITapGestureRecognizer *)tap{

    if (self.clickContributeShowBlock) {
        self.clickContributeShowBlock();
    }
    
}

- (void)tap:(UITapGestureRecognizer *)tapGesture{

    NSString* userid = _roomId;
    if (userid) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"userId" : userid}];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBankerClickUser object:nil userInfo:@{@"userId" : userid}];
    }
}

//关闭直播
- (IBAction)closeLive:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:CloseLive object:nil];
    if (self.closeLiveBlock) {
        self.closeLiveBlock();
    }
}

//关注了主播
- (void)likeUser:(NSNotification *)notify{
    NSString *userid = [notify.userInfo objectForKey:@"userid"];
    if ([userid isEqualToString:self.roomId]) {
        self.attentionBtnWidth.constant = 0;
        self.attentionBtn.hidden = YES;
    }
}

//取消了关注
- (void)unLikeUser:(NSNotification *)notify{
    
    NSString *userid = [notify.userInfo objectForKey:@"userid"];
    if ([userid isEqualToString:self.roomId]) {
        self.attentionBtnWidth.constant = 46;
        self.attentionBtn.hidden = NO;
    }
}

//关注
- (IBAction)attentClick:(id)sender {
    
    UsersLikeUserRequest *likeUserReq = [[UsersLikeUserRequest alloc]init];
    GPBStringBoolDictionary *boolDickies = [GPBStringBoolDictionary dictionaryWithBool:NO forKey:self.roomId];
    likeUserReq.users = boolDickies;
    
    [[AHTcpApi shareInstance]requsetMessage:likeUserReq classSite:UsersClassName completion:^(id response, NSString *error) {
        self.attentionBtnWidth.constant = 0;
        self.attentionBtn.hidden = YES;
    }];
}

- (void)makeViewCornerRadius:(UIView *)view{
    view.layer.cornerRadius = view.height *0.5;
    view.layer.masksToBounds = YES;
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"%s",__func__);
}

@end
