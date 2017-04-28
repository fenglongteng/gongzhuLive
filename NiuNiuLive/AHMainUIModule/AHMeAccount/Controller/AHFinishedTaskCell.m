//
//  AHUnfinishedTaskCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHFinishedTaskCell.h"

@implementation AHFinishedTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTaskItem:(TasksGetTaskListResponse_TaskItem *)taskItem{
    _taskTitleLabel.text = taskItem.title;
    _experienceLabel.text = [NSString stringWithFormat:@"%lld 经验值",taskItem.experiencePoint];
}

@end
