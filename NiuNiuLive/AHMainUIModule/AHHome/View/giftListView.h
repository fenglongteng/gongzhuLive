//
//  giftListView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftController.h"

@interface giftListView : UIView
@property (weak, nonatomic) IBOutlet UIView *top1View;
@property (weak, nonatomic) IBOutlet UIImageView *top1HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *top1Up;
@property (weak, nonatomic) IBOutlet UILabel *top1Name;
@property (weak, nonatomic) IBOutlet UILabel *top1Meili;

@property (weak, nonatomic) IBOutlet UIView *top2View;
@property (weak, nonatomic) IBOutlet UIImageView *top2headImage;
@property (weak, nonatomic) IBOutlet UILabel *top2Up;
@property (weak, nonatomic) IBOutlet UILabel *top2Name;
@property (weak, nonatomic) IBOutlet UILabel *top2Meili;

@property (weak, nonatomic) IBOutlet UIView *top3View;
@property (weak, nonatomic) IBOutlet UIImageView *top3headImage;
@property (weak, nonatomic) IBOutlet UILabel *top3Name;
@property (weak, nonatomic) IBOutlet UILabel *top3Meili;

@property (nonatomic,strong)NSArray *topChartArr;//排名前三的数组

- (void)initWithFrame:(CGRect)frame bangType:(BangType)bangType listType:(ListType)listType;

@end
