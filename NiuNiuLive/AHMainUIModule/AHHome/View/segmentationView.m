//
//  segmentationView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "segmentationView.h"

@implementation segmentationView

- (void)initWithSegmentationFrame:(CGRect)frame{
    self.frame = frame;
    self.remindLbl.font = [UIFont systemFontOfSize:11.0 * screenWidth / 320 weight:0.5];
    self.backPlayLbl.font = [UIFont systemFontOfSize:16.0 * screenWidth / 320 weight:0.5];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
