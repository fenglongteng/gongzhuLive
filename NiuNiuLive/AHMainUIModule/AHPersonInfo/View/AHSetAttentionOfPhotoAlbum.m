//
//  AHSetAttentionOfPhotoAlbum.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHSetAttentionOfPhotoAlbum.h"
#import "NSString+Tool.h"
@implementation AHSetAttentionOfPhotoAlbum
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        UIView *view = [[NSBundle mainBundle]loadNibNamed:@"AHSetAttentionOfPhotoAlbum" owner:self options:0].firstObject;
        view.frame = frame;
        [self addSubview:view];
        self.frame = frame;
        [self.headImageView addCornerRadius:22.5];
    }
    return self;
}

-(void)setInfoModel:(AHPersonInfoModel *)infoModel{
    [_headImageView sd_setImageWithURL:[NSString getImageUrlString:infoModel.avatarURL] placeholderImage:DefaultHeadImage];
    _profileLabel.text = infoModel.brief;
    _nickNameLabel.text = infoModel.nickName;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
