//
//  inviteView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "inviteView.h"
#import "createLiveHeader.h"
#import "FriendModel.h"
#import "Gifts.pbobjc.h"
#import "inviteCell.h"
#import "Response.pbobjc.h"
#import "Messages.pbobjc.h"
#import "Rooms.pbobjc.h"

@interface inviteView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *inviteTable;
@property (weak, nonatomic) IBOutlet UIButton *trueBtn;

@property(nonatomic,strong)createLiveHeader * headerView;
@property (weak, nonatomic) IBOutlet UIView *backView;

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

@implementation inviteView

+ (inviteView *)initInviteView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)settingViewShow{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSetting:)];
    [self.backView addGestureRecognizer:tap];
    
    //动画显示
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.2;
    scaleAnimation.beginTime = CACurrentMediaTime();;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:3.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
    
    self.trueBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.trueBtn.layer.borderWidth = 1.0f;
    self.trueBtn.layer.cornerRadius = 25/2.0;
    
    self.inviteTable.delegate = self;
    self.inviteTable.dataSource = self;
    self.inviteTable.rowHeight = 60;
    self.inviteTable.tableFooterView = [[UIView alloc] init];
    self.inviteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.inviteTable.alwaysBounceVertical = YES;
    [self.inviteTable registerNib:[UINib nibWithNibName:@"inviteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"inviteCells"];
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"createLiveHeader" owner:nil options:nil];
    self.headerView = (createLiveHeader *)[nibView objectAtIndex:0];
    [self.headerView initWithHeaderViewFrame:CGRectMake(0, 0, screenWidth, 142)];
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
    }];
    //关联并排序
    self.firstWord = [self.friendDic.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.tempArray = self.firstWord;
    [self.inviteTable reloadData];
}

//取消设置
- (IBAction)cancelSetting:(id)sender {
    if ( self.closeBlock) {
        self.closeBlock();
    }
    
}
//确定设置 提交
- (IBAction)trueSetting_Event:(id)sender {
    //创建成功，发送邀请请求
    if (self.toUsersArray.count > 0) {
        SendInviteMessageRequest * inviteMessReq = [[SendInviteMessageRequest alloc] init];
        inviteMessReq.toUserIdArray = self.toUsersArray;
        inviteMessReq.roomId = self.roomid;
        if (self.headerView.passwordText.text.length > 0) {
            inviteMessReq.message = self.headerView.passwordText.text;
        }else{
            inviteMessReq.message = @"";
        }
        [[AHTcpApi shareInstance] requsetMessage:inviteMessReq classSite:MessageClassName completion:^(id response, NSString *error) {
            SendInviteMessageResponse * res = (SendInviteMessageResponse *)response;
            if (res.result == 0) {
                
            }
        }];
    }
    if (self.headerView.passwordText.text.length > 0) {
        RoomsAlterRoomPasswordRequest * changePass = [[RoomsAlterRoomPasswordRequest alloc] init];
        changePass.password = self.headerView.passwordText.text;
        [[AHTcpApi shareInstance] requsetMessage:changePass classSite:RoomClassName completion:^(id response, NSString *error) {
            RoomsAlterRoomPasswordResponse * res = (RoomsAlterRoomPasswordResponse *)response;
            if (res.result == 0) {
                NSLog(@"修改成功！");
            }
        }];
    }
    

}

#pragma mark UITableviewDatasource

//汉字转拼音
- (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
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
    cell.nameLbl.text = model.chineseName;
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

- (void)dealloc{
    
    LOG(@"%s",__func__);

}

@end
