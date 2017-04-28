//
//  AHFinalGiftButton.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/31.
//  Copyright © 2017年 AH. All rights reserved.
// 结算礼物按钮

#import "AHFinalGiftButton.h"
#import "NSString+Tool.h"

@interface AHFinalGiftButton ()

@property (nonatomic,strong)UIImageView *giftImageView;

@property (nonatomic,strong)UIImageView *goldImageView;

@property (nonatomic,strong)UILabel *giftPriceLb;

@end

@implementation AHFinalGiftButton

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.goldImageView];
      [self.goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.height.equalTo(@10);
          make.bottom.equalTo(self).offset(-5);
          make.leading.equalTo(self).offset(5);
      }];
    [self addSubview:self.giftPriceLb];
    [self.giftPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.trailing.equalTo(self);
        make.width.equalTo(@40);
        make.bottom.equalTo(self);
    }];
    [self addSubview:self.giftImageView];
        [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.height.equalTo(@50);
            make.centerX.equalTo(self);
        }];
}


- (void)setGiftModel:(Gift *)giftModel{
    _giftModel = giftModel;
    [self.giftImageView sd_setImageWithURL:[NSString getImageUrlString:giftModel.icon]];
    self.giftPriceLb.text = [self getCurrentGoldStringWithCoin:giftModel.goldCoins];
}

- (UIImageView *)giftImageView{

    if (_giftImageView == nil) {
        _giftImageView = [[UIImageView alloc]init];
    }

    return _giftImageView;
}

- (UIImageView *)goldImageView{
    
    if (_goldImageView == nil) {
        _goldImageView = [[UIImageView alloc]init];
        _goldImageView.image =[UIImage imageNamed:@"icon_zb_gold"];
    }
    return _goldImageView;
}

- (UILabel *)giftPriceLb{

    if (!_giftPriceLb) {
        _giftPriceLb = [[UILabel alloc]init];
        _giftPriceLb.font = [UIFont systemFontOfSize:8.0];
        _giftPriceLb.textColor = [UIColor whiteColor];
    }
    return _giftPriceLb;
}

- (NSString *)getCurrentGoldStringWithCoin:(int64_t)coin{
    if (coin >= 10000) {
        return [NSString stringWithFormat:@"%.2fW",coin / 10000.0];
    }else{
        return [NSString stringWithFormat:@"%lld",coin];
    }
}


@end
