//
//  certificationController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "certificationController.h"
#import "openLive.h"

@interface certificationController ()

@end

@implementation certificationController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addPopButton];
    self.navigationItem.title = @"实名认证";
    [self setRightButtonBarItemTitle:@"跳过" target:self action:@selector(jumpToLast)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jumpToLast{
    openLive * openBC = [[openLive alloc] initWithInvitationMessage:self.showLabel];
    openBC.isCommon = YES;
    [self.navigationController pushViewController:openBC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
