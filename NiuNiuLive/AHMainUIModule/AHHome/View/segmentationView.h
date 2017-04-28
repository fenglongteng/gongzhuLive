//
//  segmentationView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface segmentationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *remindLbl;
@property (weak, nonatomic) IBOutlet UILabel *backPlayLbl;

- (void)initWithSegmentationFrame:(CGRect)frame;

@end
