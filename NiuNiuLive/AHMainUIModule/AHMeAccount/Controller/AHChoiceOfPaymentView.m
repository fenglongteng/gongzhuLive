//
//  AHChoiceOfPaymentView.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHChoiceOfPaymentView.h"

@implementation AHChoiceOfPaymentView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _contentView  = [[NSBundle mainBundle]loadNibNamed:@"AHChoiceOfPaymentView" owner:self options:0].firstObject;
        [self addSubview:_contentView];
        _contentView.frame = frame;
        [self setUpView];
        self.frame = frame;
    }
    return self;
}

-(void)setUpView{
    [self.topView addTarget:self action:@selector(dismiss:)];
    [self.weixinVIew addTarget:self action:@selector(pushWeixin)];
    [self.zhifubaoView addTarget:self action:@selector(pushZhiFuBao)];
    self.topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
}

//消失
- (IBAction)dismiss:(id)sender {
    self.topView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//消失
- (IBAction)bt_dimissAction:(UIButton *)sender {
    [self dismiss:nil];
}

-(void)showOnTheWindow{
    self.contentView.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
    [[AppDelegate getAppdelegateWindow] addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    } completion:^(BOOL finished) {
        
    }];

}

//跳转微信
-(void)pushWeixin{
    
}

//支付宝
-(void)pushZhiFuBao{
    
}



//微信公众号
- (IBAction)pushWeChatPublicNo:(id)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
