//
//  AHBaseNavController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseNavController.h"

@interface AHBaseNavController ()

@end

@implementation AHBaseNavController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{

    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self.navigationBar setBarStyle:(UIBarStyleDefault)];
        self.navigationBar.translucent = NO;
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
        [self.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                     NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
    }
    return self;
}

- (void)setNavigationColor:(UIColor *)navigationBarColor title:(UIColor *)titleColor{

//    self.navigationBar.translucent = NO;
    [self.navigationBar setBarTintColor:navigationBarColor];
    [self.navigationBar setTintColor:titleColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,
                                                 NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count >= 1) {
        UIImage *arrow = [UIImage imageNamed:@"btn_home_arrow"];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:arrow forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"btn_home_arrow"] forState:UIControlStateHighlighted];
        leftBtn.frame = (CGRect ){.size= {arrow.size.width,arrow.size.height}};
//        [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -arrow.size.width+5, 0, 5)];
        [leftBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
        
        viewController.navigationItem.leftBarButtonItem = backItem;
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
   
}

- (void)popViewController:(UIButton *)button{

    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
