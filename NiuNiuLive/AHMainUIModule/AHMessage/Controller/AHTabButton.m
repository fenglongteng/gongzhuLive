//
//  AHTabButton.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHTabButton.h"

@implementation AHTabButton

- (id)initDefaultImage:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title{
    self = [super init];
    if (self) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:selectImage forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [self setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateSelected];
        
           }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;//使文字和图片居中
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+10, -self.imageView.frame.size.width, 0.0, 0.0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-0.0, 0.0,0.0, -self.titleLabel.bounds.size.width)];
}

@end
