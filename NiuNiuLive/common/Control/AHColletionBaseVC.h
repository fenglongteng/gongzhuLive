//
//  AHColletionBaseVC.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"

@interface AHColletionBaseVC : AHBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 列表TableView
 */
@property(nonatomic,strong)UICollectionView *colletionView;

/**
 list数据源数组
 */
@property(nonatomic,strong)NSMutableArray *sourceArray;


/**
 获取列表最新数据Array
 */
-(void)getNewSourceArray;

/**
 获取下一页数据array
 */
-(void)getMoreSourceArray;

/**
 创建UIColleviewView

 @param layout 布局方式
 @param frame frame
 */
-(void)createColltionView:(UICollectionViewLayout*)layout andFrame:(CGRect)frame;


@end
