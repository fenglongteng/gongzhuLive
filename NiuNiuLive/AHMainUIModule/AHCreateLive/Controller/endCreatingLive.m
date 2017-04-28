//
//  endCreatingLive.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "endCreatingLive.h"
#import "AHPersonInfoVC.h"

@interface endCreatingLive ()

@end

@implementation endCreatingLive


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)fd_prefersNavigationBarHidden{

    return YES;
}

- (IBAction)popToRootViewController:(id)sender {
    
    [[AppDelegate getNavigationTopController].navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)pushToMecontroller:(id)sender {
    
    [[AppDelegate getNavigationTopController].navigationController pushViewController:[[AHPersonInfoVC alloc] initWithUserId:@"58e8afda397d853ab8961bf9"] animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
