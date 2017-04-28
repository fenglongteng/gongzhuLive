//
//  AHBankerToolView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

typedef NS_ENUM(NSInteger, ToolButtonType) {
    ToolButtonPlug = 0, //插件
    ToolButtonWinner ,  // 大赢家
     ToolButtonMessage, //发送消息
     ToolButtonSecurity,  //密码设置
    ToolButtonScreen, // 切换屏幕
    ToolButtonGameClose,  // 关闭游戏
};


@protocol AHBankerToolViewDelegate <NSObject>

- (void)bankerToolViewButton:(UIButton *)button type:(NSInteger)buttonType;

@end

@interface AHBankerToolView : AHBaseView

@property (nonatomic,weak)id<AHBankerToolViewDelegate>delegate;

@end
