//
//  AHUserWinnerCell.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserApis.pbobjc.h"

@interface AHUserWinnerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *winCoin;

@property (nonatomic,strong)UserBasicInfo * userInfo;
@end
