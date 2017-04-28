//
//  LiveListControllerViewController.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"
#import "mainHeaderView.h"
#import "AHListBaseViewController.h"
/**
 * 首页分类
 */
typedef NS_ENUM(NSInteger, LiveType) {
    FocusLive = 1,   //关注直播
    HotLive,    //最热直播
    NewestLive   //最新直播
};

@interface LiveListControllerViewController : AHListBaseViewController

//头部视图
@property(nonatomic,strong)mainHeaderView * headerView;

- (instancetype)initWithFrame:(CGRect)frame LiveType:(LiveType)LiveType;

-(void)subViewReload;

@end
