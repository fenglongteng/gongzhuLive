//
//  giftListView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "giftListView.h"
#import "AHPersonInfoVC.h"

@implementation giftListView

- (void)initWithFrame:(CGRect)frame bangType:(BangType)bangType listType:(ListType)listType{
    self.frame = frame;
    //添加点击手势
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPersonalController:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPersonalController:)];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPersonalController:)];
    [self.top3View addGestureRecognizer:tap3];
    [self.top2View addGestureRecognizer:tap2];
    [self.top1View addGestureRecognizer:tap1];
}

- (void)setTopChartArr:(NSArray *)topChartArr{

    _topChartArr = topChartArr;
    
    

}

- (void)pushToPersonalController:(UITapGestureRecognizer *)tap{
    //NSInteger viewTag = [tap view].tag;
    [[AppDelegate getNavigationTopController].navigationController pushViewController:[[AHPersonInfoVC alloc] init] animated:YES];
}

@end
