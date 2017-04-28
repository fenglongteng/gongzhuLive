//
//  AHRechargeView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHRechargeView.h"
#import "NSString+Tool.h"

@interface AHRechargeView ()

@property (nonatomic,strong)UIButton *currentSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *meSpeciesLb;//金币数
@property (weak, nonatomic) IBOutlet UIImageView *rechargeImageV;
@property (weak, nonatomic) IBOutlet UIView *rechBackView;

@end

@implementation AHRechargeView

+ (id)rechargeShareView{

 return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];

}

- (void)setGoldCoin:(int64_t)goldCoin{

    _goldCoin = goldCoin;
    self.meSpeciesLb.text = [NSString stringWithFormat:@"当前游戏币:%@",[NSString getCurrentGold:goldCoin]];
}

- (void)dismissRecharge{
    
    if (self.closeRecherView) {
        self.closeRecherView();
    }
}

//关闭充值界面
- (IBAction)closeRecharge:(id)sender {
    
    [self dismissRecharge];
}

//充值按钮 进行充值
- (IBAction)rechargeClick:(id)sender {
    //根据tag 进行充值 1为18元 2 为98 3 为288 4为588
//    self.currentSelectBtn.tag
    [self dismissRecharge];
}

//充值金额的选择
- (IBAction)rechargeSelect:(UIButton *)sender {
    
    if (self.currentSelectBtn == sender) {
        return;
    }
    self.currentSelectBtn.selected = NO;
    
    sender.selected = !sender.selected;
     self.currentSelectBtn = sender;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    UIView *touchView = touch.view;
    if ([touchView isDescendantOfView:self.rechargeImageV] || [touchView isDescendantOfView:self.rechBackView]) {
        return;
    }
    [self dismissRecharge];
}

- (void)dealloc{

    LOG(@"%s",__func__);
}

@end
