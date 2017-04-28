//
//  niuniuGameController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "niuniuGameController.h"
#import "niuniuHeader.h"
#import "homeMainCell.h"
#import "GLHBannerView.h"
#import "Masonry.h"
#import "Rooms.pbobjc.h"

@interface niuniuGameController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *niuniuTable;
@property(nonatomic,strong)niuniuHeader * headerview;
@property(nonatomic,strong)GLHBannerView * bannerView;

@property(nonatomic,strong)NSMutableArray * gameDataSource;

@end

@implementation niuniuGameController

-(GLHBannerView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[GLHBannerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 235)];
    }
    return _bannerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameDataSource = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"百人牛牛";
    self.niuniuTable.delegate = self;
    self.niuniuTable.dataSource = self;
    self.niuniuTable.rowHeight = 225.0 * screenWidth / 320;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.niuniuTable.tableFooterView = [[UIView alloc] init];
    self.niuniuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.niuniuTable.alwaysBounceVertical = YES;
    [self.niuniuTable registerNib:[UINib nibWithNibName:@"homeMainCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"homeMainCells"];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"niuniuHeader" owner:nil options:nil];
    self.headerview = (niuniuHeader *)[nibView objectAtIndex:0];
    [self.headerview initFrame:CGRectMake(0, 0, screenWidth, 404 - (64 -self.headerview.introduceLbl.height) - (35 - self.headerview.compareLbl.height))];
    [self.bannerView customTableHeaderView:_headerview.niuniuHeader];
    [self.headerview addSubview:self.bannerView];
    //添加相关标题以及按钮
    [self createNavigationBarButtonAndTitle];
    self.niuniuTable.tableHeaderView = self.headerview;
    [self getGameDatasourceMessage];
}

- (void)createNavigationBarButtonAndTitle{
    //简介标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 214, 91, 21)];
    label.text = @"百人牛牛介绍";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:11.0f weight:0.5];
    [self.headerview addSubview:label];
    //返回按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * image = [UIImage imageNamed:@"btn_home_arrow0"];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 20, 20, 20);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(popToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    //title
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"百人牛牛";
    titleLabel.center = CGPointMake(screenWidth / 2.0 + 20, 32);
    titleLabel.font = [UIFont systemFontOfSize:16.0f weight:1];
    [self.view addSubview:titleLabel];
    
}

- (void)popToLastViewController{
    [[AppDelegate getNavigationTopController].navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headerview.height = 404 - (64 -self.headerview.introduceLbl.height) - (35 - self.headerview.compareLbl.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.niuniuTable) {
        CGPoint offset = scrollView.contentOffset;
        //下拉放大实现
        if (offset.y < 0) {
            [self.bannerView setOffSetY:offset.y];
        }else{
            [self.bannerView setOffSetY:0];
        }
    }
}
#pragma mark UITableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gameDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    homeMainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"homeMainCells"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.isLocation = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.gameDataSource.count > 0) {
        [cell setHomeCell:self.gameDataSource[indexPath.row]];
    }
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

- (void)getGameDatasourceMessage{
    RoomsGetGamingRoomsRequest * gamereq = [[RoomsGetGamingRoomsRequest alloc] init];
    gamereq.gameName = @"百人牛牛";
    gamereq.skip = 0;
    gamereq.limit = 20;
    [[AHTcpApi shareInstance] requsetMessage:gamereq classSite:RoomClassName completion:^(id response, NSString *error) {
        RoomsGetGamingRoomsResponse * gameRes = (RoomsGetGamingRoomsResponse *)response;
        if (gameRes.result == 0 && gameRes.roomsArray.count > 0) {
            self.gameDataSource = gameRes.roomsArray;
            [self.niuniuTable reloadData];
        }
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
