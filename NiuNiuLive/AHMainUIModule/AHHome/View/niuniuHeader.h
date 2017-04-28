//
//  niuniuHeader.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface niuniuHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *niuniuHeader;
@property (weak, nonatomic) IBOutlet UILabel *introduceLbl;
@property (weak, nonatomic) IBOutlet UILabel *compareLbl;

- (void)initFrame:(CGRect)frame;

@end
