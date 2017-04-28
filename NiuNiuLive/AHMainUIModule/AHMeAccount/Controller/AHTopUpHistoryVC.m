//
//  AHTopUpHistoryVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHTopUpHistoryVC.h"
#import "AHBillCell.h"
@interface AHTopUpHistoryVC ()

@end

@implementation AHTopUpHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getNewSourceArray];
    // Do any additional setup after loading the view.
}

-(void)setUpView{
    [self setHoldTitle:@"充值历史"];
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHBillCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHBillCell getIdentifier]];
}

-(void)getNewSourceArray{
    self.skip = 0;
    [self getAccountsLogRequest];
}

-(void)getMoreSourceArray{
    self.skip++;
    [self getAccountsLogRequest];
}

//充值历史 账单
-(void)getAccountsLogRequest{
    AccountsLogRequest *accountLogRequest = [[AccountsLogRequest alloc]init];
    accountLogRequest.skip = self.skip*self.limit;
    accountLogRequest.limit = self.limit;
    accountLogRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:accountLogRequest classSite:AccoutsClassName completion:^(id response, NSString *error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        AccountsLogResponse *logRespose = response;
        if (logRespose.result == 0 && logRespose.accountsLogArray_Count>0) {
            if(self.skip == 0){
                [self.sourceArray removeAllObjects];
            }
            [self.sourceArray addObjectsFromArray:logRespose.accountsLogArray];
            [self updataArray];
        }else{
            if (self.skip != 0) {
                [self.listTableView.mj_footer resetNoMoreData];
            }
        }
        [self.listTableView ah_reloadData];
    }];
    
}

-(void)updataArray{
    NSMutableArray *array = [NSMutableArray array];
    [self.sourceArray enumerateObjectsUsingBlock:^(AccountsLogResponse_AccountsLog *log, NSUInteger idx, BOOL * _Nonnull stop) {
        if (log.money != 0) {
            [array addObject:log];
        }
    }];
    self.sourceArray = array;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, screenWidth -15, 13)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor grayColor];
    [view addSubview:titleLabel];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.sourceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHBillCell *cell = [tableView dequeueReusableCellWithIdentifier:[AHBillCell getIdentifier] forIndexPath:indexPath];
    AccountsLogResponse_AccountsLog *log = self.sourceArray[indexPath.row];
    [cell setLogModel:log];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
