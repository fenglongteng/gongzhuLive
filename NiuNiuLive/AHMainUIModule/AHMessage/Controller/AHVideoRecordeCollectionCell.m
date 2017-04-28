//
//  AHVideoRecordeCollectionCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHVideoRecordeCollectionCell.h"
#import "AHDeleteCellAnimation.h"
@implementation AHVideoRecordeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteSeletedCell:(id)sender {
      [AHDeleteCellAnimation toMiniAnimation:self];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (self.deleteSeletedCell) {
        self.deleteSeletedCell(self.index);
    }
}
@end
