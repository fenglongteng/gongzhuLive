//
//  AHApplyForBanker.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHApplyForBanker : AHBaseView

+(id)shareApplyForBanker;

@property (nonatomic,copy) void (^closeBlock)();

@property (weak, nonatomic) IBOutlet UITableView *bankerTable;

//当前是否在庄家列表中
@property (nonatomic,assign)BOOL isBanker;
//是否已经是庄了
@property (nonatomic,assign)BOOL hasBankerd;

- (void)setBankerMessageWithRoomid:(NSString *)roomid currentBankerid:(NSString *)bankerid;
@end
