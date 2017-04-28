//
//  AHColletionBaseVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHColletionBaseVC.h"
#import "MJRefresh.h"
#import "AHCustomHeader.h"
#import "AHCustomFooter.h"
#import "UICollectionView+AHCollectionViewEmptyPlaceHold.h"
@interface AHColletionBaseVC ()<ReloadNewData>
/**
 当前页面
 */
@property(nonatomic,assign)NSInteger page;
@end

@implementation AHColletionBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNewSourceArray];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 获取列表最新数据Array
 */
-(void)getNewSourceArray{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.colletionView.mj_header endRefreshing];
        [self.colletionView ah_reloadData];
    });
    
}

/**
 获取下一页数据array
 */
-(void)getMoreSourceArray{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.colletionView.mj_footer endRefreshing];
    });
}


/**
 创建UIColleviewView
 
 @param layout 布局方式
 @param frame frame
 */
-(void)createColltionView:(UICollectionViewLayout*)layout andFrame:(CGRect)frame{
    self.colletionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    self.colletionView.delegate = self;
    self.colletionView.dataSource = self;
    self.colletionView.backgroundColor = [UIColor clearColor];
    self.colletionView.mj_header = [AHCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewSourceArray)];
    self.colletionView.mj_footer = [AHCustomFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreSourceArray)];
    self.colletionView.placeHolderView = [[AHEmptyPlaceHoldView alloc]initWithIsHighLighted:NO andTitle:@"无数据" AndDelegate:self];
    [self.view addSubview:_colletionView];
}

-(void)reloadNewData{
    [self getNewSourceArray];
}

#pragma mark UICollectionViewDelegateAndDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceArray.count;
}


-(NSMutableArray*)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
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
