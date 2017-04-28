//
//  AHMessageModel.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMessageModel.h"

@implementation AHMessageModel

-(void)setNickName:(NSString *)nickName{
    _nickName = nickName;
    NSDate *date = [NSDate new];
    _acceptTime = [NSString stringWithFormat:@"%ld:%ld",(long)date.hour,(long)date.minute];
}


@end
