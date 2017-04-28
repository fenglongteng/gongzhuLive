//
//  AHSignCollectionCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHSignCollectionCell.h"
#import "UIImage+extension.h"
@implementation AHSignCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSignInInfo:(UsersGetSignedInInfoResponse_SignedInInfo *)signInInfo{
    _signInInfo = signInInfo;
    _daysLabel.text = [NSString stringWithFormat:@"%d 天",signInInfo.day];
    _goldCOINSLabel.text =[NSString stringWithFormat:@"%lld",signInInfo.goldCoins];
}
@end
