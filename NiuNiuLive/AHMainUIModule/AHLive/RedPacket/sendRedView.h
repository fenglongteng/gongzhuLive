//
//  sendRedView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sendRedView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *livePersonCount;
@property (weak, nonatomic) IBOutlet UILabel *userGameB;

- (void)showSendRedView;

- (void)setRedViewMessage;

@end
