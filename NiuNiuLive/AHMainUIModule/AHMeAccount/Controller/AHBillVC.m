//
//  AHBillVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/30.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBillVC.h"
#import "AHBillCell.h"
typedef NS_ENUM(NSInteger,BillStyle){
    BillStyleIsSpending = 0,
    BillStyleIsIncome
    
};
@interface AHBillVC ()

/**
 segment
 */
@property(nonatomic,strong)UISegmentedControl *segmentBillStyle;

/**
 Description
 */
@property(nonatomic,assign)BillStyle billStyle;

//收益
@property(nonatomic,strong)NSMutableArray *earningsArray;
//支出
@property(nonatomic,strong)NSMutableArray *spendingArray;
@end

@implementation AHBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getNewSourceArray];
    // Do any additional setup after loading the view.
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
                [self.earningsArray removeAllObjects];
                [self.spendingArray removeAllObjects];
            }
            [self.sourceArray addObjectsFromArray:logRespose.accountsLogArray];
            [self breakUpArray:logRespose.accountsLogArray];
        }else{
            if (self.skip != 0) {
                [self.listTableView.mj_footer resetNoMoreData];
            }
        }
           [self.listTableView ah_reloadData];
    }];

}

-(void)breakUpArray:(NSArray*)array{
    if (array.count>0) {
        for (AccountsLogResponse_AccountsLog *log in array) {
            if (log.money>0 || log.goldCoins>0) {
                [self.earningsArray addObject:log];
            }else{
                [self.spendingArray addObject:log];
            }

        }
       
}
}

-(NSMutableArray*)earningsArray{
    if (nil == _earningsArray) {
        _earningsArray = [NSMutableArray array];
}

    return _earningsArray;
}


-(NSMutableArray*)spendingArray{
    if (nil == _spendingArray) {
        _spendingArray = [NSMutableArray array];
    }

    return _spendingArray;
}

-(void)setUpView{
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHBillCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHBillCell getIdentifier]];
    _segmentBillStyle = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 30/0.618*4, 30)];
    self.navigationItem.titleView = _segmentBillStyle;
    _segmentBillStyle.tintColor = BYColor(178, 64, 215);
    [_segmentBillStyle insertSegmentWithTitle:@"支出" atIndex:0 animated:NO];
    [_segmentBillStyle insertSegmentWithTitle:@"收益" atIndex:1 animated:NO];
    _segmentBillStyle.selectedSegmentIndex = 0;
    [_segmentBillStyle addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)changeStyle:(UISegmentedControl*)segment{
    self.billStyle = segment.selectedSegmentIndex;
    if (segment.selectedSegmentIndex == 0) {
        LOG(@"支出");
    }else{
       LOG(@"收入");
    }
    [self.listTableView ah_reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }else{
        return 0.1;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
        view.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, screenWidth -15, 13)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor grayColor];
        if (_billStyle ==0){
            titleLabel.text = @"金币明细(个)";
        }else{
            titleLabel.text = @"收益明细";
        }
        [view addSubview:titleLabel];
        return view;
    }else{
        return nil;
    }
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_billStyle == BillStyleIsSpending ) {
        return   self.spendingArray.count;
    }else{
        return self.earningsArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AHBillCell *cell = [tableView dequeueReusableCellWithIdentifier:[AHBillCell getIdentifier] forIndexPath:indexPath];
    if (_billStyle == BillStyleIsIncome) {
        AccountsLogResponse_AccountsLog *log = self.earningsArray[indexPath.row];
        [cell setLogModel:log];
    }else{
        AccountsLogResponse_AccountsLog *log = self.spendingArray[indexPath.row];
        [cell setLogModel:log];
    }
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
