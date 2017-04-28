//
//  AHUserWinnerCell.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHUserWinnerCell.h"
#import "UserApis.pbobjc.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"

@interface AHUserWinnerCell()



@end

@implementation AHUserWinnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUserInfo:(UserBasicInfo *)userInfo{
    if (userInfo.nickName.length > 0) {
        self.nickName.text = userInfo.nickName;
    }
}

//拿到个人金币数 装换成字符串
- (NSString *)getCurrentGold:(int64_t)goldCoin{
    if (goldCoin >= 100000000) {
        return [NSString stringWithFormat:@"%.2f亿",goldCoin / 100000000.0];
    }else if(goldCoin >= 10000 && goldCoin < 100000000){
        return [NSString stringWithFormat:@"%.2fW",goldCoin / 10000.0];
    }else{
        return [NSString stringWithFormat:@"%lld",goldCoin];
    }
}


@end
