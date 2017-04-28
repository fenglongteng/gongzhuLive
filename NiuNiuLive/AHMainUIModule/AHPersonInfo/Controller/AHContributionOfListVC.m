//
//  AHContributionOfListVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHContributionOfListVC.h"
#import "AHContributionListOtherCell.h"
#import "AHContributionOfListTopCell.h"

@interface AHContributionOfListVC ()
//魅力总数
@property(nonatomic,strong)UILabel *totalNumberOfCharmLabel;
//魅力详情
@property(nonatomic,strong)UILabel *charmDetail;
@end

@implementation AHContributionOfListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}
-(void)setUpView{
    [self setHoldTitle:@"贡献榜"];
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.listTableView registerNib:[UINib nibWithNibName:@"AHContributionOfListTopCell" bundle:nil] forCellReuseIdentifier:@"topCell"];
        [self.listTableView registerNib:[UINib nibWithNibName:@"AHContributionListOtherCell" bundle:nil] forCellReuseIdentifier:@"otherCell"];
   // [self setRightButtonBarItemTitle:@"添加" titleColor:UIColorFromRGB(0xb434fe) target:self action:@selector(bt_addAction)];
}

//添加用户???
-(void)bt_addAction{
    
}

#pragma mark UITableViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section <3) {
          return 1;
    }else{
        return 3;
        return self.sourceArray.count;
    }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section <2) {
        return 2;
    }else if(section == 2){
        return 54;
    }else{
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 3) {
        return 140;
    }else{
         return 65;
    }
   
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = self.view.backgroundColor;
    if (section < 2) {
        view.frame = CGRectMake(0, 0, screenWidth, 2);
    }else if (section == 2){
        view.frame = CGRectMake(0, 0, screenWidth, 54);
        _totalNumberOfCharmLabel = [[UILabel alloc]init];
        _totalNumberOfCharmLabel.text = @"魅力总数：23434";
        _totalNumberOfCharmLabel.font = [UIFont boldSystemFontOfSize:15];
        [view addSubview:_totalNumberOfCharmLabel];
        [_totalNumberOfCharmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(14);
            make.centerX.equalTo(view);
        }];
        _charmDetail = [[UILabel alloc]init];
        _charmDetail.textColor = UIColorFromRGB(0x999999);
        _charmDetail.font = [UIFont systemFontOfSize:10];
        _charmDetail.text = @"在120场主播中，共获得454位观众的鼓励";
        [view addSubview:_charmDetail];
        [_charmDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(33);
            make.centerX.equalTo(view);
        }];
    }else{
        view.frame = CGRectMake(0, 0, screenWidth, 0.1);
    }
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 3) {
        AHContributionOfListTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"topCell" forIndexPath:indexPath];
        return topCell;
    }else{
        AHContributionListOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell" forIndexPath:indexPath];
        return cell;
    }

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
