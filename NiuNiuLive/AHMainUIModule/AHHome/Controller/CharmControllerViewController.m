//
//  CharmControllerViewController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "CharmControllerViewController.h"
#import "GiftController.h"
#import "AllListController.h"

@interface CharmControllerViewController ()<ChangeTypeControllerDelegate,UIScrollViewDelegate,GiftControllerDelegate>{
    //子界面数组，先把controller声明
    NSArray *_giftControllers;
    //礼物和送出榜界面
    GiftController * _weekAndSendVC;
    //人气榜界面
    AllListController * _allVC;
}

/**
 *  内容滚动视图
 */
@property (nonatomic,strong)  UIScrollView * listScroller;

@end

@implementation CharmControllerViewController

- (UIScrollView *)listScroller{
    if (!_listScroller) {
        //主滚动
        _listScroller = [[UIScrollView  alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _listScroller.contentSize = CGSizeMake(self.listScroller.width * 2, screenHeight);
        _listScroller.showsHorizontalScrollIndicator = NO;
        _listScroller.showsVerticalScrollIndicator = NO;
        _listScroller.pagingEnabled = YES;
        _listScroller.delegate = self;
        _listScroller.backgroundColor = BYColor(236,237,239);
        _listScroller.scrollsToTop = NO;
        _listScroller.bounces = NO;
        [_listScroller setContentOffset:CGPointMake(0, 0)];
        //创建所有显示子控件
        [self createGiftControllers];
    }
    return _listScroller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBarTintColor:[UIColor whiteColor]];
    [self setLeftButtonBarItemImage:@"btn_home_arrow" highlightImage:@"btn_home_arrow" target:self action:@selector(popToLastViewController)];
    [self setTitleView:[self createHeadSlidingView]];
    [self.view addSubview:self.listScroller];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建头部滑动View
- (UIView *)createHeadSlidingView{
    if (!self.selectedMenuView) {
        //添加选项栏
        self.selectedMenuView = [[SelectedMenu alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.size.width/2.0, 40) titleArray:@[@"礼物榜",@"送出榜",@"人气榜"] selectedColor:BYColor(70, 0, 147)];
        self.selectedMenuView.center = self.navigationController.navigationBar.center;
        self.selectedMenuView.changeTypeControllerDelegate = self;
        self.selectedMenuView.alpha = 1;
    }
    return self.selectedMenuView;
}

- (void)popToLastViewController{
    [[AppDelegate getNavigationTopController].navigationController popViewControllerAnimated:YES];
}

#pragma mark SelectedMenuDelegate

- (void)changeTypeControllerWithIndex:(NSInteger)index{
    if (index == 2) {
        [self.listScroller setContentOffset: CGPointMake(screenWidth * 1, 0) animated:YES];
        [_allVC subViewReload];
    }else{
        [self.listScroller setContentOffset:CGPointMake(0, 0) animated:YES];
        [_weekAndSendVC scrollingToListLocation:index];
    }
    [self monthListControlBangList:index];
}

- (void)monthListControlBangList:(NSInteger)index{
    for (int i = 0; i < self.selectedMenuView.btnArray.count; i++) {
        UIButton * button = (UIButton *)self.selectedMenuView.btnArray[i];
        if (i == index) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
}

- (void)createGiftControllers{
    _weekAndSendVC = [[GiftController alloc] initWithFrame:CGRectMake(0, 0, self.listScroller.width, self.listScroller.height)];
    _weekAndSendVC.delegate = self;
    [self.listScroller addSubview:_weekAndSendVC.view];
    _allVC = [[AllListController alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_weekAndSendVC.view.frame), 0, self.listScroller.width, self.listScroller.height)];
    [self.listScroller addSubview:_allVC.view];
    
    _giftControllers = [NSArray arrayWithObjects:_weekAndSendVC,_allVC, nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.width;
    if (page == 1) {
        [self.selectedMenuView changeSelectedWithIndex:page + 1];
        [self monthListControlBangList:2];
        [_allVC subViewReload];
    }else{
        [self.selectedMenuView changeSelectedWithIndex:page + 1];
        [self monthListControlBangList:1];
        [_weekAndSendVC scrollingToListLocation:1];
    }
}

#pragma mark GiftControllerDelegate

- (void)changeTitleBarListType:(NSInteger)currentPage{
    if (currentPage > 2) {
        [self.selectedMenuView changeSelectedWithIndex:1];
        [self monthListControlBangList:1];
    }else if (currentPage <= 2){
        [self.selectedMenuView changeSelectedWithIndex:0];
        [self monthListControlBangList:0];
    }
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
