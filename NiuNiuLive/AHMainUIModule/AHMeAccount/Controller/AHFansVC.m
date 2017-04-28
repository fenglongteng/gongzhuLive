//
//  AHFansVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHFansVC.h"
#import "AHAttentionCell.h"
#import "AHSearchViewController.h"
#import "AHPersonInfoVC.h"
#import "AHNetworkMonitor.h"
@interface AHFansVC ()
@property(nonatomic,assign)BOOL isMy;
@property(nonatomic,strong)AHPersonInfoModel *infoModel;
@end

@implementation AHFansVC

-(instancetype)initWithMy:(BOOL)isMy andPersonInfoModel:(AHPersonInfoModel*)infoModel{
    if ([super init]) {
        _isMy = isMy;
        _infoModel = infoModel;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getNewSourceArray];
    // Do any additional setup after loading the view.
}

-(void)setUpView{
    if (_isMy) {
        [self setHoldTitle:@"我的粉丝"];
        [self setRightButtonBarItemTitle:@"添加" titleColor:UIColorFromRGB(0xb434fe) target:self action:@selector(bt_addAction)];
    }else{
        [self setHoldTitle:[NSString stringWithFormat:@"%@的粉丝",_infoModel.nickName]];
    }
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.listTableView registerNib:[UINib nibWithNibName:@"AHAttentionCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    AHEmptyPlaceHoldView *placeHoldView = [self.listTableView placeHolderView];
    [placeHoldView setUpWithIsHighLighted:NO andTitle:@"有粉丝才有意思，赶快发起直播并分享到你的朋友圈去"];
    
}

-(void)getNewSourceArray{
    self.skip = 0;
    self.limit = 10;
    if (_isMy) {
        if ([AHNetworkMonitor monitorNetwork].networkStatus ==0) {
            self.sourceArray = [[AHPersonInfoManager manager].getLikeMeArray mutableCopy];
            [self.listTableView.mj_header endRefreshing];
            [self.listTableView.mj_footer resetNoMoreData];
            [self.listTableView ah_reloadData];
        }else{
            [self getMyFans];
        }
    }else{
            [self getMyFans];
    }
  
}

-(void)getMoreSourceArray{
    self.skip++;
    if (!_isMy && [AHNetworkMonitor monitorNetwork].networkStatus != 0) {
           [self getMyFans];
    }else{
        
    }
}

-(void)getMyFans{
    UsersGetLikeMeUserInfoRequest *attentionMeRequest = [[UsersGetLikeMeUserInfoRequest alloc]init];
    attentionMeRequest.skip = self.skip*self.limit;
    attentionMeRequest.limit = self.limit;
    attentionMeRequest.userId = _infoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:attentionMeRequest classSite:UsersClassName completion:^(id response, NSString *error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        UsersGetLikeMeUserInfoResponse *attentionMeRespose = response;
        if (attentionMeRespose.result == 0 && attentionMeRespose.likeMeUserArray_Count>0) {
            if(self.skip == 0){
                [self.sourceArray removeAllObjects];
            }
            [self.sourceArray addObjectsFromArray: attentionMeRespose.likeMeUserArray];
        }else{
            if (self.skip != 0) {
               [self.listTableView.mj_footer resetNoMoreData];
            }
        }
        [self.listTableView ah_reloadData];
        [self MyFansDataLocality:self.sourceArray];
    }];
}

//粉丝本地化
-(void)MyFansDataLocality:(NSArray*)fansArray{
    if (_isMy) {
        NSArray *myFansArray = [AHPersonInfoManager manager].getMyLikeArray;
        if (myFansArray.count < fansArray.count) {
            myFansArray = fansArray;
            [[AHPersonInfoManager manager]setLikeMeArray:myFansArray];
        }
    }

}

-(void)bt_addAction{
    AHSearchViewController *searchVC = [[AHSearchViewController alloc]init];
    [self.navigationController pushViewController: searchVC animated:YES];
}

#pragma mark UITableViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.attentionBt.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UsersGetLikeMeUserInfoResponse_LikeMeUser *userInfoModel = self.sourceArray[indexPath.row];
    cell.likeMeUserInfoModel = userInfoModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UsersGetLikeMeUserInfoResponse_LikeMeUser *userInfoModel = self.sourceArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AHPersonInfoVC *personInfoVC =[[AHPersonInfoVC alloc]initWithUserId:userInfoModel.userId];
    [self.navigationController pushViewController:personInfoVC animated:YES];
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
