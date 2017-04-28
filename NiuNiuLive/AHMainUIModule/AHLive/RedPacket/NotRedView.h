//
//  NotRedView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotRedView : UIView

@property (weak, nonatomic) IBOutlet UILabel *getRedPacketLbl;
@property (weak, nonatomic) IBOutlet UILabel *redPacketTitle;
//红包详情View
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *remindLbl;
@property (nonatomic,copy) NSString *reduuid;
//抢到的红包金币数
@property (assign, nonatomic)int64_t  redCoins;

//红包被抢光
@property(nonatomic,assign )BOOL isNull;

- (void)setRedViewMessage;

@end
