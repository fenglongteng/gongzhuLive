//
//  AHTaskListCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHUnfinishedTaskListCell.h"
#import "WMProgressView.h"
@implementation AHUnfinishedTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *backgourdView = [[UIView alloc]initWithFrame:CGRectMake(13,0,screenWidth - 13*2, 95)];
    backgourdView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backgourdView];
    [backgourdView addCornerRadius:3];
    [self.contentView sendSubviewToBack:backgourdView];
    [self.completeBt addCornerRadius:13];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setTaskItem:(TasksGetTaskListResponse_TaskItem *)taskItem{
    _taskTitleLabel.text = taskItem.title;
    _experienceLabel.text = [NSString stringWithFormat:@"%lld 经验值",taskItem.experiencePoint];
    _progressLabel.text = [NSString stringWithFormat:@"%lld/%lld",taskItem.currentNumber,taskItem.number];
    CGFloat progress = (float)taskItem.currentNumber/(float)taskItem.number;
    [_progressView setProgress:progress];
    [_progressView setHideShadowView:YES];
}

@end
