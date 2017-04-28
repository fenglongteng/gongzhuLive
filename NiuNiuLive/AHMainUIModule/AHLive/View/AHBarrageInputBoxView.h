//
//  AHBarrageInputBoxView.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/1.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SendMessageBlock)(BOOL isBarrage);

@interface AHBarrageInputBoxView : UIView

@property(nonatomic,copy)SendMessageBlock sendMessageBlock;


/**
 给其他用户发送消息

 @param userId 用户id
 @return 单利
 */
+(instancetype)shareWithId:(NSString*)userId;

//直播的时候发送广播消息
+(instancetype)share;

/**
 显示window上
 */
-(void)showOnTheWindow;

/**
 显示在view上
 */
-(void)showOnTheView:(UIView*)view;

/**
 消失
 */
-(void)dimiss;
@end
