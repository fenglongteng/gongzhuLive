//
//  AHBaseCollectionViewCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseCollectionViewCell.h"

@implementation AHBaseCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString*)getIdentifier{
    return NSStringFromClass([self class]);
}

-(void)setModel:(AHBaseModel *)model{
    
    
}



@end
