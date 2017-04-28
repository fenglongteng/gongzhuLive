//
//  AHSearchBtnView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

@interface AHSearchBtnView : AHBaseView

@property (nonatomic,strong)UIButton *searchBtn;
@property (nonatomic,strong)UILabel  *searchLabel;

-(id)initWithSearchImage:(NSString *)imageString searchTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
