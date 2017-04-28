//
//  AHDiscoverViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHDiscoverViewController.h"
#import "AHSearchViewController.h"
#import "homeMainCell.h"
#import "AHLiveViewController.h"
#import "Rooms.pbobjc.h"

@interface AHDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;//数据源

@end

@implementation AHDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"离我最近";
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    [self createTableView:UITableViewStylePlain andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 - 49)];
    self.listTableView.backgroundColor = BYColor(25, 1, 25);
    [self setLeftButtonBarItemImage:@"btn_home_search0" highlightImage:@"btn_home_search0" target:self action:@selector(search:)];
    //[self setRightButtonBarItemImage:@"btn_home_share0" highlightImage:@"btn_home_share0" target:self action:nil];
    [((AHCustomHeader *)self.listTableView.mj_header) setBackgroundColor:[UIColor clearColor] statusLabelTintColor:[UIColor whiteColor]];
    [((AHCustomFooter *)self.listTableView.mj_footer) setBackgroundColor:[UIColor clearColor] statusLabelTintColor:[UIColor whiteColor]];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.listTableView.rowHeight = 225.0 * screenWidth / 320;

    self.listTableView.tableFooterView = [[UIView alloc] init];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.alwaysBounceVertical = YES;
    [self.listTableView registerNib:[UINib nibWithNibName:@"homeMainCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"mainCells"];

    [self getNewSourceArray];
}

#pragma mark - 获得距我最近的直播
//刷新数据源
-(void)getNewSourceArray{
    self.skip = 0;
    self.limit = 10;
    [self getRooms];
}

-(void)getMoreSourceArray{
    self.skip++;
    [self getRooms];
}

//获取房间列表
-(void)getRooms{
    RoomsGetNearestRoomRequest *nearRoom = [[RoomsGetNearestRoomRequest alloc]init];
    nearRoom.offset = self.skip*self.limit;
    nearRoom.limit = self.limit;
    AHEmptyPlaceHoldView *placeHoldView = [self.listTableView placeHolderView];
    [placeHoldView setUpWithIsHighLighted:YES andTitle:@"无数据"];
    [[AHTcpApi shareInstance]requsetMessage:nearRoom classSite:RoomClassName completion:^(id response, NSString *error) {
        [self.listTableView.mj_footer endRefreshing];
        [self.listTableView.mj_header endRefreshing];
        RoomsGetNearestRoomResponse *nearRoomRes = (RoomsGetNearestRoomResponse *)response;
        if (nearRoomRes.result == Result_Succeeded && nearRoomRes.roomsArray.count>0) {
            if (self.skip == 0) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:nearRoomRes.roomsArray];
        }else{
            if (self.skip != 0) {
                [self.listTableView.mj_footer resetNoMoreData];
            }
        }
        [self upDateArray];
        [self.listTableView ah_reloadData];
    }];
}

//更新数组删除重复对象
-(void)upDateArray{
    NSSet *sourceSet = [NSSet setWithArray:_dataSource];
    _dataSource = [[sourceSet allObjects] mutableCopy];
}

- (void)search:(UIButton *)btn{

    AHSearchViewController *searVc = [[AHSearchViewController alloc]init];
    
    [self.navigationController pushViewController:searVc animated:YES];
}

#pragma mark UITabelViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    homeMainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mainCells"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isLocation = YES;
    Room *room = [self.dataSource objectAtIndex:indexPath.row];
    [cell setHomeCell:room];
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
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Room *room = [self.dataSource objectAtIndex:indexPath.row];
//    UIViewController *VC = [AppDelegate getNavigationTopController];
    AHLiveViewController *liveVC = [[AHLiveViewController alloc]initWithRoom:room];
    liveVC.roomId = room.ownerId;
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
