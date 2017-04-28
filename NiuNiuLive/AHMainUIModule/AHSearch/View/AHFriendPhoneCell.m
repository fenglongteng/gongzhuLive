//
//  AHFriendPhoneCell.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHFriendPhoneCell.h"

@interface AHFriendPhoneCell ()
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;

@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendPhoneNum;
@property (weak, nonatomic) IBOutlet UIButton *invitationBtn;

@end

@implementation AHFriendPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

//邀请
- (IBAction)invitationClick:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
