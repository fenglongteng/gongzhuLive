//
//  AHSearchMainView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHSearchMainView.h"
#import "AHSearchBtnView.h"

CGFloat searchButtonWidth = 68;
CGFloat searchButtomSpace = 30;

@interface AHSearchMainView ()

@property (nonatomic,strong)AHSearchBtnView *addressList;//通讯录
@property (nonatomic,strong)AHSearchBtnView *weiboFriend;//微博好友
@property (nonatomic,strong)AHSearchBtnView *nearby;//附件

@end

@implementation AHSearchMainView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self createSearchButtonView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.weiboFriend.frame = CGRectMake(0, 0, searchButtonWidth, self.height);
    self.weiboFriend.centerX = self.width/2;
    self.addressList.frame = CGRectMake(0, 0, searchButtonWidth, self.height);
    self.addressList.x = CGRectGetMinX(self.weiboFriend.frame)-searchButtomSpace - searchButtonWidth;
    self.nearby.frame = CGRectMake(0, 0, searchButtonWidth, self.height);
    self.nearby.x = CGRectGetMaxX(self.weiboFriend.frame) + searchButtomSpace;
}

- (void)createSearchButtonView{
    
    [self addSubview:self.addressList];
    [self addSubview:self.weiboFriend];
    [self addSubview:self.nearby];
}

- (void)searchClickAction:(UIButton *)sender{

    AHSearchBtnView *searchBtnView = (AHSearchBtnView *)sender.superview;
    if ([self.delegate respondsToSelector:@selector(searchView:didSelect:)]) {
        [self.delegate searchView:searchBtnView didSelect:searchBtnView.tag];
    }
}

- (AHSearchBtnView *)addressList{

    if (_addressList == nil) {
        _addressList = [[AHSearchBtnView alloc]initWithSearchImage:@"btn_search_phone" searchTitle:@"通讯录好友" target:self action:@selector(searchClickAction:)];
        _addressList.tag = 1;
    }
    return _addressList;
}

- (AHSearchBtnView *)weiboFriend{

    if (_weiboFriend == nil) {
        _weiboFriend = [[AHSearchBtnView alloc]initWithSearchImage:@"btn_search_weibo" searchTitle:@"微博好友" target:self action:@selector(searchClickAction:)];
        _weiboFriend.tag = 2;
    }
    return _weiboFriend;
}

- (AHSearchBtnView *)nearby{

    if (_nearby == nil) {
        _nearby = [[AHSearchBtnView alloc]initWithSearchImage:@"btn_search_location" searchTitle:@"附近的人" target:self action:@selector(searchClickAction:)];
        _nearby.tag = 3;
    }
    return _nearby;
}

@end
