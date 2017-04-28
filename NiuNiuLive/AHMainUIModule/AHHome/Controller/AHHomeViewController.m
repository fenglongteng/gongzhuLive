//
//  AHHomeViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHHomeViewController.h"
#import "LiveListControllerViewController.h"
#import "SelectedMenu.h"
#import "LBShareController.h"
#import "AHSearchViewController.h"
#import "baseRedPacket.h"

@interface AHHomeViewController ()<UIScrollViewDelegate,ChangeTypeControllerDelegate>{
    //子界面数组，先把controller声明 等到滑动过去的时候再加载
    NSArray *_subControllers;
    //Focus关注
    LiveListControllerViewController * focusVC;
    
    //hot最热
    LiveListControllerViewController * hotVC;
    
    //Newest最新
    LiveListControllerViewController * newestVC;
}
/**
 *  内容滚动视图
 */
@property (nonatomic,strong)  UIScrollView *centerScroller;
/**
 *  选择视图
 */
@property (strong, nonatomic) SelectedMenu *selectedMenuView;
//分享UI
@property(nonatomic,strong)LBShareController *shareView;
@end

@implementation AHHomeViewController

- (UIScrollView *)centerScroller{
    if (!_centerScroller) {
        //主滚动
        _centerScroller = [[UIScrollView  alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 49)];
        _centerScroller.contentSize = CGSizeMake(self.centerScroller.width * 3, screenHeight - 49);
        _centerScroller.showsHorizontalScrollIndicator = NO;
        _centerScroller.showsVerticalScrollIndicator = NO;
        _centerScroller.pagingEnabled = YES;
        _centerScroller.delegate = self;
        _centerScroller.backgroundColor = BYColor(25, 1, 25);
        _centerScroller.scrollsToTop = NO;
        _centerScroller.bounces = NO;
        [_centerScroller setContentOffset:CGPointMake(screenWidth * 1, 0)];
        //创建所有显示子控件
        [self creatSubController];
    }
    return _centerScroller;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_subControllers) {
        NSInteger index = self.centerScroller.contentOffset.x / self.centerScroller.width;
        LiveListControllerViewController *currentShowController = [_subControllers objectAtIndex:index];
        if (currentShowController.headerView) {
            [currentShowController.headerView startTimer];
        }
        [currentShowController setScrollerToTop:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBarTintColor:[UIColor blackColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setOtherControllerNotTop];
}

- (void)setOtherControllerNotTop{
    for (LiveListControllerViewController *tmpVC in _subControllers) {
        [tmpVC setScrollerToTop:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButtonBarItemImage:@"btn_home_search" highlightImage:@"btn_home_search" target:self action:@selector(pushToSearchController)];
    [self setRightButtonBarItemImage:@"btn_home_share" highlightImage:@"btn_home_share" target:self action:@selector(createShareView)];
    [self setTitleView:[self createHeadSlidingView]];
    [self.view addSubview:self.centerScroller];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 *  创建子controller
 */
- (void)creatSubController{
    //加载home页面
    //关注页面
    focusVC = [[LiveListControllerViewController alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 49) LiveType:FocusLive];
    [self.centerScroller addSubview:focusVC.view];
    [focusVC setScrollerToTop:YES];
    //最热页面
    hotVC = [[LiveListControllerViewController alloc] initWithFrame:CGRectMake(CGRectGetMaxX(focusVC.view.frame), 0, screenWidth, screenHeight - 49) LiveType:HotLive];
    [self.centerScroller addSubview:hotVC.view];
    [hotVC setScrollerToTop:YES];
    [hotVC subViewReload];
    //最新页面
    newestVC = [[LiveListControllerViewController alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hotVC.view.frame), 0,screenWidth, screenHeight - 49) LiveType:NewestLive];
    [self.centerScroller addSubview:newestVC.view];
    [newestVC setScrollerToTop:YES];
    _subControllers = [NSArray arrayWithObjects:focusVC,hotVC,newestVC, nil];
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.width;
    [self.selectedMenuView changeSelectedWithIndex:page];
    [self changeTypeControllerWithIndex:page];
    LiveListControllerViewController *currentShowController = [_subControllers objectAtIndex:page];
    [currentShowController subViewReload];
}

//跳转搜索页面
- (void)pushToSearchController{
    [self.navigationController pushViewController:[[AHSearchViewController alloc] init ] animated:YES];
}
//创建分享页面
- (void)createShareView{
    if (self.shareView) {
        [self.shareView.view removeFromSuperview];
        self.shareView = nil;
    }
    self.shareView =  [LBShareController showShareViewWithMessage:@"分享给自己的朋友"];
    self.shareView.shareImg = ((UIImageView *)[self createShareImageView:self.view]).image;
    self.shareView.beViewController = self;
    self.shareView.shareText = @"";
    [self.shareView showShareViewAnimation];
}
//获取当前屏幕图片
- (UIView *)createShareImageView:(UIView *)view{
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageview.image = image;
    return imageview;
}

//创建头部滑动View
- (UIView *)createHeadSlidingView{
    if (!self.selectedMenuView) {
        //添加选项栏
        self.selectedMenuView = [[SelectedMenu alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.size.width/2.0, 40) titleArray:@[@"关注",@"热门",@"最新"]];
        self.selectedMenuView.center = self.navigationController.navigationBar.center;
        self.selectedMenuView.changeTypeControllerDelegate = self;
        self.selectedMenuView.alpha = 1;
    }
    return self.selectedMenuView;
}

#pragma mark - 改变直播显示
- (void)changeTypeControllerWithIndex:(NSInteger)index{
    [self.centerScroller setContentOffset: CGPointMake(screenWidth * index, 0) animated:YES];
    for (int i = 0; i < self.selectedMenuView.btnArray.count; i++) {
        UIButton * button = (UIButton *)self.selectedMenuView.btnArray[i];
        if (i == index) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    LiveListControllerViewController *currentShowController = [_subControllers objectAtIndex:index];
    [currentShowController subViewReload];
}

@end
