//
//  AHBlackListVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBlackListVC.h"
#import "AHAttentionCell.h"
@interface AHBlackListVC ()

@end

@implementation AHBlackListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}

-(void)setUpView{
    [self setHoldTitle:@"黑名单"];
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.listTableView registerNib:[UINib nibWithNibName:@"AHAttentionCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

//添加用户???
-(void)bt_addAction{
    
}

#pragma mark UITableViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
