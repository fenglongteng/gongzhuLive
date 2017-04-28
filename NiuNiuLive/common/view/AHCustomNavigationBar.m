//
//  AHCustomNavigationBar.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHCustomNavigationBar.h"

@interface AHCustomNavigationBar()
@property(nonatomic,weak)UIViewController *viewControer;
@end
@implementation AHCustomNavigationBar

-(instancetype)initWithFrame:(CGRect)frame OnViewController:(UIViewController*)viewController{
    if ([super initWithFrame:frame]) {
        UIView *headerView =[[NSBundle mainBundle]loadNibNamed:@"AHCustomNavigationBar" owner:self options:0].firstObject;
        [self addSubview:headerView];
        self.backgroundColor = [UIColor clearColor];
        headerView.frame = frame;
        self.viewControer = viewController;
    }
    return self;
}

- (IBAction)backButton:(id)sender {
    if(self.viewControer){
        [self.viewControer.navigationController popViewControllerAnimated:YES];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
