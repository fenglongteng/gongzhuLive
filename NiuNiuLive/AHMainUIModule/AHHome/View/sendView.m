//
//  sendView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "sendView.h"
#import "AHPersonInfoVC.h"

@implementation sendView


- (void)initWithFrame:(CGRect)frame bangType:(BangType)bangType listType:(ListType)listType{
    //添加点击手势
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPersonalController:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPersonalController:)];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPersonalController:)];
    [self.top3view addGestureRecognizer:tap3];
    [self.top2view addGestureRecognizer:tap2];
    [self.top1view addGestureRecognizer:tap1];
}

- (void)pushToPersonalController:(UITapGestureRecognizer *)tap{
    //NSInteger viewTag = [tap view].tag;
    [[AppDelegate getNavigationTopController].navigationController pushViewController:[[AHPersonInfoVC alloc] initWithUserId:@"58e8afda397d853ab8961bf9"] animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
