//
//  openLive.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "openLive.h"
#import "inviteCell.h"
#import "createLiveHeader.h"
#import "AHLiveViewController.h"
#import "FriendModel.h"
#import "AHBankerLiveController.h"
#import "AHLiveSocketManager.h"
#import "AHAlertView.h"


@interface openLive ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *inviteTable;

@property(nonatomic,strong)createLiveHeader * headerView;

//数据源
@property(nonatomic,strong)NSMutableDictionary * friendDic;
//首字母数组
@property(nonatomic,strong)NSArray * firstWord;
//是否是搜索状态
@property(nonatomic,assign)BOOL isSearch;
//搜索结果数组
@property(nonatomic,strong)NSMutableArray * resultArray;
//临时存放首字母数组
@property(nonatomic,strong)NSArray * tempArray;

@property(nonatomic,strong)UIButton * publishBtn;
//搜索时调用
@property(nonatomic,strong)NSMutableArray * searchArray;

//关注我的用户们的id,发送消息调用入，如果没有则不发送消息
@property(nonatomic,strong)NSMutableArray * toUsersArray;

//邀请message
@property(nonatomic,copy)NSString *messageString;

@end

@implementation openLive

-(instancetype)initWithInvitationMessage:(NSString*)messageString{
    if (self = [super init]) {
        _messageString = messageString;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.publishBtn removeFromSuperview];
//    self.publishBtn = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addPopButton];
    self.navigationItem.title = @"发起好友私密直播";
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:1/255.0 alpha:1.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 27.5);
    button.titleLabel.font = [UIFont systemFontOfSize:12.f weight:0.2];
    button.center = CGPointMake(screenWidth - 40, self.navigationController.navigationBar.size.height/2.0);
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 27.5/2.0;
    [button addTarget:self action:@selector(publishLive) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:button];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    _publishBtn = button;
    
    self.inviteTable.delegate = self;
    self.inviteTable.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.inviteTable.rowHeight = 60;
    self.inviteTable.tableFooterView = [[UIView alloc] init];
    self.inviteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.inviteTable.alwaysBounceVertical = YES;
    [self.inviteTable registerNib:[UINib nibWithNibName:@"inviteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"inviteCells"];
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"createLiveHeader" owner:nil options:nil];
    self.headerView = (createLiveHeader *)[nibView objectAtIndex:0];
    [self.headerView initWithHeaderViewFrame:CGRectMake(0, 0, screenWidth, 142)];
    if (self.isCommon == YES) {
        self.headerView.passwordText.userInteractionEnabled = NO;//公开房间不允许编辑
    }
    self.inviteTable.tableHeaderView = self.headerView;
    self.inviteTable.tableFooterView = [[UIView alloc] init];
    
    WeakSelf;
    self.headerView.cancelSearchBlock = ^{
        weakSelf.tempArray = weakSelf.firstWord;
        weakSelf.isSearch = NO;
        [weakSelf.resultArray removeAllObjects];
        [weakSelf.inviteTable reloadData];
    };
    
    self.headerView.changeBlock = ^(NSString * searchStr){
        [weakSelf.resultArray removeAllObjects];
        if (searchStr.length == 0) {
            weakSelf.isSearch = NO;
        }else{
            weakSelf.isSearch = YES;
            for (FriendModel *model in weakSelf.searchArray) {
                NSRange chinese = [model.chineseName rangeOfString:searchStr options:NSCaseInsensitiveSearch];
                NSRange english = [model.englishName rangeOfString:searchStr options:NSCaseInsensitiveSearch];
                if ((chinese.location != NSNotFound && chinese.location == 0) || (english.location != NSNotFound && english.location == 0)) {
                    [weakSelf.resultArray addObject:model];
                }
            }
        }
        [weakSelf.inviteTable reloadData];
    };
    
    //指示器颜色
    self.inviteTable.sectionIndexColor = BYColor(190, 190, 190);
    self.inviteTable.sectionIndexBackgroundColor = [UIColor clearColor];
    self.inviteTable.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    [self initDataSource];

}

- (void)initDataSource{
    
    self.friendDic = [NSMutableDictionary dictionary];
    self.resultArray = [NSMutableArray array];
    self.tempArray = [NSArray array];
    self.searchArray = [NSMutableArray array];
    self.toUsersArray = [NSMutableArray array];
    
    //服务器获取所有关注我的用户的信息
    UsersGetLikeMeUserInfoRequest * userInfo = [[UsersGetLikeMeUserInfoRequest alloc] init];
    userInfo.userId = [[AHPersonInfoManager manager] getInfoModel].userId;
    userInfo.skip = 0;
    userInfo.limit = -1;
    [[AHTcpApi shareInstance] requsetMessage:userInfo classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersGetLikeMeUserInfoResponse * mes = (UsersGetLikeMeUserInfoResponse *)response;
        if (mes.result == Result_Succeeded) {
            if (mes.likeMeUserArray.count > 0) {
                [self initUserDataSourceMessage:mes.likeMeUserArray];
            }
        }
    }];
    
}

