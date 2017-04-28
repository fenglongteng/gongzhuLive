//
//  AHBaseTableViewCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewCell.h"

@implementation AHBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString*)getIdentifier{
    return NSStringFromClass([self class]);
}

-(void)setOldModel:(id)oldModel{
    self.oldModel = oldModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
