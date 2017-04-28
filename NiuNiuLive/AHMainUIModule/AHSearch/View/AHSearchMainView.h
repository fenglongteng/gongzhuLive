//
//  AHSearchMainView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AHSearchBtnView;

@protocol AHSearchMainViewDelegate <NSObject>

@optional
- (void)searchView:(AHSearchBtnView *)searchButtom didSelect:(NSInteger)tag;
@end

@interface AHSearchMainView : UIView

@property (nonatomic,weak)id<AHSearchMainViewDelegate>delegate;

@end
