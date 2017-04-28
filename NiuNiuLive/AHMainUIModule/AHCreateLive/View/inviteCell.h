//
//  inviteCell.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface inviteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic,copy)void (^ selectedBlock)(BOOL isSelected,NSString * userid);
- (void)setCellMessageWithFriendModel:(FriendModel *)model;
@end
