//
//  UITableView+AHTableViewEmptyPlaceHold.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "UITableView+AHTableViewEmptyPlaceHold.h"
#import <objc/runtime.h>
@implementation UITableView (AHTableViewEmptyPlaceHold)
- (AHEmptyPlaceHoldView *)placeHolderView {
    return objc_getAssociatedObject(self, @selector(placeHolderView));
}

- (void)setPlaceHolderView:(UIView *)placeHolderView {
    objc_setAssociatedObject(self, @selector(placeHolderView), placeHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)ah_reloadData{
    [self reloadData];
    [self ah_checkEmpty];
}

- (void)ah_checkEmpty{
    BOOL isEmpty = YES;
    
    id<UITableViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    
    if ([src respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
        sections = [src numberOfSectionsInTableView:self];
        if (sections>1) {
            isEmpty = NO;
        }
    }
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [src tableView:self numberOfRowsInSection:i];
        if (rows) {
            isEmpty = NO;
        }
    }
    if (isEmpty) {
        [self.placeHolderView removeFromSuperview];
        [self addSubview:self.placeHolderView];
        self.placeHolderView.frame = self.frame;
    }else{
        [self.placeHolderView removeFromSuperview];
    }
}
@end
