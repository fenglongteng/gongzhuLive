//
//  AHAnchorLiveSettingView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/25.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHAnchorLiveSettingView.h"
#import "AHToolBtnView.h"

@interface AHAnchorLiveSettingView ()<AHToolButtonViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *toolScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *gameScrollView;
@property (weak, nonatomic) IBOutlet UIView *toolView;

@end

@implementation AHAnchorLiveSettingView

+(id)shareAnchorLiveSetting{

   return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self createSetToolButton];
}

- (void)createSetToolButton{
   
    for (int i =0; i<8; i++) {
    
        AHToolBtnView *toolBtnView = [[AHToolBtnView alloc]initWithFrame:CGRectMake(i*65, 0, 65, self.toolScrollView.height)];
        toolBtnView.toolBtnType = i;
        toolBtnView.delegate = self;
        [self.toolScrollView addSubview:toolBtnView];
    }
    self.toolScrollView.contentSize = CGSizeMake(65*8, 0);
    
    AHToolBtnView * gameBtnView = [[AHToolBtnView alloc]initWithFrame:CGRectMake(0, 0, 65, self.toolScrollView.height)];
    [gameBtnView.toolBtn setImage:[UIImage imageNamed:@"gameLogo.jpg"] forState:UIControlStateNormal];
    gameBtnView.toolNameLb.text = @"百人牛牛";
    gameBtnView.toolBtnType = 99;
    gameBtnView.delegate = self;
    [self.gameScrollView addSubview:gameBtnView];
}

- (void)showAnchorLiveSetView{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    [window addSubview: self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if ([view isDescendantOfView:self.toolView]) {
        return;
    }
    [self dismiss];
}

- (void)dismiss{

    [self removeFromSuperview];
}

#pragma mark -AHToolButtonViewDelegate

- (void)toolButton:(AHToolBtnView *)toolView button:(UIButton *)tooButton label:(UILabel *)toolLabel{
    
    if (self.toolBtnBlock) {
        self.toolBtnBlock(toolView);
    }

}

- (void)dealloc{

    LOG(@"%s",__func__);

}

@end
