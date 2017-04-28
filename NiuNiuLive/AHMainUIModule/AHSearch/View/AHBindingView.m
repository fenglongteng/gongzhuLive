//
//  AHBindingView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBindingView.h"
#import "Masonry.h"

@interface AHBindingView ()

@property (nonatomic,strong)UIImageView *bingTypeImageView;

@property (nonatomic,strong)UIButton *button;

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UILabel *typeLabel;

@end

@implementation AHBindingView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self ) {
        [self addSubview:self.bingTypeImageView];
        [self addSubview:self.typeLabel];
        [self addSubview:self.label];
        [self addSubview:self.button];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    [self.bingTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@155);
        make.height.equalTo(@155);
        make.top.equalTo(@132);
        make.centerX.mas_equalTo(self);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bingTypeImageView.mas_bottom).offset(48);
         make.height.equalTo(@20);
        make.centerX.mas_equalTo(self);
    }];

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
        make.width.equalTo(@180);
    }];

    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(20);
        make.height.equalTo(@35);
        make.width.equalTo(@150);
        make.centerX.equalTo(self);
        
    }];
}

- (void)setBingType:(AHBingViewType)bingType
{
    _bingType = bingType;

    switch (bingType) {
        case AHBingPhone:
            self.typeLabel.text = @"绑定手机号";
          self.label.text = @"绑定通讯录，看看你的朋友都有谁已经入住了";
            [self.button setTitle:@"绑定手机号" forState:UIControlStateNormal];
          self.bingTypeImageView.image = [UIImage imageNamed:@"bg_search_phone"];
            break;
        case AHBingWeibo:
        self.typeLabel.text = @"绑定微博";
        self.label.text = @"请先绑定的微博账号，更多的微博好友正在来的路上";
        self.bingTypeImageView.image = [UIImage imageNamed:@"bg_search_weibo"];
            [self.button setTitle:@"绑定微博" forState:UIControlStateNormal];
            break;
        default:
         
            break;
    }
}

- (void)hideBingView{

    [self removeFromSuperview];
    
}

- (UIImageView *)bingTypeImageView{
    
    if (_bingTypeImageView == nil) {
        _bingTypeImageView = [[UIImageView alloc]init];
    }
    return _bingTypeImageView;
}

- (void)bingClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(bingAccount:)]) {
        
        [self.delegate bingAccount:self];
    }
}

- (UIButton *)button{
    
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        _button.layer.cornerRadius = 3;
        _button.layer.borderWidth = 1.5;
        _button.layer.borderColor= UIColorFromRGB(0x000000).CGColor;
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
        [_button addTarget:self action:@selector(bingClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:11.0];
        _label.numberOfLines = 2;
        _label.textColor = UIColorFromRGB(0xbebebe);
        _label.textAlignment = NSTextAlignmentCenter;
        
    }
    return _label ;
}

- (UILabel *)typeLabel{

    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _typeLabel.textColor = UIColorFromRGB(0x000000);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLabel;
}

@end
