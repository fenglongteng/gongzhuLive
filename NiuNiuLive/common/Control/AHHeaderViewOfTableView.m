//
//  AHHeaderViewOfTableView.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHHeaderViewOfTableView.h"
#import "UIView+ST.h"
#import "AHPersonInfoManager.h"
@interface AHHeaderViewOfTableView()
//顶部视图宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewWidthConstraint;
//底部视图宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonViewWidthConstraint;

@end

@implementation AHHeaderViewOfTableView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        UIView *headerView =[[NSBundle mainBundle]loadNibNamed:@"AHHeaderViewOfTableView" owner:self options:0].firstObject;
        [self addSubview:headerView];
        headerView.frame = frame;
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.topViewWidthConstraint.constant = screenWidth;
    self.bottonViewWidthConstraint.constant = screenWidth;
}

-(void)setInfoModel:(AHPersonInfoModel *)infoModel{
    _infoModel = infoModel;
    [self setUpViewWithInfoModel:infoModel];
}

-(void)setUpViewWithInfoModel:(AHPersonInfoModel*)infoModel{
    self.titleLabel.text = infoModel.nickName;
    self.briefLabel.text = infoModel.brief.length>0?infoModel.brief:@"这家伙很懒，什么也没有填。";
    NSString *imageUrlString = [NSString stringWithFormat:@"%@%@",[AHPersonInfoManager manager].getInfoModel.webApiUserGetAvatarURL,infoModel.avatarURL];
    self.userIdLabel.text =[NSString stringWithFormat:@"%d  UID:%@",infoModel.level.level,infoModel.showId?:_showId] ;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString: imageUrlString] placeholderImage:DefaultHeadImage];
    NSArray*adressArray = [infoModel.cityName componentsSeparatedByString:@"省"];
    if (!(infoModel.constellation.length>0)) {
        infoModel.constellation = @"";
    }
    if (adressArray.count == 2) {
        NSString *province = adressArray[0];
        NSString *city = adressArray[1];
        if (!(province.length>0)) {
            province = @"";
        }
        if (!(city.length>0)) {
            city = @"";
        }
        self.detaiInfoLabel.text = [NSString stringWithFormat:@"%@  %@  %@省  %@",infoModel.genderString,infoModel.constellation,province,city];
    }else{
        if (!(infoModel.cityName.length>0)) {
            infoModel.cityName = @"";
        }
        self.detaiInfoLabel.text = [NSString stringWithFormat:@"%@  %@  %@",infoModel.genderString,infoModel.constellation,infoModel.cityName];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
