//
//  getRedView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gifts.pbobjc.h"

@interface getRedView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *redPacketTitle;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

//红包信息
@property (strong,nonatomic)PushGift * redMessage;

@property (nonatomic,assign)BOOL isRedPacket;

@property (copy,nonatomic)void (^ detailBlock)(BOOL isNull,int64_t goldCoin,NSString *redUuid);

- (void)setRedViewMessage;

@end
