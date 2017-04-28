//
//  baseRedPacket.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "baseRedPacket.h"
#import "sendRedView.h"
#import "getRedView.h"
#import "NotRedView.h"

static baseRedPacket * redView;

@implementation baseRedPacket

+ (sendRedView *)initWithSendRed{
    
    sendRedView * view = [[NSBundle mainBundle] loadNibNamed:@"sendRedView" owner:nil options:nil].firstObject;
    [view setRedViewMessage];

    return view;
}

+ (getRedView *) initWithGetRed:(PushGift *)redMessage{
    
    getRedView * view = [[NSBundle mainBundle] loadNibNamed:@"getRedView" owner:nil options:nil].firstObject;
    view.redMessage = redMessage;
    [view setRedViewMessage];
    
    view.detailBlock = ^(BOOL isNull,int64_t getCoins,NSString *reduuid){
        NotRedView * detailView = [[NSBundle mainBundle] loadNibNamed:@"NotRedView" owner:nil options:nil].firstObject;
        detailView.isNull = isNull;
        detailView.redCoins = getCoins;
        detailView.reduuid = reduuid;
        [detailView setRedViewMessage];
    };
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
