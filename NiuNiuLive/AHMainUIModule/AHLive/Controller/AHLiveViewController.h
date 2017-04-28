//
//  AHLiveViewController.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"

#import "GameTcpApi.h"

@interface AHLiveViewController : AHBaseViewController

@property(nonatomic,assign)BOOL isLive;

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *roomPassW;

- (instancetype)initWithRoom:(Room *)roomModel;


@end
