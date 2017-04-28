//
//  AHTabBar.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AHTabBar;

@protocol AHTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(AHTabBar *)tabBar;

@end

@interface AHTabBar : UITabBar

@property (nonatomic, weak) id<AHTabBarDelegate> delegate;

@end
