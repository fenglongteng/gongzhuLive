//
//  AHHistoryGainsView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHHistoryGainsView : AHBaseView

+ (id)shareHistoryGainsView;

@property (nonatomic,copy) void (^closeHistoryGainsBlock)();
@property (weak, nonatomic) IBOutlet UITableView *recordTable;
@property(nonatomic,copy)NSString * roomid;
@end
