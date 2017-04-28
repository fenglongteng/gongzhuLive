//
//  AHChoiceOfPaymentView.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHChoiceOfPaymentView : UIView
@property (weak, nonatomic) IBOutlet UIView *weixinVIew;
@property (weak, nonatomic) IBOutlet UIView *zhifubaoView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,strong)UIView *contentView;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)showOnTheWindow;
@end
