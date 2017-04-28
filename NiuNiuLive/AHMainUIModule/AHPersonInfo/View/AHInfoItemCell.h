//
//  AHInfoItemCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"

typedef  void (^ButtonAction)();

@interface AHInfoItemCell : AHBaseTableViewCell
//cell所在位置
@property(nonatomic,strong)NSIndexPath *indexPath;
//左边tile
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
//右边 detail
@property (weak, nonatomic) IBOutlet UILabel *leftDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDetailLabel;
//左边按钮响应事件
@property(nonatomic,copy)ButtonAction leftButtonAction;
//右边按钮响应事件
@property(nonatomic,copy)ButtonAction rightButtonAction;
@end
