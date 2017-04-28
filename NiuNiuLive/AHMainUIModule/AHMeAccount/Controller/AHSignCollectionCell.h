//
//  AHSignCollectionCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//


#import "AHBaseCollectionViewCell.h"
#import "Users.pbobjc.h"
@interface AHSignCollectionCell : AHBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//天数label
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
//金币
@property (weak, nonatomic) IBOutlet UILabel *goldCOINSLabel;
@property(nonatomic,strong) UsersGetSignedInInfoResponse_SignedInInfo *signInInfo;
@end
