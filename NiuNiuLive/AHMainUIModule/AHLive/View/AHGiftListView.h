//
//  AHGiftListView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/25.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"
#import "Gifts.pbobjc.h"

@interface AHGiftListView : AHBaseView

@property (nonatomic,strong)Gift *gift;

@property (nonatomic,assign)BOOL isSelect;//是否选中
@property (nonatomic,strong)UIImageView *selctImageV;//选中后的图片

@property (nonatomic,copy) void(^giftSelectBlock)(AHGiftListView *selectView);

@end
