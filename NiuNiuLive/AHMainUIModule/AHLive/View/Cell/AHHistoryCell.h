//
//  AHHistoryCell.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtoEcho.pbobjc.h"

@class AHHistoryCell;

@interface AHHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic,strong)NSIndexPath *cellPath;
//详细信息View
@property (weak, nonatomic) IBOutlet UIView *detailView;
//天下注
@property (weak, nonatomic) IBOutlet UILabel *skyCoin;
//天倍率
@property (weak, nonatomic) IBOutlet UILabel *skyCount;
//天输赢
@property (weak, nonatomic) IBOutlet UILabel *skyWin;
//地下注
@property (weak, nonatomic) IBOutlet UILabel *earthCoin;
//地倍率
@property (weak, nonatomic) IBOutlet UILabel *earthCount;
//地输赢
@property (weak, nonatomic) IBOutlet UILabel *earthWin;
//人下注
@property (weak, nonatomic) IBOutlet UILabel *personCoin;
//人倍率
@property (weak, nonatomic) IBOutlet UILabel *personCount;
//人输赢
@property (weak, nonatomic) IBOutlet UILabel *personWin;
//总输赢
@property (weak, nonatomic) IBOutlet UILabel *AllWin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DetailViewHeight;
//展开收缩block
@property(copy, nonatomic)void(^ extendsBlokc)(AHHistoryCell * cell);

- (void)setDetailMessageWithModel:(DouNiuHistoryItem *)model;
@end
