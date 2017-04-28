//
//  AHuserImageView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/28.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHuserImageView.h"

@interface AHuserImageView ()

@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UIImageView *gradeImageView;//等级
@end

@implementation AHuserImageView

-(id)initWithFrame:(CGRect)frame{

   self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addTarget:self action:@selector(userImageViewTap:)];
        
        [self addSubview:self.headerImageView];
        [self addSubview:self.gradeImageView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.headerImageView.frame =self.bounds;
    self.headerImageView.layer.cornerRadius = self.height *0.5;
    [self.gradeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.trailing.equalTo(self).offset(-2);
        make.bottom.equalTo(self).offset(-2);
    }];
}

- (UIImageView *)gradeImageView{

    if (_gradeImageView == nil) {
        _gradeImageView = [[UIImageView alloc]init];
        _gradeImageView.image = [UIImage imageNamed:@"icon_user_dlevel1"];
    }
    return _gradeImageView;
}

- (UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

- (void)setRoomAudieModel:(Room_Audience *)roomAudieModel{

    _roomAudieModel = roomAudieModel;
    
    [self.headerImageView sd_setImageWithURL:[NSString getImageUrlString:roomAudieModel.avatar] placeholderImage:[UIImage imageNamed:@"logo_500.jpg"]];
    
    self.gradeImageView.image = [UIImage imageNamed:[self messageFromUserHeadergrade:roomAudieModel.level]];

}

//根据消息 人等级显示头像
- (NSString *)messageFromUserHeadergrade:(NSInteger)gradeType{
    
    NSArray *userGradeImage = @[@"icon_user_dlevel1",@"icon_user_dlevel2",@"icon_user_dlevel3",
                                @"icon_user_dlevel4",
                                @"icon_user_dlevel5",@"icon_user_dlevel6",@"icon_user_dlevel7",
                                @"icon_user_dlevel8",@"icon_user_dlevel9",@"icon_user_dlevel10",
                                @"icon_user_dlevel11",@"icon_user_dlevel12",@"icon_user_dlevel13",
                                @"icon_user_dlevel14",@"icon_user_dlevel15"];
    
    return  [userGradeImage objectAtIndex:gradeType];
}


- (void)userImageViewTap:(UITapGestureRecognizer *)notif{

    NSString* userid = self.roomAudieModel.userId;
    if (userid) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"userId" : userid}];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBankerClickUser object:nil userInfo:@{@"userId" : userid}];
    }

}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

@end
