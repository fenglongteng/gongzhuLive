//
//  AHPhotoAlbumCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPhotoAlbumCell.h"
#import "AHDeleteCellAnimation.h"
@implementation AHPhotoAlbumCell

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
