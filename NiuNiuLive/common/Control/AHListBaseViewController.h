//
//  LTListBaseViewController.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"
#import "GLHBannerView.h"
#import "UITableViewFreshAndLoad_Head.h"
@interface AHListBaseViewController : AHBaseViewController<UITableViewDelegate,UITableViewDataSource,ReloadNewData>

/**
 当前页面
 */
/** 开始游标 */
@property(nonatomic, assign) int32_t skip;

/** 页大小 */
@property(nonatomic, assign) int32_t limit;

/**
 列表TableView
 */
@property(nonatomic,strong)UITableView *listTableView;

/**
 list数据源数组
 */
@property(nonatomic,strong)NSMutableArray *sourceArray;
//初始化加载一次数据
@property(nonatomic,assign)BOOL loaded;

/**
 获取列表最新数据Array
 */
-(void)getNewSourceArray;

/**
 获取下一页数据array
 */
-(void)getMoreSourceArray;

/**
 创建tableView

 @param style tableView风格
 @param frame tableView frame
 */
-(void)createTableView:(UITableViewStyle)style andFrame:(CGRect)frame;


/**
 *  开启/关闭回到头部
 *
 *  @param toTop 返回顶部
 */
- (void)setScrollerToTop:(BOOL)toTop;


@end
