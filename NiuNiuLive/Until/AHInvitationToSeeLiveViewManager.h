//
//  AHInvitationToSeeLiveView.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/26.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHMessageModel.h"
@interface AHInvitationToSeeLiveView :UIView

//头像
@property(nonatomic,strong)UIImageView *headImageView;

//消息背景图片
@property(nonatomic,strong)UIImageView *messageBackgroudImageView;

//昵称
@property(nonatomic,strong)UILabel *nickNameLabel;

//消息label
@property(nonatomic,strong)UILabel *messageLabel;

//删除按钮
@property(nonatomic,strong)UIButton *deletButton;

//消息model
@property(nonatomic,strong)AHMessageModel *messageModel;

@end


@interface AHInvitationToSeeLiveViewManager : NSObject

//单利
+(instancetype)Manager;

//添加消息model
-(void)addInvitationView:(AHMessageModel*)messageModel;

//显示
-(void)show;

//消失
-(void)dismiss;

@end