- (void)initUserDataSourceMessage:(NSArray *)datasource{
    
    [datasource enumerateObjectsUsingBlock:^(UsersGetLikeMeUserInfoResponse_LikeMeUser * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.nickName || [obj.nickName isEqualToString:@""]) {
            NSString * key = @"";
            FriendModel * model = [[FriendModel alloc] init];
            model.chineseName = obj.nickName;
            model.faceurl = obj.avatar;
            model.labelText = obj.brief;
            model.userid = obj.userId;
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.friendDic[key]];
            [self.searchArray addObject:model];
            [array addObject:model];
            [self.friendDic setObject:array forKey:key];
        }else{
            NSString * key;//索引Key
            FriendModel * model = [[FriendModel alloc] init];
            if (([obj.nickName characterAtIndex:1] > 0x4e00) && ([obj.nickName characterAtIndex:1] < 0x9fff)) {
                key = [[[self transform:obj.nickName] substringToIndex:1] uppercaseString];
                model.englishName = [self transform:obj.nickName];
            }else{
                // 1. 截取字符串
                key = [[obj.nickName substringToIndex:1] uppercaseString];
            }
            model.chineseName = obj.nickName;
            model.faceurl = obj.avatar;
            model.labelText = obj.brief;
            model.userid = obj.userId;
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.friendDic[key]];
            [self.searchArray addObject:model];
            [array addObject:model];
            [self.friendDic setObject:array forKey:key];
        }
    }];
    //关联并排序
    self.firstWord = [self.friendDic.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.tempArray = self.firstWord;
    [self.inviteTable reloadData];
}

  //创建房间 连接直播服务器
- (void)publishLive{
    if (self.headerView.passwordText.text.length <= 0 && self.isCommon == NO) {
        AHAlertView * alert = [[AHAlertView alloc] initAlertViewReminderTitle:@"提示" title:@"私密直播必须设置密码" cancelBtnTitle:@"确定" cancelAction:^{
        }];
        [alert showAlert];
        return;
    }
    RoomsCreateRoomRequest *createRoomRequest = [[RoomsCreateRoomRequest alloc]init];
    createRoomRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:createRoomRequest classSite:RoomClassName completion:^(id response, NSString *error) {
        RoomsCreateRoomResponse *createRoomResponse = response;
        if (createRoomResponse.result == 0) {
            LOG(@"创建成功");
            NSString *roomId = [[[AHPersonInfoManager manager] getInfoModel] userId];
            [self getRoomInfoRequestWithRoomId:roomId];
            //创建成功，发送邀请请求
            if (self.toUsersArray.count > 0) {
                SendInviteMessageRequest * inviteMessReq = [[SendInviteMessageRequest alloc] init];
                inviteMessReq.toUserIdArray = self.toUsersArray;
                inviteMessReq.roomId = roomId;
                if (self.headerView.passwordText.text.length > 0) {
                    inviteMessReq.password = self.headerView.passwordText.text;
                }
                inviteMessReq.message = _messageString;
                [[AHTcpApi shareInstance] requsetMessage:inviteMessReq classSite:MessageClassName completion:^(id response, NSString *error) {
                    NSLog(@"邀请成功！");
                }];
            }
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"很抱歉，创建房间失败，请重新创建" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];
    
}

//获取房间详情，进入直播
-(void)getRoomInfoRequestWithRoomId:(NSString*)roomId{
    AHBankerLiveController * liveVC = [[AHBankerLiveController alloc] init];
        liveVC.roomId = roomId;
    [self.navigationController pushViewController:liveVC animated:YES];
}

//邀请好友加入房间
-(void)invitationFriendJoinRoom:(NSString*)roomId{
    SendInviteMessageRequest *invitationJoinReques = [[SendInviteMessageRequest alloc]init];
    invitationJoinReques.roomId = roomId;
    invitationJoinReques.message = self.messageString;
    invitationJoinReques.toUserIdArray = self.toUsersArray;
    if (self.headerView.passwordText.text.length>0) {
       invitationJoinReques.password = self.headerView.passwordText.text;
    }
    [[AHTcpApi shareInstance]requsetMessage:invitationJoinReques classSite:MessageClassName completion:^(id response, NSString *error) {
        SendInviteMessageResponse *invitationResponse = response;
        if (invitationResponse.result == 0) {
            
        }else{
          AHAlertView *alertView =  [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"很抱歉邀请没有成功，请重新创建" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headerView.height = 142;
}

//汉字转拼音
- (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.firstWord.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch ) {
        return self.resultArray.count;
    }
    NSString * key = self.firstWord[section];
    return [(NSArray *)self.friendDic[key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    inviteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"inviteCells"];
    if (self.resultArray.count > 0) {
        cell.nameLbl.text = ((FriendModel *)self.resultArray[indexPath.row]).chineseName;
        return cell;
    }
    NSString * key = self.firstWord[indexPath.section];
    FriendModel * model = ((FriendModel *)self.friendDic[key][indexPath.row]);
    [cell setCellMessageWithFriendModel:model];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBlock = ^(BOOL isSelected,NSString * userid){
        if (isSelected == YES) {
            [self.toUsersArray addObject:userid];
        }
    };
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
    
    return cell;
}

// 配置指示文本
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.tempArray;
}
// 配置区段文本标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.isSearch) {
        return nil;
    }
    if (section  == 0) {
        return  @"";
    }
    return self.tempArray[section];
}

@end
