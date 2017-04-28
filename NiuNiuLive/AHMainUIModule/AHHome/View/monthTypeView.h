//
//  monthTypeView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftController.h"

@protocol monthTypeViewDelegate <NSObject>

@required

- (void)changeMonthType:(NSInteger)index;

@end

@interface monthTypeView : UIView

@property(nonatomic,strong)NSArray * titleArray;

@property(nonatomic,strong)NSMutableArray * btnArray;

- (void)initWithFrame:(CGRect)frame listType:(ListType)listType;

@property(nonatomic,weak)id<monthTypeViewDelegate> delegate;

- (void)changeSelectedView:(NSInteger)index;

@end
