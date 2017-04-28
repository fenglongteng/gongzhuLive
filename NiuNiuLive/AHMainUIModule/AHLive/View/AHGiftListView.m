//
//  AHGiftListView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/25.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHGiftListView.h"
#import "NSString+Tool.h"

@interface AHGiftListView ()

@property (nonatomic,strong)UIImageView *backImageView;//背景图片
@property (nonatomic,strong)UIImageView *giftImageView;//礼物图片
@property (nonatomic,strong)UILabel *giftNameLb;//礼物名称
@property (nonatomic,strong)UIImageView *iconImageView;//金币的图片
@property (nonatomic,strong)UILabel *giftPriceLb;//礼物的价格
@property (nonatomic,strong)AHGiftListView *selectGiftView;//当前选择的礼物

@end

@implementation AHGiftListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(giftSelect:)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.giftImageView];
        [self addSubview: self.selctImageV];
        [self addSubview:self.giftNameLb];
        [self addSubview:self.iconImageView];
        [self addSubview:self.giftPriceLb];
    }
    return self;
}

- (void)giftSelect:(UITapGestureRecognizer *)gesture{
    //选中点击
    AHGiftListView *gesturView = (AHGiftListView*)gesture.view;
    self.selectGiftView = gesturView;
    if (self.giftSelectBlock) {
        self.giftSelectBlock(self.selectGiftView);
    }
}

- (void)setIsSelect:(BOOL)isSelect{

    _isSelect = isSelect;
    UIImage *image = nil;
    if (self.gift.allowContinue) {
        image = [UIImage imageNamed:@"btn_gift_oo"];
    }
    self.selctImageV.image = isSelect?[UIImage imageNamed:@"btn_gift_ok"]:image;
    
}

- (void)setGift:(Gift *)gift{

    _gift = gift;
    self.giftNameLb.text = gift.name;
    NSString *price = gift.goldCoins/10000>0?[NSString stringWithFormat:@"%.1fW",gift.goldCoins/10000.0]:[NSString stringWithFormat:@"%.fK",gift.goldCoins/1000.0];
    self.giftPriceLb.text = price;
    [self.giftImageView sd_setImageWithURL:[NSString getImageUrlString:gift.icon] placeholderImage:nil];
    self.selctImageV.image = gift.allowContinue?[UIImage imageNamed:@"btn_gift_oo"]:nil;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.giftImageView.frame  = CGRectMake(0, 5, 55, 55);
    self.giftImageView.centerX = self.width *0.5;
    self.giftNameLb.frame = CGRectMake(0, CGRectGetMaxY(self.giftImageView.frame), self.width, 15);
    [self.selctImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.trailing.equalTo(self).offset(-5);
    }];
    self.giftPriceLb.frame = CGRectMake(5, CGRectGetMaxY(self.giftNameLb.frame), self.width, 15);
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@10);
        make.centerY.equalTo(self.giftPriceLb);
        make.centerX.equalTo(self.giftPriceLb).offset(-20);
    }];
}

- (UIImageView *)iconImageView{

    if (!_iconImageView ) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"icon_zb_gold"];
    }
    return _iconImageView;
}

- (UILabel *)giftNameLb{

    if (_giftNameLb==nil) {
        _giftNameLb = [[UILabel alloc]init];
        _giftNameLb.textColor = [UIColor whiteColor];
        _giftNameLb.font = [UIFont boldSystemFontOfSize:10.0];
        _giftNameLb.textAlignment = NSTextAlignmentCenter;
    }
    return _giftNameLb;
}

- (UILabel *)giftPriceLb{
    
    if (_giftPriceLb==nil) {
        _giftPriceLb = [[UILabel alloc]init];
        _giftPriceLb.textColor =UIColorFromRGB(0xfff600);
        _giftPriceLb.font = [UIFont boldSystemFontOfSize:9.0];
        _giftPriceLb.textAlignment = NSTextAlignmentCenter;
        _giftPriceLb.text = @"2K";
    }
    return _giftPriceLb;
}

- (UIImageView *)selctImageV{
    
    if (_selctImageV == nil) {
        _selctImageV = [[UIImageView alloc]init];
        _selctImageV.size = _selctImageV.image.size;
    }
    return _selctImageV ;
}

- (UIImageView *)giftImageView{
    
    if (_giftImageView == nil) {
        _giftImageView = [[UIImageView alloc]init];
        _giftImageView.userInteractionEnabled = YES;

    }
    return _giftImageView ;
}

- (UIImageView *)backImageView{

    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.userInteractionEnabled = YES;
//        _backImageView.image = [UIImage imageNamed:@"bg_gift_bg"];
    }
    return _backImageView ;
}

@end
