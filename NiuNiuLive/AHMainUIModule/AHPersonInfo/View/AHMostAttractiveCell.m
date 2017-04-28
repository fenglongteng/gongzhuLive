//
//  AHMostAttractiveCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMostAttractiveCell.h"
#import "UIImage+extension.h"
const NSInteger imageViewTagBegin = 100;
@implementation AHMostAttractiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self creatImages];
    // Initialization code
}

//创建魅力贡献前三名的头像
-(void)creatImages{
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 80 - i*30, 20, 45, 45)];
        imageView.center =  CGPointMake(screenWidth - 80 - i*30, 30);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image =[UIImage circleImageWithName:@"head.jpg" borderWidth:1 borderColor:[UIColor whiteColor]];
        imageView.image = image;
        UIView *view = [self.contentView viewWithTag:imageViewTagBegin+i];
        [view removeFromSuperview];
        imageView.tag = imageViewTagBegin + i;
        [self.contentView addSubview:imageView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
