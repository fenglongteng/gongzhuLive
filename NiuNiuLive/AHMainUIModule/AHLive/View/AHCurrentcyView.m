//
//  AHCurrentcyView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHCurrentcyView.h"

@interface AHCurrentcyView ()

@property (weak, nonatomic) IBOutlet UILabel *ownAccountLb;//本家结算

@property (weak, nonatomic) IBOutlet UILabel *bankerAccountLb;//庄家结算

@property (weak, nonatomic) IBOutlet UIImageView *winImage;
@end

@implementation AHCurrentcyView

+ (id)currencyShareView{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)initFrame:(CGRect)frame{
    if (_winCoin < 0) {
        self.winImage.image = [UIImage imageNamed:@"bg_live_bjjs2"];
    }
    self.frame = frame;
    if (self.winCoin > 0) {
        self.ownAccountLb.text = [NSString stringWithFormat:@"本家 +%lld",self.winCoin];
    }else{
        self.ownAccountLb.text = [NSString stringWithFormat:@"本家 %lld",self.winCoin];
        self.ownAccountLb.textColor = [UIColor whiteColor];
    }
    if (self.banerCoin > 0) {
        self.bankerAccountLb.text = [NSString stringWithFormat:@"庄家 +%lld",self.banerCoin];
    }else{
        self.bankerAccountLb.text = [NSString stringWithFormat:@"庄家 %lld",self.banerCoin];
        self.bankerAccountLb.textColor = [UIColor whiteColor];
    }
}

@end
