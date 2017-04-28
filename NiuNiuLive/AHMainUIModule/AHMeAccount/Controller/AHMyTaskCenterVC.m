//
//  AHMyTaskCenterVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMyTaskCenterVC.h"
#import "AHUnfinishedTaskListCell.h"
#import "AHFinishedTaskCell.h"
@interface AHMyTaskCenterVC ()

@end

@implementation AHMyTaskCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getTaskListRequest];
    // Do any additional setup after loading the view.
}

-(void)setUpView{
    [self setHoldTitle:@"我的任务"];
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHUnfinishedTaskListCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHUnfinishedTaskListCell getIdentifier]];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHFinishedTaskCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHFinishedTaskCell getIdentifier]];
    self.listTableView.mj_footer = nil;
}

//获取我的任务
-(void)getTaskListRequest{
    TasksGetTaskListRequest  *getTaskListRequest = [[TasksGetTaskListRequest alloc]init];
    getTaskListRequest.userid = [AHPersonInfoManager manager].getInfoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:getTaskListRequest classSite:TasksClssName completion:^(id response, NSString *error) {
        TasksGetTaskListResponse *getTaskListRespose  = response;
        if (getTaskListRespose.result == 0) {
         self.sourceArray = [getTaskListRespose.currentTaskArray mutableCopy];
        }
        [self.listTableView reloadData];
        [self.listTableView.mj_header endRefreshing];
    }];
}

//添加用户???
-(void)bt_addAction{
    
}

#pragma mark UITableViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sourceArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TasksGetTaskListResponse_CurrentTask *taskModel = self.sourceArray[indexPath.section];
    TasksGetTaskListResponse_TaskItem*taskItem =  taskModel.task;
    if (taskItem) {
        if (taskItem.currentNumber == taskItem.number) {
            AHFinishedTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[AHFinishedTaskCell getIdentifier] forIndexPath:indexPath];
            cell.taskItem = taskItem;
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            AHUnfinishedTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:[AHUnfinishedTaskListCell getIdentifier] forIndexPath:indexPath];
            cell.taskItem = taskItem;
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        return nil;
    }
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //做任务？？？？？
    NSArray *array = @[@"来来俩",@"我们一起愉快的玩耍吧"];
    AHAlertView *alertView = [[AHAlertView alloc]initListAlertTitle:@"温馨提示" AndDetailInstructions:array cancelAction:^{
        LOG(@"完成任务");
    }];
    [alertView showAlert];
    
    
//    TasksGetTaskListResponse_CurrentTask *taskModel = self.sourceArray[indexPath.section];
//    TasksRequest *taskRequest = [[TasksRequest alloc]init];
//    taskRequest.uuid = taskModel.uuid;
//    [[AHTcpApi shareInstance]requsetMessage:taskRequest classSite:TasksClssName completion:^(id response, NSString *error) {
//        TasksResponse *taskResponse = response;
//        if (taskResponse.result == 0) {
//            //完成任务后做什么
//        }
//    }];
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
