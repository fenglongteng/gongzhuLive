//
//  AHCurrentcyView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHCurrentcyView : AHBaseView

@property(nonatomic,assign)int64_t winCoin;

@property(nonatomic,assign)int64_t banerCoin;

+ (id)currencyShareView;

- (void)initFrame:(CGRect)frame;

@end
