//
//  AHSearchBtnView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHSearchBtnView.h"


@implementation AHSearchBtnView

-(id)initWithSearchImage:(NSString *)imageString searchTitle:(NSString *)title target:(id)target action:(SEL)action{
    self =  [super init];
    if (self) {
        [self.searchBtn setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        self.searchLabel.text = title;
        [self.searchBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.searchBtn];
        [self addSubview:self.searchLabel];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.searchBtn.frame = CGRectMake(0, 0, self.width, self.height-35);
    self.searchLabel.frame = CGRectMake(0, self.searchBtn.bottom+21, self.width, 15);
}

- (UIButton *)searchBtn{
    if (_searchBtn == nil) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _searchBtn;
}

- (UILabel *)searchLabel{

    if (_searchLabel == nil) {
        _searchLabel = [[UILabel alloc]init];
        _searchLabel.font = [UIFont systemFontOfSize:12.0];
        _searchLabel.textAlignment = NSTextAlignmentCenter;
        _searchLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _searchLabel;
}

@end
