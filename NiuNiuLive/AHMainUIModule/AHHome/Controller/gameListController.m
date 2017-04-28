//
//  gameListController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//
#import "gameListController.h"
#import "gameListCell.h"
#import "gameHeader.h"
#import "GLHBannerView.h"
#import "niuniuGameController.h"
#import "AHAdvertisementManager.h"
#import "WKWebViewController.h"
#import "UserApis.pbobjc.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"

@interface gameListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *gameListTable;
/**
 自定义下拉放大tableHeaderView
 */
@property (nonatomic, strong) GLHBannerView *bannerView;
@property(nonatomic,strong)gameHeader * headerview;

@property(nonatomic,strong)NSMutableArray * datasoure;
@end

@implementation gameListController

-(GLHBannerView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[GLHBannerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 258)];
    }
    return _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datasoure = [NSMutableArray array];
    [self addPopButton];
    self.navigationItem.title = @"游戏列表";
    self.gameListTable.delegate = self;
    self.gameListTable.dataSource = self;
    self.gameListTable.rowHeight = 70;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.gameListTable.tableFooterView = [[UIView alloc] init];
    self.gameListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gameListTable.alwaysBounceVertical = YES;
    [self.gameListTable registerNib:[UINib nibWithNibName:@"gameListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"gameListCells"];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"gameHeader" owner:nil options:nil];
    self.headerview = (gameHeader *)[nibView objectAtIndex:0];
    [self.headerview initFrame:CGRectMake(0, 0, screenWidth, 300)];
    AHAdvertisementManager *adManager = [AHAdvertisementManager manager];
    if (adManager.ad3Array.count>0) {
        SystemGetADListResponse_AD* ad = adManager.ad3Array[0];
        [self.headerview.topImage sd_setImageWithURL:[NSURL URLWithString:ad.URL]];
    }
    [self.headerview.topImage addTarget:self action:@selector(pushWebViewController)];
    [self.bannerView customTableHeaderView:_headerview.topImage];
    [self.headerview addSubview:self.bannerView];
    self.gameListTable.tableHeaderView = self.headerview;
    [self getGameListDataSource];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headerview.height = 300;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.gameListTable) {
        CGPoint offset = scrollView.contentOffset;
        //下拉放大实现
        if (offset.y < 0) {
            [self.bannerView setOffSetY:offset.y];
        }else{
            [self.bannerView setOffSetY:0];
        }
    }
}

-(void)pushWebViewController{
    AHAdvertisementManager *adManager = [AHAdvertisementManager manager];
    if (adManager.ad3Array.count>0) {
        SystemGetADListResponse_AD* ad = adManager.ad3Array[0];
        WKWebViewController *webViewController  = [[WKWebViewController alloc]init];
        [webViewController loadWebURLSring:ad.link];
        [[AppDelegate getNavigationTopController].navigationController pushViewController:webViewController animated:YES];
    }
  
}

#pragma mark UITableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    gameListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"gameListCells"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[AppDelegate getNavigationTopController].navigationController pushViewController:[[niuniuGameController alloc] init] animated:YES];
}

- (void)getGameListDataSource{
    GamesInfoReq * gameinfo = [[GamesInfoReq alloc] init];
    [[GameSocketManager instance] query:ProtoTypes_PtIdapigetGamesInfo andMessage:gameinfo andHandler:^int(PackHeader *header, NSData *body) {
        GamesInfoRes * gameRes = GetMessage(GamesInfoRes, body);
        if (gameRes.status == 0) {
            self.datasoure = gameRes.gamesArray;
            [self.gameListTable reloadData];
        }
        return 0;
    }];
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
