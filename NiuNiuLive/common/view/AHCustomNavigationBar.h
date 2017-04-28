//
//  AHCustomNavigationBar.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHCustomNavigationBar : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
//自定义初始化方法
-(instancetype)initWithFrame:(CGRect)frame OnViewController:(UIViewController*)viewController;
@end
