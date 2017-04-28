//
//  monthTypeView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "monthTypeView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface monthTypeView(){
    CGFloat _buttonWidth;
}

@property(nonatomic,strong)UIView * selectedView;

@end

@implementation monthTypeView

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}

- (void)initWithFrame:(CGRect)frame listType:(ListType)listType{
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    //毛玻璃视图
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    visualEffectView.frame = self.frame;
    visualEffectView.alpha = 0.9;
    [self addSubview:visualEffectView];
    
    //底层view
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 40, 40)];
    backView.center = self.center;
    backView.backgroundColor = [UIColor colorWithRed:92/255.0 green:45/255.0 blue:155/255.0 alpha:1.0];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 20;
    [self addSubview:backView];
    
    //选择按钮
    CGFloat btnWidth = (screenWidth - 40) / 3.0;
    
    //选中View
    UIView * selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth, 40)];
    selectedView.backgroundColor = [UIColor colorWithRed:178/255.0 green:64/255.0 blue:250/255.0 alpha:1.0];
    selectedView.clipsToBounds = YES;
    selectedView.layer.cornerRadius = 20;
    [backView addSubview:selectedView];
    self.selectedView = selectedView;
    
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = _titleArray[i];
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:13.0 * screenWidth / 320 weight:0.2];
        selectBtn.backgroundColor = [UIColor clearColor];
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectBtn setTitle:title forState:UIControlStateNormal];
        selectBtn.frame = CGRectMake(i * btnWidth, 0, btnWidth, 40);
        [selectBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:selectBtn];
        [self.btnArray addObject:selectBtn];
    }

}

/**
 *  选中按钮
 *
 *  @param btn 按钮
 */
- (void)selected:(UIButton *)btn{
    NSInteger index = [self.btnArray indexOfObject:btn];
    [self changeSelectedView:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeMonthType:)]) {
        [self.delegate changeMonthType:index];
    }
}

- (void)changeSelectedView:(NSInteger)index{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedView.x = ((UIButton *)self.btnArray[index]).x;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
