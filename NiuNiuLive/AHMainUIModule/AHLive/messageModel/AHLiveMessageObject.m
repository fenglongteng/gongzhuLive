//
//  AHLiveMessageObject.m
//  NiuNiuLive
//
//  Created by anhui on 17/4/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLiveMessageObject.h"

@implementation AHLiveMessageObject

- (void)setMessage:(PushMessage *)message{
    
    _message = message;
    NSString *str = [NSString stringWithFormat:@"%@ %@",message.nickName,message.message];
    CGFloat width = screenWidth - 130;
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size;
    self.cellHeigth = size.height+5;
}

@end
