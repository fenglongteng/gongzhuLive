//
//  AHToolBtnView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHToolBtnView.h"

@interface AHToolBtnView ()

@end

@implementation AHToolBtnView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.toolBtn];
        [self addSubview:self.toolNameLb];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.toolBtn.frame = CGRectMake(0, 10, self.width, self.width);
    self.toolNameLb.frame = CGRectMake(0, CGRectGetMaxY(self.toolBtn.frame), self.width, 15);
}

- (UIButton *)toolBtn{

    if (!_toolBtn) {
        _toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolBtn addTarget:self action:@selector(tooBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolBtn;
}

- (void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
}

- (void)tooBtnClick:(UIButton *)btn{
    //点击了工具栏
    if ([self.delegate respondsToSelector:@selector(toolButton:button:label:)]) {
        
        [self.delegate toolButton:self button:btn label:self.toolNameLb];
    }
    
    btn.selected = !btn.selected;
    if (self.toolBtnType == AHToolButtonTypeCloseVoice) {
        if (btn.selected) {
            _toolNameLb.text = @"打开声音";
        }else{
        _toolNameLb.text = @"关闭声音";
        }
    }
    if (self.toolBtnType == AHToolButtonTypeChangeScreen) {
        if (btn.selected) {
            _toolNameLb.text = @"小屏直播";
        }else{
            _toolNameLb.text = @"大屏直播";
        }
    }
        
}

- (void)setToolBtnType:(AHToolButtonType)toolBtnType{
    
    _toolBtnType = toolBtnType;
    
    switch (toolBtnType) {
        case AHToolButtonTypeCloseVoice:
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_shenying0"] forState:UIControlStateNormal];
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_shenying1"] forState:UIControlStateSelected];
            _toolNameLb.text = @"关闭声音";
            break;
        case AHToolButtonTypeChangeScreen:
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_small0"] forState:UIControlStateNormal];
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_small1"] forState:UIControlStateSelected];
            _toolNameLb.text = @"小屏直播";
            break;
        case AHToolButtonTypeShareLive:
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_share0"] forState:UIControlStateNormal];
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_small1"] forState:UIControlStateHighlighted];
            _toolNameLb.text = @"分享直播";
            break;
        case AHToolButtonTypeSendRedPacker:
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_redbar0"] forState:UIControlStateNormal];
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_redbar1"] forState:UIControlStateHighlighted];
            _toolNameLb.text = @"塞红包";
            break;
        case AHToolButtonTypeChangeScene:
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_qhjt0"] forState:UIControlStateNormal];
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_qhjt1"] forState:UIControlStateHighlighted];
            _toolNameLb.text = @"切换镜头";
            break;
        case AHToolButtonTypeOverturnScene:
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_jxjt0"] forState:UIControlStateNormal];
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_jxjt1"] forState:UIControlStateHighlighted];
            _toolNameLb.text = @"镜像翻转";
            break;
        case AHToolButtonTypeSoundEffect:
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_hhyx0"] forState:UIControlStateNormal];
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_hhyx1"] forState:UIControlStateHighlighted];
            _toolNameLb.text = @"氛围音效";
            break;
        case AHToolButtonTypeReverberation:
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_hyxg0"] forState:UIControlStateNormal];
            [_toolBtn setImage:[UIImage imageNamed:@"bg_lse_hyxg1"] forState:UIControlStateHighlighted];
            _toolNameLb.text = @"话筒混响";
            break;
        default:
            break;
    }
}

- (UILabel *)toolNameLb{

    if (!_toolNameLb) {
        _toolNameLb = [[UILabel alloc]init];
        _toolNameLb.font = [UIFont systemFontOfSize:10.0];
        _toolNameLb.textColor = UIColorFromRGB(0x4c4c4c);
        _toolNameLb.textAlignment = NSTextAlignmentCenter;
    }
    return _toolNameLb;
}

@end
