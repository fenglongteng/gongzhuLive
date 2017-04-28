//
//  AHAttentionVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/30.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHAttentionVC.h"
#import "AHAttentionCell.h"
#import "AHPersonInfoVC.h"

@interface AHAttentionVC ()
@property(nonatomic,strong)AHPersonInfoModel *infoModel;
@end

@implementation AHAttentionVC

-(instancetype)initWithPersonInfoModel:(AHPersonInfoModel*)infoModel{
    if ([super init]) {
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

-(void)getNewSourceArray{
    self.skip = 0;
    self.limit = 10;
    [self getAttetionMe];
}

-(void)getMoreSourceArray{
    self.skip++;
    [self getAttetionMe];
}

-(void)getAttetionMe{
    UsersGetMeLikeUserInfoRequest *attentionMeRequest = [[UsersGetMeLikeUserInfoRequest alloc]init];
    attentionMeRequest.skip = self.skip*self.limit;;
    attentionMeRequest.limit = self.limit;
    attentionMeRequest.userId = _infoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:attentionMeRequest classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersGetMeLikeUserInfoResponse *attentionMeRespose = response;
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        if (attentionMeRespose.result == 0 && attentionMeRespose.meLikeUserArray_Count>0) {
            if(self.skip == 0){
                [self.sourceArray removeAllObjects];
            }
            [self.sourceArray addObjectsFromArray: attentionMeRespose.meLikeUserArray];
        }else{
            if (self.skip != 0) {
                [self.listTableView.mj_footer resetNoMoreData];
            }
        }
        [self.listTableView ah_reloadData];
    }];
}

-(void)setUpView{
    [self setHoldTitle:[NSString stringWithFormat:@"%@的关注",_infoModel.nickName]];
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self setLineViewColor:self.view.backgroundColor];
    [self.listTableView registerNib:[UINib nibWithNibName:@"AHAttentionCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    AHEmptyPlaceHoldView *placeHoldView = [self.listTableView placeHolderView];
    [placeHoldView setUpWithIsHighLighted:NO andTitle:@"有关注才有意思，赶快发起直播并分享到你的朋友圈去"];
}

#pragma mark UITableViewDateSourceAndDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.attentionBt.hidden = YES;
    cell.accessibilityNavigationStyle  =UITableViewCellAccessoryDisclosureIndicator;
    UsersGetMeLikeUserInfoResponse_MeLikeUser *userInfoModel = self.sourceArray[indexPath.row];
    cell.meLikeUserInfoModel = userInfoModel;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UsersGetMeLikeUserInfoResponse_MeLikeUser *userInfoModel = self.sourceArray[indexPath.row];
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
