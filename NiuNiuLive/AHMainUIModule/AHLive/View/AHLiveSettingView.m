//
//  AHLiveSettingView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLiveSettingView.h"

@interface AHLiveSettingView ()
@property (weak, nonatomic) IBOutlet UILabel *historyGainsLb;//历史战绩
@property (weak, nonatomic) IBOutlet UILabel *closeVoiceLb;
@property (weak, nonatomic) IBOutlet UILabel *packUpGameLb;
@property (weak, nonatomic) IBOutlet UILabel *closeLiveLb;
@property (weak, nonatomic) IBOutlet UILabel *liveScreenLb;//直播屏幕切换
@property (weak, nonatomic) IBOutlet UIView *setView;
@property (weak,nonatomic)IBOutlet UIButton *showGameBtn;//展开游戏
@end

@implementation AHLiveSettingView

+(id)liveSetingShare{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
}

- (void)showAnimation{
    
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.setView.transform = CGAffineTransformMakeTranslation(0, -self.setView.height);
    } completion:^(BOOL finished) {
    }];
}

- (void)setIsShowGame:(BOOL)isShowGame{
    _isShowGame= isShowGame;
    self.showGameBtn.selected = isShowGame;
    self.packUpGameLb.text = isShowGame?@"展开游戏":@"收起游戏";
}

- (void)setIsNoGame:(BOOL)isNoGame{

    _isNoGame = isNoGame;

}

- (void)hideAnimation{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.setView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

//历史战绩
- (IBAction)historyGainsClick:(UIButton *)sender {
    
     [self hideAnimation];
    if (self.historyGainsBlock) {
        self.historyGainsBlock();
    }
}

//关闭声音
- (IBAction)closeVoiceClick:(UIButton *)sender {
    sender.selected = !sender.selected;
     [self hideAnimation];
}

//收起游戏
- (IBAction)packupGame:(UIButton *)sender {
#warning 根据游戏的展开场景进行设置  和是否正在游戏进行是否可以能点击
    sender.selected = !sender.selected;
    self.packUpGameLb.text = sender.selected?@"展开游戏":@"收起游戏";
    [self hideAnimation];
    if (sender.selected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifiGameSwipeDown object:nil];
    }
    else{
     [[NSNotificationCenter defaultCenter]postNotificationName:kNotifiGameSwipeUp object:nil];
    }
}

//关闭直播
- (IBAction)closeLive:(UIButton *)sender {
    
    sender.selected = !sender.selected;
     [self hideAnimation];
    
}

//切换屏幕
- (IBAction)switchoverLiveScreen:(UIButton *)sender {
    
    sender.selected = !sender.selected;
     [self hideAnimation];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if ([view isDescendantOfView:self.setView]) {
        return;
    }
    [self hideAnimation];
}



- (void)dealloc{

    LOG(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
