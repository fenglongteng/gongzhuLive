//
//  AHAnchorUserPopView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHAnchorUserPopView : AHBaseView

@property (nonatomic,copy) NSString *userId;//用户ID

+ (id)shareLiveUserPopView;

- (void)showAnchorUserPopViewUserid:(NSString *)userid;//显示

-(void)dismissAnchorView;//隐藏

@end
