//
//  GiftController.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"

/**
 * 榜单分类
 */
typedef NS_ENUM(NSInteger, BangType) {
    giftBang = 1,   //礼物榜
    sendBang,    //送出榜
    sentimentBang   //人气榜
};

/**
 * 榜单周期分类
 */
typedef NS_ENUM(NSInteger, ListType) {
    weekList = 1,   //周榜
    monthList,    //月榜
    allList   //总榜
};

@protocol GiftControllerDelegate <NSObject>

@required

- (void)changeTitleBarListType:(NSInteger)currentPage;

@end

@interface GiftController : AHBaseViewController

/**
 *  月榜、周榜单滚动视图
 */
@property (nonatomic,strong)  UIScrollView * monthScroller;

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,weak)id<GiftControllerDelegate> delegate;

- (void)scrollingToListLocation:(NSInteger)index;

@end
