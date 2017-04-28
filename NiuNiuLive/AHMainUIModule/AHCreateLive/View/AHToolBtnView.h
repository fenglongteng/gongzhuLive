//
//  AHToolBtnView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//  一个定义的基础工具按钮，上图下文本

#import "AHBaseView.h"

typedef NS_ENUM(NSInteger, AHToolButtonType) {
    AHToolButtonTypeChangeScreen = 0,//小屏切换
    AHToolButtonTypeCloseVoice,//关闭声音
    AHToolButtonTypeShareLive,//分享直播
    AHToolButtonTypeSendRedPacker,//塞红包
    AHToolButtonTypeChangeScene,//切换镜头
    AHToolButtonTypeOverturnScene,//翻转
    AHToolButtonTypeSoundEffect,//音效
    AHToolButtonTypeReverberation,//混响
};

@class AHToolBtnView;

@protocol AHToolButtonViewDelegate <NSObject>

- (void)toolButton:(AHToolBtnView*)toolView button:(UIButton *)tooButton label:(UILabel *)toolLabel;

@end

@interface AHToolBtnView : AHBaseView

@property (nonatomic,strong)UIButton *toolBtn;

@property (nonatomic,strong)UILabel *toolNameLb;

@property (nonatomic,assign)AHToolButtonType toolBtnType;

//网络获取
@property (nonatomic,strong)NSDictionary *dic;

@property(nonatomic,weak)id<AHToolButtonViewDelegate>delegate;

@end
