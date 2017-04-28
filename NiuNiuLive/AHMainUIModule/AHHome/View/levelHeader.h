//
//  levelHeader.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface levelHeader : UIView
//等级名
@property (weak, nonatomic) IBOutlet UILabel *levelTitle;
//等级图片
@property (weak, nonatomic) IBOutlet UIImageView *levelImage;
//等级经验值Label
@property (weak, nonatomic) IBOutlet UILabel *JingYanLbl;

- (void)initWithFrame:(CGRect)frame userModel:(AHPersonInfoModel *)userModel;

@end
