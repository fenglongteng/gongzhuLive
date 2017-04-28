//
//  AHUnfinishedTaskCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"
#import "Tasks.pbobjc.h"
@interface AHFinishedTaskCell : AHBaseTableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
//经验值
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property(nonatomic,strong) TasksGetTaskListResponse_TaskItem*taskItem;
@end
