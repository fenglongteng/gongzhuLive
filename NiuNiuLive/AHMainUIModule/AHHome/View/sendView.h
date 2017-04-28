//
//  sendView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftController.h"

@interface sendView : UIView
@property (weak, nonatomic) IBOutlet UIView *top1view;
@property (weak, nonatomic) IBOutlet UILabel *top1name;
@property (weak, nonatomic) IBOutlet UILabel *top1gameB;

@property (weak, nonatomic) IBOutlet UIView *top2view;
@property (weak, nonatomic) IBOutlet UILabel *top2name;
@property (weak, nonatomic) IBOutlet UILabel *to2gameB;

@property (weak, nonatomic) IBOutlet UIView *top3view;
@property (weak, nonatomic) IBOutlet UILabel *top3name;
@property (weak, nonatomic) IBOutlet UILabel *top3gameB;

@property (nonatomic,strong)NSArray *outChatTopArr;

- (void)initWithFrame:(CGRect)frame bangType:(BangType)bangType listType:(ListType)listType;

@end
