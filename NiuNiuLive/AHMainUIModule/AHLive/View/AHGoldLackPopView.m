//
//  AHGoldLackPopView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHGoldLackPopView.h"

@interface AHGoldLackPopView ()

@property (weak, nonatomic) IBOutlet UIButton *gotoRechargeBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *lackgoldView;

@end

@implementation AHGoldLackPopView


+(id)shareGoldLackView{

    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{

    [super awakeFromNib];
    [self makeLayerBorderWidth:_gotoRechargeBtn];
    [self makeLayerBorderWidth:_closeBtn];
}

#pragma mark 展示view
- (void)showGoldLackView{
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 2.转化
    self.frame = window.bounds;
    [window addSubview: self];
}

#pragma mark -关闭view
- (void)dismissGoldView{

    [self removeFromSuperview];
}

//关闭屏幕
- (IBAction)closeLackView:(id)sender {
    
    [self dismissGoldView];
    
}

//充值
- (IBAction)lackGoldClick:(id)sender {
    
    
    
}

- (void)makeLayerBorderWidth:(UIView *)view{
    view.layer.borderWidth = 1.5;
    view.layer.cornerRadius = 1.0;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.masksToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if ([view isDescendantOfView:self.lackgoldView]) {
        return;
    }
    //关闭
    [self dismissGoldView];
}

@end
