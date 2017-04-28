//
//  AHGiftPageView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/31.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"
#import "Gifts.pbobjc.h"

@class AHGiftListView;

@interface AHGiftPageView : AHBaseView

@property (nonatomic,strong)NSArray< Gift*> *giftArray;

@property (nonatomic,copy) void (^giftClickBlock)(AHGiftListView *gift);

@end
