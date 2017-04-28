//
//  GLHBannerView.h
//  GLHBannerView
//
//  Created by glh on 17/1/11.
//  Copyright © 2017年 glh. All rights reserved.
//



#import <UIKit/UIKit.h>
@class CommodityDetailsModel;

@protocol ClickOnTheImage<NSObject>

-(void)clickOnTheImageOfIndex:(NSInteger)index;

@end
/**
下拉放大 有自动轮播图片 有自定义下拉试图功能
 */
@interface GLHBannerView : UIView


{
    UIPageControl *_pageCtrl;
    NSMutableArray *_imageUrlArray;
}
//一般接口传的多张图片是一个字符串 需要自己分成数组
-(void)showImageRotatorComponentWithImageArray:(NSArray *)imageUrlArray;
//自定义视图  下拉的时候有个，scroView从中间往两边放大，所以建立约束的时候不想试图往两边跑就要试图居中，且大小适应屏幕宽度。
-(void)customTableHeaderView:(UIView*)customHeaderView;
@property (nonatomic,weak)id<ClickOnTheImage> clickImageDelegate;
@property (nonatomic, strong) UIScrollView *bannerScrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat offSetY;


@end

