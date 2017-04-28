//
//  gameFinishView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/13.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gameFinishView : UIView
//是否显示等待时间
@property(nonatomic,assign)BOOL isWaitTime;

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
+ (gameFinishView *)initGameFinishView;
//游戏进入时或者结束时调用
- (void)gameWaitingOrGameCreating;

- (void)WaitForTheCountdownWithTime:(int32_t)time;


@property(nonatomic,copy)void (^finishBlock)(gameFinishView * finish);
@end
