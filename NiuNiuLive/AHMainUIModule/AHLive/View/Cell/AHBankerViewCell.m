//
//  AHBankerViewCell.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBankerViewCell.h"

@interface AHBankerViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *bankerNameLb;

@property (weak, nonatomic) IBOutlet UILabel *bankerGoldLb;


@end

@implementation AHBankerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = self.backView.height *0.5;
    self.backView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMessageModel:(DouNiuBanker *)model{
    if (model.coin >= 100000000) {
        self.bankerGoldLb.text = [NSString stringWithFormat:@"%.2f亿",model.coin / 100000000.0];
    }else if(model.coin >= 10000.0){
        self.bankerGoldLb.text = [NSString stringWithFormat:@"%.2fW",model.coin / 10000.0];
    }else{
        self.bankerGoldLb.text = [NSString stringWithFormat:@"%lld",model.coin];
    }
    self.bankerNameLb.text = model.nickName;
}

@end
