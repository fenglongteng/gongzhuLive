//
//  SelectedMenu.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  改变主题显示
 */
@protocol ChangeTypeControllerDelegate <NSObject>

@required
-(void)changeTypeControllerWithIndex:(NSInteger) index;

@end

/**
 *  选择菜单栏
 */
@interface SelectedMenu : UIView

/**
 *  改变主题显示容器
 */
@property (weak, nonatomic) id<ChangeTypeControllerDelegate > changeTypeControllerDelegate;
/**
 *  按钮数组
 */
@property (strong, nonatomic) NSMutableArray *btnArray;
/**
 *  当前选中按钮标题
 */
@property (strong, nonatomic, readonly)  NSString * _Nonnull selectedTitle;

/**
 *  当前选中的按钮索引
 */
@property (assign, nonatomic, readwrite) NSInteger  currentIndex;

/**
 *  改变选中视图位置
 *
 *  @param index 位置
 */
- (void)changeSelectedWithIndex:(NSInteger)index;

/**
 *  初始化homeheadView
 *
 *  @param frame  frame
 *  @param titles 标题
 *  @param color 选中颜色
 *  @return self
 */
- (nonnull instancetype)initWithFrame:(CGRect)frame titleArray:( NSArray * _Nonnull )titles selectedColor:(UIColor * _Nonnull)color;
/**
 *  初始化homeheadView
 *
 *  @param frame  frame
 *  @param titles 标题
 *  @return self
 */
- (nonnull instancetype)initWithFrame:(CGRect)frame titleArray:( NSArray * _Nonnull )titles;

@end

