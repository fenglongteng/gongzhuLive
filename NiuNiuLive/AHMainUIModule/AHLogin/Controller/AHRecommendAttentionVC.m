//
//  AHRecommendAttentionVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHRecommendAttentionVC.h"
#import "AHRecommendAttentionCell.h"
#import "UIView+ST.h"
#import "AHBaseTabBarController.h"
@interface AHRecommendAttentionVC ()
//完成按钮
@property(nonatomic,strong)UIButton *completeButton;

/**
选中状态的cell字典：位置：是否选中
 */
@property(nonatomic,strong)__block NSMutableArray *seletedArray;

@end

@implementation AHRecommendAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    //[self getNewSourceArray];
    // Do any additional setup after loading the view from its nib.
}

-(void)getNewSourceArray{
    self.skip = 0;
    [self getRecommendUser];
}

  //获取推荐用户
-(void)getRecommendUser{
    UsersFindOtherRequest *findRecomend = [[UsersFindOtherRequest alloc]init];
    findRecomend.type = UsersFindOtherRequest_FindType_Recommend;//获取推荐用户
    findRecomend.skip = 0;
    findRecomend.limit = 10;
    [[AHTcpApi shareInstance]requsetMessage:findRecomend classSite:UsersClassName completion:^(id response, NSString *error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        UsersFindOtherResponse *recommendModel = (UsersFindOtherResponse *)response;
        if (recommendModel.result == 0) {
            if(self.skip == 0){
                [self.sourceArray removeAllObjects];
            }
            [self.sourceArray addObjectsFromArray:recommendModel.findUsersArray];
              [self setAllCellStatus:YES];
            [self.listTableView reloadData];
        }else{
            if (self.skip != 0) {
                [self.listTableView.mj_footer resetNoMoreData];
            }else{
                [self.listTableView.mj_footer endRefreshing];
            }
        }
        [self.listTableView ah_reloadData];
        
    }];
}

-(void)setUpView{
    [self setHoldTitle:@"推荐关注"];
    [self setUpTableView];
    [self.view addSubview:self.completeButton];
    _completeButton.frame = CGRectMake(0, screenHeight - 64 - 45, screenWidth, 45);
}

-(void)setUpTableView{
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64  - 45)];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHRecommendAttentionCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHRecommendAttentionCell getIdentifier]];
    [self.view addSubview:self.completeButton];
}

-(UIButton*)completeButton{
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_completeButton setBackgroundColor:BYColor(178, 35, 189)];
        [_completeButton addTarget:self action:@selector(pushTabBarControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

-(NSMutableArray*)seletedArray{
    if (!_seletedArray) {
        _seletedArray = [NSMutableArray array];
    }
    return _seletedArray;
}

//设置所有的cell是否被选中
-(void)setAllCellStatus:(BOOL)isAllSeleted{
    [self.seletedArray removeAllObjects];
    if (isAllSeleted) {
        [self.seletedArray addObjectsFromArray:self.sourceArray];
    }
}

//完成按钮响应
-(void)pushTabBarControl{
//    for (FindUser *findUser in self.seletedArray) {
//            UsersLikeUserRequest *likeRequest = [[UsersLikeUserRequest alloc]init];
//            GPBStringBoolDictionary *boolDic = [GPBStringBoolDictionary dictionaryWithBool:YES forKey:findUser.userId];
//            likeRequest.users = boolDic;
//            [[AHTcpApi shareInstance]requsetMessage:likeRequest classSite:UsersClassName completion:^(id response, NSString *error) {
//                UsersLikeUserResponse *likeRespose = response;
//                LOG(@"%@",likeRespose);
//            }];
//        }
    [AppDelegate setTabBarControllerBecomeRootViewController];
}

////关注
//-(void)attentionPersonWithUserId:(NSMutableArray*)userIdArr{
//    UsersLikeUserRequest *likeRequest = [[UsersLikeUserRequest alloc]init];
//        for (NSString *str in self.seletedDic.allKeys) {
//              NSInteger idx = [str integerValue];
//            FindUser*userModel = self.sourceArray[idx];
//            BOOL isSeleted =   [self.seletedDic[str] boolValue];
//            GPBStringBoolDictionary *boolDic = [GPBStringBoolDictionary dictionaryWithBool:isSeleted forKey:userModel.userId];
//            likeRequest.users = boolDic;
//            [[AHTcpApi shareInstance]requsetMessage:likeRequest classSite:UsersClassName completion:^(id response, NSString *error) {
//                UsersLikeUserResponse *likeRespose = response;
//                LOG(@"%@",likeRespose);
//            }];
//        }
//}

#pragma mark UITableViewDataSourceAndDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"headerCell"];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(cell.contentView);
            }];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 17, screenWidth, 13)];
            titleLabel.text = @"这些达人正在直播，赶紧关注吧";
            titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [view addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.left.equalTo(view).offset(16);
            }];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(screenWidth - 70 - 15, 9, 70, 30);
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
            [button addBorderColor:[UIColor blackColor] andwidth:1 andCornerRadius:4];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:@"全选" forState:UIControlStateNormal];
            [button setTitle:@"全部取消" forState:UIControlStateSelected];
            button.selected = YES;
            [button addTarget:self action:@selector(seleteAllCell:)  forControlEvents:UIControlEventTouchUpInside];
            [view  addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).offset(-15);
                make.centerY.equalTo(view);
                make.width.mas_equalTo(70);
            }];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
    }else{
        AHRecommendAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:[AHRecommendAttentionCell getIdentifier] forIndexPath:indexPath];
        cell.seletBt.selected = YES;
        cell.index = indexPath;
//        cell.attentionBlock = ^(NSInteger index,UIButton *sender){
//            sender.selected = !sender.isSelected;
//            NSLog(@"%@",self.sourceArray[index]);
//            if ([self.seletedArray containsObject:self.sourceArray[index]]) {
//                 [self.seletedArray removeObject:self.sourceArray[index]];
//            }else{
//                 [self.seletedArray addObject: self.sourceArray[index]];
//            }
//           
//        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.sourceArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }else{
        return 0.1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(void)seleteAllCell:(UIButton*)sender{
    sender.selected = ! sender.isSelected;
    //全选
    if (sender.isSelected) {
        [self setAllCellStatus:YES];
    }else{
        [self setAllCellStatus:NO];
    }
    [self.listTableView reloadData];
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
