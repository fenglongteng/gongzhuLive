//
//  gameListCell.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserApis.pbobjc.h"

@interface gameListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *readLbl;

@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (weak, nonatomic) IBOutlet UILabel *gameDetail;

@property (strong,nonatomic) GameItem * gameInfo;
@end
