//
//  AHWinnerView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHWinnerView : AHBaseView
@property (weak, nonatomic) IBOutlet UIView *winnerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
//当局游戏的游戏id
@property (nonatomic,copy)NSString * gameid;
@property (nonatomic,copy)NSString * roomid;
+(id)shareWinerView;

- (void)showWinnerViewFrom:(UIView *)fromView;

- (void)removeWinnerView;

@end
