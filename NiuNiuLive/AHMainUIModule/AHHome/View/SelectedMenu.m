//
//  SelectedMenu.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "SelectedMenu.h"

//左右2边边距
static CGFloat margin  = 10.f;

//每个按钮之间的宽度
static CGFloat btnPadding = 5.f;

//选中视图的高度
static CGFloat selectedViewHeight = 2.f;

@interface SelectedMenu ()
{
    //按钮总数
    NSInteger _btnCount;
    
    //按钮标题
    NSArray *_titles;
    
    //上一个选中的按钮
    UIButton *_fristBtn;
    
    //偏移总数
    CGFloat _offsetY;
    //选中颜色
    UIColor * _selectedColor;
}

/**
 *  选中标示view
 */
@property (strong, nonatomic) UIView *selectedView;

/**
 *  view的偏移量
 */
@property (assign,nonatomic) CGPoint viewPoint;
/**
 *  button宽度
 */
@property (assign,nonatomic) CGFloat buttonWidth;

@end


@implementation SelectedMenu

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:( NSArray * _Nonnull )titles selectedColor:(UIColor * _Nonnull)color{
    _titles = titles;
    _selectedColor = color;
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    //添加选项栏
    [self createSelectedBtn];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame titleArray:( NSArray * _Nonnull )titles{
    _titles = titles;
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    //添加选项栏
    [self createSelectedBtn];
    return self;
}

#pragma mark - 创建视图部分

/**
 *  创建选中视图
 *
 *  @param width 选中视图宽度
 */
- (void)createLineViewWithWidth:(CGFloat)width{
    self.selectedView = [[UIView  alloc] initWithFrame:CGRectMake(0, self.height - selectedViewHeight, width, selectedViewHeight)];
    if (_selectedColor) {
        self.selectedView.x = ((UIButton *)self.btnArray[0]).x+5;
        _fristBtn = self.btnArray[0];
        _fristBtn.selected = YES;
    }else{
        self.selectedView.x = ((UIButton *)self.btnArray[1]).x+5;
        _fristBtn = self.btnArray[1];
        _fristBtn.selected = YES;
    }
    if (_selectedColor) {
        self.selectedView.backgroundColor = _selectedColor;
    }else{
        self.selectedView.backgroundColor = BYColor(253, 209, 53);
    }
    [self addSubview:self.selectedView];
}

/**
 *  创建选择按钮
 */
- (void)createSelectedBtn{
    //按钮的宽度
    CGFloat btnWidth = (self.frame.size.width - margin * 2 - ((_titles.count - 1) * 5)) / _titles.count;
    _buttonWidth = btnWidth;
    //生成按钮
    for (int i = 0 ; i < _titles.count; i++) {
        CGFloat leftPadding = i * btnPadding;
        NSString *title = _titles[i];
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:13.0 * screenWidth / 320 weight:0.2];
        if (_selectedColor) {
            [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [selectBtn setTitleColor:BYColor(99, 51, 160) forState:UIControlStateSelected];
        }else{
            [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [selectBtn setTitleColor:BYColor(253, 209, 53) forState:UIControlStateSelected];
        }
        [selectBtn setTitle:title forState:UIControlStateNormal];
        selectBtn.frame = CGRectMake(margin + leftPadding + i * btnWidth, self.height - 40, btnWidth, 40);
        [selectBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectBtn];
        [self.btnArray addObject:selectBtn];
    }
    _selectedTitle = _titles[1];
    [self createLineViewWithWidth:btnWidth-10];
    
}

/**
 *  选中按钮
 *
 *  @param btn 按钮
 */
- (void)selected:(UIButton *)btn{
    NSInteger index = [self.btnArray indexOfObject:btn];
    if (_fristBtn != btn) {
        _fristBtn.selected = NO;
        _fristBtn = btn;
        btn.selected = YES;
    }
    [self changeSelectedWithIndex:index];
    if ([self.changeTypeControllerDelegate respondsToSelector:@selector(changeTypeControllerWithIndex:)]) {
        [self.changeTypeControllerDelegate changeTypeControllerWithIndex:index];
    }
}

/**
 *  改变选择按钮
 *
 *  @param index index
 */
- (void)changeSelectedWithIndex:(NSInteger)index{
    //记录当前选中坐标
    _currentIndex = index;
    _selectedTitle = _titles[index];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedView.x = ((UIButton *)self.btnArray[index]).x+5;
    }];
}

@end
