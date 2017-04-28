//
//  gameHeader.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "gameHeader.h"
#import "NSObject+AHUntil.h"

@interface gameHeader()
@property (weak, nonatomic) IBOutlet UIButton *qianDaoBtn;

@end

@implementation gameHeader

- (void)initFrame:(CGRect)frame{
    self.frame = frame;
    [self setButtonStyle];
   
}

- (void)setButtonStyle{
    self.qianDaoBtn.layer.cornerRadius = self.qianDaoBtn.frame.size.height / 2.0;
    self.qianDaoBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.qianDaoBtn.layer.borderWidth = 0.5f;
}


- (IBAction)qianDaoBtn_pressed:(id)sender {
    [NSObject pushFromVC:[AppDelegate getNavigationTopController] toVCWithName:@"AHSignInVC" InTheStoryboardWithName:@"AHStoryboard"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
