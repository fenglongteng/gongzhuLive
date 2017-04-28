//
//  focusCell.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface focusCell : UITableViewCell
/*
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/*
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
/*
 *  主播大图
 */
@property (weak, nonatomic) IBOutlet UIImageView *BigImage;
@end
