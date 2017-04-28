//
//  AHSuccessOrFailView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
// 胜负走势图

#import "AHBaseView.h"

@interface AHSuccessOrFailView : AHBaseView

@property (nonatomic,copy) void (^closeRecodView)();

+ (id)successOrFailShareView;
@property (weak, nonatomic) IBOutlet UITableView *hisTable;
@property(nonatomic,copy)NSString * roomid;
@end
