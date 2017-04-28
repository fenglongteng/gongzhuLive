//
//  AHBankerViewCell.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtoEcho.pbobjc.h"

@interface AHBankerViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *bankerNumLb;
- (void)setMessageModel:(DouNiuBanker *)model;

@end
