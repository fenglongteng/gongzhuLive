//
//  LTListBaseViewController.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHListBaseViewController.h"

@interface AHListBaseViewController ()

@end

@implementation AHListBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.skip = 0;
    self.limit= 10;
    // Do any additional setup after loading the view.
}

-(void)createTableView:(UITableViewStyle)style andFrame:(CGRect)frame{
    _listTableView = [[UITableView alloc]initWithFrame:frame style:style];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.separatorColor = self.view.backgroundColor;
    _listTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_listTableView];

    self.listTableView.mj_header = [AHCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewSourceArray)];
    self.listTableView.mj_footer = [AHCustomFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreSourceArray)];
    self.listTableView.placeHolderView = [[AHEmptyPlaceHoldView alloc]initWithIsHighLighted:NO andTitle:@"无数据" AndDelegate:self];
}

-(NSMutableArray*)sourceArray{
    if (!_sourceArray) {
        _sourceArray =[NSMutableArray array];
    }
    return _sourceArray;
}

/**
 获取列表最新数据Array
 */
-(void)getNewSourceArray{
    [self.listTableView.mj_header endRefreshing];
}

/**
 获取下一页数据array
 */
-(void)getMoreSourceArray{
    
    [self.listTableView.mj_footer endRefreshing];
}


-(void)reloadNewData{
    [self getNewSourceArray];
}

/**
 *  开启/关闭回到头部
 *
 *  @param toTop 返回顶部
 */
- (void)setScrollerToTop:(BOOL)toTop{
    
    
}

#pragma mark UITableViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
