//
//  monthController.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"
#import "GiftController.h"
#import "AHListBaseViewController.h"

@interface monthController : AHListBaseViewController

- (instancetype)initWithFrame:(CGRect)frame bangType:(BangType)bangType listType:(ListType)listType;

-(void)subViewReload;

@end
