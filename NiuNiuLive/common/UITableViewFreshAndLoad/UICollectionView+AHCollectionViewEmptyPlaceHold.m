//
//  UICollectionView+AHCollectionViewEmptyPlaceHold.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "UICollectionView+AHCollectionViewEmptyPlaceHold.h"
#import <objc/runtime.h>
@implementation UICollectionView (AHCollectionViewEmptyPlaceHold)

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
    
    id<UICollectionViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    
    if ([src respondsToSelector: @selector(numberOfSectionsInCollectionView:)]) {
        sections = [src numberOfSectionsInCollectionView:self];
    }
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [src collectionView:self numberOfItemsInSection:sections];
        if (rows) {
            isEmpty = NO;
        }
    }
    if (isEmpty) {
        [self.placeHolderView removeFromSuperview];
        [self addSubview:self.placeHolderView];
    }
}
@end
