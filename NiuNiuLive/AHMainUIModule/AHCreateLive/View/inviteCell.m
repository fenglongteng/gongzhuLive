//
//  inviteCell.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "inviteCell.h"
#import "NSString+Tool.h"

@interface inviteCell(){
    FriendModel * _model;
}

@end

@implementation inviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)CurrentCellIsSelected:(id)sender {
    UIButton * button = (UIButton *)sender;
    button.selected = !button.selected;
    if (self.selectedBlock) {
        self.selectedBlock(button.selected,_model.userid);
    }
}

- (void)setCellMessageWithFriendModel:(FriendModel *)model{
    _model = model;
    [self.headImage sd_setImageWithURL:[NSString getImageUrlString:model.faceurl] placeholderImage:[UIImage imageNamed:@"logo_500.jpg"]];
    self.nameLbl.text = model.chineseName;
    if (!model.labelText || [model.labelText isEqualToString:@""]) {
        self.labelText.text = @"这家伙很懒，什么都没有留下···";
    }else{
        self.labelText.text = model.labelText;
    }
}
@end
