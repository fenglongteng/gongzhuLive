//
//  AHBankerToolView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBankerToolView.h"
#import "AHWinnerView.h"

@interface AHBankerToolView ()
@property (weak, nonatomic) IBOutlet UIButton *winnerBtn;//大赢家
@property (weak, nonatomic) IBOutlet UIButton *cageBtn;//插件

@end

@implementation AHBankerToolView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.winnerBtn.layer.cornerRadius = self.winnerBtn.height *0.5;
    self.cageBtn.layer.cornerRadius = self.cageBtn.height *0.5;
    
}
//点击工具栏的处理
// 关闭游戏  弹出消息  设置密码  屏幕切换
- (IBAction)bankerLiveToolBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate bankerToolViewButton:sender type:sender.tag];
    }
}

//插件的点击事件
- (IBAction)plugInClick:(id)sender {
    if (self.delegate) {
        [self.delegate bankerToolViewButton:sender type:ToolButtonPlug];
    }
}

//大赢家的点击事件
- (IBAction)winnerClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (self.delegate) {
        [self.delegate bankerToolViewButton:btn type:ToolButtonWinner];
    }
}

@end
