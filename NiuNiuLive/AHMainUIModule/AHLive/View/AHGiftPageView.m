//
//  AHGiftPageView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/31.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHGiftPageView.h"
#import "AHGiftListView.h"

@interface AHGiftPageView ()

@property (nonatomic,strong)UIImageView *backImageView;

@property (nonatomic,strong)AHGiftListView *selectGiftView;

@end

@implementation AHGiftPageView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.backImageView];
    }
    
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.backImageView.frame = self.bounds;
}

- (void)setGiftArray:(NSArray<Gift *> *)giftArray{
    int rowNumber = 5;//每行5个
    CGFloat width = self.width/5;
    CGFloat heigth = self.height *0.5;
    NSInteger total = giftArray.count;
    for (int i= 0; i<total; i++) {
        NSInteger count = i/rowNumber;
        NSInteger row = i%rowNumber;
        AHGiftListView *listView = [[AHGiftListView alloc]initWithFrame:CGRectMake(row*width, count*heigth, width, heigth)];
        listView.gift = giftArray[i];
        __weak typeof(self)weakSelf = self;
        [listView setGiftSelectBlock:^(AHGiftListView *selectView) {
            selectView.isSelect = YES;
            if (weakSelf.selectGiftView == selectView) {
                return;
            }
            weakSelf.selectGiftView.isSelect = NO;
            weakSelf.selectGiftView = selectView;
            if (weakSelf.giftClickBlock) {
                weakSelf.giftClickBlock(selectView);
            }
//            if ([weakSelf.selectGiftView.dic[@"isLianfa"] integerValue] == 2) {
////                self.runningFireBtn.hidden = YES;
//            }
        }];
        [self addSubview:listView];
    }
}

- (UIImageView *)backImageView{

    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.clipsToBounds = YES;
        _backImageView.contentMode = UIViewContentModeScaleToFill;
        _backImageView.image = [UIImage imageNamed:@"bg_giftbg"];
    }

    return _backImageView;
}

@end
