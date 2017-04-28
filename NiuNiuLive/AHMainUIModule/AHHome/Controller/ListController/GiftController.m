//
//  GiftController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "GiftController.h"
#import "monthController.h"
#import "monthTypeView.h"
#import "AllListController.h"

@interface GiftController ()<UIScrollViewDelegate,monthTypeViewDelegate>{
    //frame
    CGRect selfFrame;
    //榜单数组
    NSArray * _monthControllers;
    //礼物周榜
    monthController * _giftWeekVC;
    //礼物月榜
    monthController * _giftMonthVC;
    //礼物总榜
    monthController * _giftAllVC;
    //送出周榜
    monthController * _sendWeekVC;
    //送出月榜
    monthController * _sendMonthVC;
    //送出总帮
    monthController * _sendAllVC;
    
}
@property(nonatomic,strong)monthTypeView * monthView;
//当前是否是送出榜页面
@property(nonatomic,assign)BOOL isSend;
@end

@implementation GiftController

- (UIScrollView *)monthScroller{
    if (!_monthScroller) {
        //主滚动
        _monthScroller = [[UIScrollView  alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _monthScroller.contentSize = CGSizeMake(self.monthScroller.width * 6, screenHeight);
        _monthScroller.showsHorizontalScrollIndicator = NO;
        _monthScroller.showsVerticalScrollIndicator = NO;
        _monthScroller.pagingEnabled = YES;
        _monthScroller.delegate = self;
        _monthScroller.backgroundColor = [UIColor clearColor];
        _monthScroller.scrollsToTop = NO;
        _monthScroller.bounces = NO;
        [_monthScroller setContentOffset:CGPointMake(0, 0)];
        //创建所有显示子控件
        [self createMonthControllers];
    }
    return _monthScroller;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        selfFrame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = selfFrame;
    [self.view addSubview:self.monthScroller];
    self.monthView = [[monthTypeView alloc] init];
    self.monthView.titleArray = @[@"周榜",@"月榜",@"总榜"];
    [self.monthView initWithFrame:CGRectMake(0, 0, screenWidth, 70) listType:weekList];
    self.monthView.delegate = self;
    [self.view addSubview:self.monthView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.monthView.width = screenWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)createMonthControllers{
 
    _giftWeekVC = [[monthController alloc] initWithFrame:CGRectMake(0, 0, screenWidth, self.monthScroller.height) bangType:giftBang listType:weekList];
       [self.monthScroller addSubview:_giftWeekVC.view];
    [_giftWeekVC subViewReload];
    _giftMonthVC = [[monthController alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftWeekVC.view.frame), 0, screenWidth, self.monthScroller.height) bangType:giftBang listType:monthList];
    [self.monthScroller addSubview:_giftMonthVC.view];
    _giftAllVC = [[monthController alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftMonthVC.view.frame), 0, screenWidth, self.monthScroller.height) bangType:giftBang listType:allList];
    [self.monthScroller addSubview:_giftAllVC.view];
    _sendWeekVC = [[monthController alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftAllVC.view.frame), 0, screenWidth, self.monthScroller.height) bangType:sendBang listType:weekList];
    [self.monthScroller addSubview:_sendWeekVC.view];
    _sendMonthVC = [[monthController alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sendWeekVC.view.frame), 0, screenWidth, self.monthScroller.height) bangType:sendBang listType:monthList];
    [self.monthScroller addSubview:_sendMonthVC.view];
    _sendAllVC = [[monthController alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sendMonthVC.view.frame), 0, screenWidth, self.monthScroller.height) bangType:sendBang listType:allList];
    [self.monthScroller addSubview:_sendAllVC.view];
    
    _monthControllers = [NSArray arrayWithObjects:_giftWeekVC,_giftMonthVC,_giftAllVC,_sendWeekVC,_sendMonthVC,_sendAllVC, nil];
}

- (void)scrollingToListLocation:(NSInteger)index{
    if (index == 0) {
        [self.monthScroller setContentOffset:CGPointMake(0, 0) animated:YES];
        [_giftWeekVC subViewReload];
        _isSend = NO;
    }else if (index == 1){
        [self.monthScroller setContentOffset:CGPointMake(screenWidth * 3, 0) animated:YES];
        _isSend = YES;
        [_sendWeekVC subViewReload];
    }
    [self.monthView changeSelectedView:0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.width;
    [self.delegate changeTitleBarListType:page];
    if (page > 2) {
        _isSend = YES;
        [self.monthView changeSelectedView:page - 3];
    }else{
        _isSend = NO;
        [self.monthView changeSelectedView:page];
    }
    monthController *currentShowController = [_monthControllers objectAtIndex:page];
    [currentShowController subViewReload];
    
}

- (void)changeMonthType:(NSInteger)index{
    if (_isSend == YES) {
        [self.monthScroller setContentOffset:CGPointMake(screenWidth * (index + 3),0) animated:YES];
        monthController *currentShowController = [_monthControllers objectAtIndex:index + 3];
        [currentShowController subViewReload];
    }else if(_isSend == NO){
        [self.monthScroller setContentOffset:CGPointMake(screenWidth * index ,0) animated:YES];
        monthController *currentShowController = [_monthControllers objectAtIndex:index];
        [currentShowController subViewReload];
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
