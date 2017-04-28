//
//  LiveListControllerViewController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "LiveListControllerViewController.h"

#import "homeMainCell.h"
#import "focusCell.h"
#import "segmentationView.h"
#import "CharmControllerViewController.h"
#import "AHLiveViewController.h"
#import "AHSignInVC.h"
#import "NSObject+AHUntil.h"
#import "LevelController.h"
#import "gameListController.h"
#import "Rooms.pbobjc.h"
#import "AHAdvertisementManager.h"
#import "WKWebViewController.h"
@interface LiveListControllerViewController ()<UITableViewDelegate,UITableViewDataSource,ClickOnTheImage>{
    //frame
    CGRect selfFrame;
    LiveType _liveType;//当前页面展示的直播类型
}

//头部视图高度
@property(nonatomic,assign)CGFloat headerHeight;

@end

@implementation LiveListControllerViewController

- (instancetype)initWithFrame:(CGRect)frame LiveType:(LiveType)LiveType{
    self = [super init];
    if (self) {
        selfFrame = frame;
        _liveType = LiveType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = selfFrame;
    [self createTableView:UITableViewStylePlain andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 - 49)];
    self.listTableView.backgroundColor = BYColor(25, 1, 25);
    [((AHCustomHeader *)self.listTableView.mj_header) setBackgroundColor:[UIColor clearColor] statusLabelTintColor:UIColorFromRGB(0x505050)];
    [((AHCustomFooter *)self.listTableView.mj_footer) setBackgroundColor:[UIColor clearColor] statusLabelTintColor:UIColorFromRGB(0x505050)];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.listTableView.rowHeight = 225.0 * screenWidth / 320;
    if (_liveType == HotLive) {
        CGFloat headerHeight;
        CGFloat buttonWidth = (screenWidth - 50) / 4.0;
        CGFloat buttonHeight = buttonWidth * 55.0 / 80;
        headerHeight = screenWidth * 3 / 8.0 + buttonHeight + 8 + 12;
        _headerHeight = headerHeight;
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"mainHeaderView" owner:nil options:nil];
        self.headerView = (mainHeaderView *)[nibView objectAtIndex:0];
        [self.headerView initWithHeaderViewFrame:CGRectMake(0, 0, screenWidth, headerHeight)];
        [self.headerView startTimer];
        AHAdvertisementManager *manager =   [AHAdvertisementManager manager];
        if (manager.ad2Array.count >0) {
            NSMutableArray *imageUrlArray = [NSMutableArray array];
            for (SystemGetADListResponse_AD* ad in manager.ad2Array) {
                [imageUrlArray addObject:ad.URL];
            }
            [self.headerView setImageUrlStrArray:imageUrlArray WithBannerFrame:CGRectMake(0, 0, screenWidth, screenWidth/8*3) andDelegate:self];
        }else{
            AHWeakSelf(manager);
            manager.updata = ^(){
                if (weakmanager.ad2Array.count>0) {
                    NSMutableArray *imageUrlArray = [NSMutableArray array];
                    for (SystemGetADListResponse_AD* ad in weakmanager.ad2Array) {
                        [imageUrlArray addObject:ad.URL];
                    }
                    [self.headerView setImageUrlStrArray:imageUrlArray WithBannerFrame:CGRectMake(0, 0, screenWidth, screenWidth/8*3) andDelegate:self];
                }
            }; 
        }

        WeakSelf;
        self.headerView.pushBlock = ^(NSString * title){
            StrongSelf;
            [strongSelf pushViewControllerWithTitle:title];
        };
        self.listTableView.tableHeaderView = self.headerView;
    }
    self.listTableView.tableFooterView = [[UIView alloc] init];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.alwaysBounceVertical = YES;
    [self.listTableView registerNib:[UINib nibWithNibName:@"homeMainCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"mainCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"focusCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"focusCell"];
    AHCustomHeader *mjHeader = (AHCustomHeader *)self.listTableView.mj_header;
    [mjHeader UseGifImageLoading];
    AHCustomFooter *mjFooter = (AHCustomFooter *)self.listTableView.mj_footer;
    [mjFooter hideLoadingImageView];
}

//headerView点击图片代理
-(void)clickOnTheImageOfIndex:(NSInteger)index{
    AHAdvertisementManager *manager =   [AHAdvertisementManager manager];
    NSInteger number = manager.ad2Array.count;
    NSInteger indexNew = (index + 1)%number;
    SystemGetADListResponse_AD* ad =  manager.ad2Array[indexNew];
    WKWebViewController *wkVC = [[WKWebViewController alloc]init];
    [wkVC loadWebURLSring:ad.link];
    [[AppDelegate getNavigationTopController].navigationController pushViewController:wkVC animated:YES];
}

-(void)subViewReload{
    if (!self.loaded) {
        [self getNewSourceArray];
        //        [((AHCustomHeader *)self.listTableView.mj_header) beginRefreshing];
        self.loaded = YES;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headerView.height = _headerHeight;
}

- (void)pushViewControllerWithTitle:(NSString *)title{
    if ([title isEqualToString:@"魅力榜"]) {
        [[AppDelegate getNavigationTopController].navigationController pushViewController:[[CharmControllerViewController alloc] init] animated:YES];
    }else if ([title isEqualToString:@"棋牌"]){
        [[AppDelegate getNavigationTopController].navigationController pushViewController:[[gameListController alloc] init] animated:YES];
    }else if ([title isEqualToString:@"签到"]){
        [NSObject pushFromVC:[AppDelegate getNavigationTopController] toVCWithName:@"AHSignInVC" InTheStoryboardWithName:@"AHStoryboard"];
    }else if ([title isEqualToString:@"我的等级"]){
        AHPersonInfoModel * userModel = [[AHPersonInfoManager manager] getInfoModel];
        LevelController * levelVC = [[LevelController alloc] initWithUserModel:userModel];
        [[AppDelegate getNavigationTopController].navigationController pushViewController:levelVC animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.headerView stopTimer];
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_liveType == FocusLive) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_liveType == FocusLive) {
        //关注的房间
        if (section == 0) {
            return self.sourceArray.count;
        }
        //历史回放
        return 0;
    }else{
        return self.sourceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_liveType == FocusLive && indexPath.section == 1) {
        focusCell * cell = [tableView dequeueReusableCellWithIdentifier:@"focusCell"];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    homeMainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.sourceArray.count > 0) {
        [cell setHomeCell:self.sourceArray[indexPath.row]];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"segmentationView" owner:nil options:nil];
    segmentationView * view = (segmentationView *)[nibView objectAtIndex:0];
    [view initWithSegmentationFrame:CGRectMake(0, 0, self.view.width, 100)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 100.f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_liveType == FocusLive && indexPath.section == 1 ) {
        //历史回放
    }else{
        Room * roomModel = self.sourceArray[indexPath.row];
        AHLiveViewController * liveVC = [[AHLiveViewController alloc] initWithRoom:roomModel];
        UIViewController *VC = [AppDelegate getNavigationTopController];
        [VC.navigationController pushViewController:liveVC animated:YES];
    }

}

//取消tableView的sectionHeader的悬浮状态
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.listTableView){
        CGFloat sectionHeaderHeight = 100;
        if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

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
    if (_liveType == FocusLive) {
        //关注
        RoomsGetLikeRoomsRequest *likeRoomsRequest = [[RoomsGetLikeRoomsRequest alloc]init];
        likeRoomsRequest.limit = self.limit;
        likeRoomsRequest.skip = self.skip*self.limit;
        likeRoomsRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
        [[AHTcpApi shareInstance]requsetMessage:likeRoomsRequest classSite:RoomClassName completion:^(id response, NSString *error) {
            [self.listTableView.mj_footer endRefreshing];
            [self.listTableView.mj_header endRefreshing];
            RoomsGetLikeRoomsResponse *likeRoomsRespose = response;
            if (likeRoomsRespose.roomsArray_Count>0 && likeRoomsRespose.result == 0) {
                if(self.skip == 0){
                    [self.sourceArray removeAllObjects];
                }
                [self.sourceArray addObjectsFromArray:likeRoomsRespose.roomsArray];
            }else{
                if (self.skip != 0) {
                    [self.listTableView.mj_footer resetNoMoreData];
                }
            }
            [self.listTableView reloadData];
        }];
    }else if(_liveType == HotLive){
        //最热
        RoomsGetHotRoomsRequest *hotRoomsRequest = [[RoomsGetHotRoomsRequest alloc]init];
        hotRoomsRequest.limit = self.limit;
        hotRoomsRequest.skip = self.skip*self.limit;
//        hotRoomsRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
        [[AHTcpApi shareInstance]requsetMessage:hotRoomsRequest classSite:RoomClassName completion:^(id response, NSString *error) {
            [self.listTableView.mj_footer endRefreshing];
            [self.listTableView.mj_header endRefreshing];
            RoomsGetHotRoomsResponse *hotRoomsRespose = response;
            if (hotRoomsRespose.roomsArray_Count>0 && hotRoomsRespose.result == 0) {
                if(self.skip == 0){
                    [self.sourceArray removeAllObjects];
                }
                [self.sourceArray addObjectsFromArray:hotRoomsRespose.roomsArray];
            }else{
                
                if (self.skip != 0) {
                    [self.listTableView.mj_footer resetNoMoreData];
                }
                
            }
            [self.listTableView reloadData];
        }];
        
    }else{
        //最新
        RoomsGetRecommendRoomsRequest  *newRoomsRequest = [[RoomsGetRecommendRoomsRequest alloc]init];
        newRoomsRequest.limit = self.limit;
        newRoomsRequest.skip = self.skip*self.limit;
//        newRoomsRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
        AHEmptyPlaceHoldView *placeHoldView = [self.listTableView placeHolderView];
        [placeHoldView setUpWithIsHighLighted:YES andTitle:@"大波直播正在来的路上，请稍等片刻…"];
        [[AHTcpApi shareInstance]requsetMessage:newRoomsRequest classSite:RoomClassName completion:^(id response, NSString *error) {
            [self.listTableView.mj_footer endRefreshing];
            [self.listTableView.mj_header endRefreshing];
            RoomsGetHotRoomsResponse *hotRoomsRespose = response;
            if (hotRoomsRespose.roomsArray_Count>0 && hotRoomsRespose.result == 0) {
                if(self.skip == 0){
                    [self.sourceArray removeAllObjects];
                }
                
                [self.sourceArray addObjectsFromArray:hotRoomsRespose.roomsArray];
            }else{
                if (self.skip != 0) {
                    [self.listTableView.mj_footer resetNoMoreData];
                }
            }
            [self.listTableView ah_reloadData];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setScrollerToTop:(BOOL)top{
    self.listTableView.scrollsToTop = top;
}

@end
