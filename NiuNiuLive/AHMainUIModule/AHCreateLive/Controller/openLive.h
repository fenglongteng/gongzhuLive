//
//  openLive.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"

@interface openLive : AHBaseViewController
//公开房间
@property(nonatomic,assign)BOOL isCommon;

-(instancetype)initWithInvitationMessage:(NSString*)messageString;
@end
