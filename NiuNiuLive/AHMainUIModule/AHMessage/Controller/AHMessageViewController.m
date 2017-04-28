//
//  AHMessageViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMessageViewController.h"
#import "AHSearchViewController.h"
#import "AHMessageCell.h"
#import "AHMessageDetailVC.h"
#import "AHInvitationToSeeLiveViewManager.h"
@interface AHMessageViewController ()

@end

@implementation AHMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.listTableView ah_reloadData];
    [self setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self registerPushMessage];
    AHInvitationToSeeLiveViewManager *manager = [AHInvitationToSeeLiveViewManager Manager];
    for (int i = 0; i<10;i++) {
        AHMessageModel *messageModel = [[AHMessageModel alloc]init];
        messageModel.nickName = [NSString stringWithFormat:@"第%d个",i];
        messageModel.message = @"dfsfsfsfdsfdsffdfsfdsf";
        [manager addInvitationView:messageModel];
    }
    [manager show];
}

//注册接受消息
-(void)registerPushMessage{
    //接受邀请消息
    [[AHTcpApi shareInstance]query:@"PushInviteMessage" andHandler:^(id message, NSData *bodyData) {
        PushInviteMessage *inviteMessage = (PushInviteMessage*)message;
        AHMessageModel *messageModel = [[AHMessageModel alloc]init];
        messageModel.nickName = inviteMessage.nickName;
        messageModel.message = inviteMessage.message;
        [self.sourceArray addObject:messageModel];
        AHPersonInfoManager *personInfoManage = [AHPersonInfoManager manager];
        [personInfoManage setMyMessageArray:self.sourceArray];
        [self.listTableView ah_reloadData];
    }];
    
    //接受关注消息
    [[AHTcpApi shareInstance]query:@"LikePush" andHandler:^(id message, NSData *bodyData) {
        LikePush *liekMessage = (LikePush*)message;
        AHMessageModel *messageModel = [[AHMessageModel alloc]init];
        messageModel.nickName = liekMessage.nickName;
        messageModel.message = [NSString stringWithFormat:@"%@ 关注了我",liekMessage.nickName];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:liekMessage.timestamp];
        messageModel.acceptTime =  [NSString stringWithFormat:@"%ld:%ld",(long)date.hour,(long)date.minute];
        [self.sourceArray addObject:messageModel];
        AHPersonInfoManager *personInfoManage = [AHPersonInfoManager manager];
        [personInfoManage setMyMessageArray:self.sourceArray];
        [self.listTableView ah_reloadData];
    }];
}

-(void)setUpView{
    self.navigationItem.title = @"消息";
    [self setLeftButtonBarItemImage:@"btn_home_search0" highlightImage:@"btn_home_search" target:self action:@selector(search:)];
   // [self setRightButtonBarItemTitle:@"全部忽略" target:self action:@selector(neglectAll)];
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight-64 -tabBarHeight)];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHMessageCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHMessageCell getIdentifier]];
    AHEmptyPlaceHoldView *placeHoldView = self.listTableView.placeHolderView;
    [placeHoldView setUpWithIsHighLighted:NO andTitle:@"还没有新消息哟"];
}

//进入搜索界面
- (void)search:(UIButton *)btn{
    AHSearchViewController *searchVC = [[AHSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//全部忽略
- (void)neglectAll{
    [self.sourceArray removeAllObjects];
    [self.listTableView ah_reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark  UITableViewDelegateAndeUITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:[AHMessageCell getIdentifier] forIndexPath:indexPath];
    AHMessageModel *model = self.sourceArray[indexPath.row];
    messageCell.messageModel = model;
    return messageCell;
}

-(UITableViewCellEditingStyle)tableView :(UITableView *)tableView editingStyleForRowAtIndexPath :(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.listTableView beginUpdates];
        [self.sourceArray removeObjectAtIndex:indexPath.row];
        [self.listTableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        AHPersonInfoManager *personInfoManage = [AHPersonInfoManager manager];
        [personInfoManage setMyMessageArray:self.sourceArray];
    }
}

@end
