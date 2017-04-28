//
//  ListCell.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *listLabel;
/*
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/*
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
/*
 *  标签
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
/*
 *  关注数
 */
@property (weak, nonatomic) IBOutlet UILabel *meiliCount;
@end
