//
//  AHAlertView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseView.h"

typedef NS_ENUM(NSInteger, AHAlertShowType) {
    AHAlertAnchorLeave = 0, //主播离开
    AHAlertAnchorPhone,      //主播有电话来
    AHAlertKictOut,      //被踢出
    AHAlertMaster,      //你成为场控
    AHAlertBanned,    //被禁言
    AHAlertPushNotification, //推送通知
    AHAlertViewNoNetwork    //无网络
};

@interface AHAlertView : AHBaseView

//弹框类型
@property (nonatomic,assign)AHAlertShowType alertType;

//弹框 常见类型初始化
- (instancetype)initAlertViewReminderTitle:(NSString *)reminderTitle title:(NSString *)title cancelBtnTitle:(NSString *)cancel cancelAction:(void (^)())cancelHandler;

//显示
- (void)showAlert;

/**
 初始化任务提示框

 @param title 标题
 @param detailArray 任务详情说明数组（字符串）
 @param cancelHandler 取消按钮事件
 @return 任务提示框
 */
-(instancetype)initListAlertTitle:(NSString*)title AndDetailInstructions:(NSArray*)detailArray cancelAction:(void (^)())cancelHandler;

/**
 初始化设置提示框

 @param title 标题
 @param detailString 提示详情
 @param leftStr 左侧按钮文字
 @param rightStr 右侧按钮文字
 @param cancelHandler 左侧按钮事件
 @param settingAcion 又侧按钮事件
 @return 设置提示框
 */
- (instancetype)initSetAlertViewTitle:(NSString *)title detailString:(NSString *)detailString AndLeftBt:(NSString *)leftStr AndRight:(NSString*)rightStr  cancelAction:(void (^)())cancelHandler settingAction:(void (^)())settingAcion;


/**
 初始化直播通知
 @param urlStr 头像Url
 @param statusStr 直播状态
 @param title 标题
 @param detailString 提示详情
 @param leftStr 左侧按钮文字
 @param rightStr 右侧按钮文字
 @param cancelHandler 左侧按钮事件
 @param settingAcion 又侧按钮事件
 @return 直播通知提示框
 */
-(instancetype)initLiveNoticeAlertViewHeadImage:(NSString*)urlStr Status:(NSString*)statusStr Title:(NSString *)title detailString:(NSString *)detailString AndLeftBt:(NSString *)leftStr AndRight:(NSString*)rightStr  cancelAction:(void (^)())cancelHandler settingAction:(void (^)())settingAcion;

@end
