//
//  AHCurrencySuccessView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHCurrencySuccessView : AHBaseView

@property(nonatomic,assign)int64_t winCoin;

@property(nonatomic,assign)int64_t bankerCoin;

+(id)currencySuccessShareView;

- (void)setWinMessage:(NSArray *)giftsArray winCoin:(int64_t)coin;

@end
