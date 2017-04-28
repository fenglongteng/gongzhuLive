//
//  AHTaskListCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//


#import "WMProgressView.h"
#import "AHBaseTableViewCell.h"
#import "Tasks.pbobjc.h"
@interface AHUnfinishedTaskListCell : AHBaseTableViewCell
//进度label
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
//经验
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
//任务标题
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
//进度view
@property (weak, nonatomic) IBOutlet WMProgressView *progressView;
//完成按钮
@property (weak, nonatomic) IBOutlet UIButton *completeBt;

@property(nonatomic,strong) TasksGetTaskListResponse_TaskItem*taskItem;
@end
