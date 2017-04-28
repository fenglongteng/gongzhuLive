//
//  AHReportListCell.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHReportListCell.h"

@interface AHReportListCell ()



@end

@implementation AHReportListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inviteBtn.layer.cornerRadius = 3.0;
    self.inviteBtn.layer.borderWidth = 1.0;
    self.inviteBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _headImageView.layer.cornerRadius = 22.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

//邀请
- (IBAction)inviteClick:(id)sender {
    WeakSelf;
    if (self.invitationBlock) {
        self.invitationBlock(weakSelf.people);
    }
}

-(void)setPeople:(PPPersonModel *)people{
    _people = people;
    self.headImageView.image = people.headerImage ? people.headerImage : [UIImage imageNamed:@"head.jpg"];
    self.nickNameLabel.text = people.name;
    self.detailLabel.text = people.mobileArray[0];
}

@end
