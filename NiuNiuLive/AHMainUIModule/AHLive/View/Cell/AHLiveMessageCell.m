//
//  AHLiveMessageCell.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLiveMessageCell.h"
#import "Rooms.pbobjc.h"
#import "UILabel+YBAttributeTextTapAction.h"

@interface AHLiveMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageV;
@property (weak, nonatomic) IBOutlet UILabel  *userMessageLb;

@end

@implementation AHLiveMessageCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

//设置消息
- (void)setMessage:(AHLiveMessageObject *)message{
    
    _message = message;
    self.userImageV.image = [UIImage imageNamed:[self messageFromUserHeadergrade:message.message.level]];
    NSString *messageStr = [self pushMessage:message.message];
    NSString *name = message.message.nickName;
    NSString *allStr = [NSString stringWithFormat:@"%@:%@",name,messageStr];
    //根据不同消息类型显示不同 关注消息 昵称为绿色  进入房间为蓝色 礼物消息为粉丝 弹幕 黄色  聊天消息 黄色
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:allStr];
    NSRange nameRang = NSMakeRange(0, name.length);
    [attributeString addAttribute:NSForegroundColorAttributeName value:[self messageUserNameColor:message.message.subType] range:nameRang];
    self.userMessageLb.attributedText = attributeString;
    WeakSelf;
    [self.userMessageLb yb_addAttributeTapActionWithStrings:@[name] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        NSString *userId = weakSelf.message.message.fromUserId;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"userId" : userId}];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBankerClickUser object:nil userInfo:@{@"userId" : userId}];
    }];
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

- (NSString *)pushMessage:(PushMessage *)message{

    switch (message.subType) {
        case 1:
            return @"进入房间";
            break;
        case 2:
            return @"关注了主播";
            break;
        case 6:
            return @"在直播中升级了";
            break;
        case 7:
            return @"用户被踢";
            break;
        case 9:
            return @"分享了直播";
        case 11:
            return @"领取了红包";
            break;
        default:
            return message.message;
            break;
    }
    return message.message;
}

- (UIColor *)messageUserNameColor:(NSInteger)colorType{

    switch (colorType) {
        case 1:
           return UIColorFromRGB(0x15bdf4);
            break;
        case 2:
           return UIColorFromRGB(0x1eea70);
            break;
        case 3:
            return  UIColorFromRGB(0xffe891);
            break;
        case 4:
            return UIColorFromRGB(0xffe891);
            break;
        case 12:
            return  UIColorFromRGB(0xffe891);
            break;
        default:
            return  UIColorFromRGB(0xe857c1);
            break;
    }
    
    return UIColorFromRGB(0xe857c1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
