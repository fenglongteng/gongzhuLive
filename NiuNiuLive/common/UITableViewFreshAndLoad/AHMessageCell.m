//
//  AHMessageCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/29.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMessageCell.h"

@implementation AHMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessageModel:(AHMessageModel *)messageModel{
    self.nickNameLabel.text = messageModel.nickName;
    self.messageLabel.text = messageModel.message;
    self.timeLabel.text = messageModel.acceptTime;
}

@end
