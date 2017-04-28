//
//  AHWeiboViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHWeiboViewController.h"
#import "AHBindingView.h"

@interface AHWeiboViewController ()<AHBingViewDelegate>

@property (nonatomic,strong)AHBindingView *bingView;

@end

@implementation AHWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"微博好友";
    self.bingView.frame = CGRectMake(0, 0, screenWidth, screenHeight-navHeight);
    [self.view addSubview:self.bingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -AHBingViewDelegate

-(void)bingAccount:(AHBindingView *)bingView{
//绑定
    
}

- (AHBindingView *)bingView{

    if (_bingView == nil) {
        _bingView = [[AHBindingView alloc]init];
        _bingView.bingType = AHBingWeibo;
        _bingView.delegate = self;
    }
    return _bingView;
}


@end
