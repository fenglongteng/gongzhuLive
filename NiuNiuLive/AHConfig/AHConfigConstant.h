//
//  AHConfigConstant.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/29.
//  Copyright © 2017年 AH. All rights reserved.
//配置文件常量

#ifndef AHConfigConstant_h
#define AHConfigConstant_h

//用户金币数改变的通知
#define  UserGoldDidChange       @"UserGoldDidChange"
// 点击了用户
#define kNotifyClickUser        @"kNotifyClickUser"

//主播点击用户
#define kNotifyBankerClickUser   @"kNotifyBankerClickUser"

//关注了主播
#define kNotifityLikeUser        @"kNotifityLikeUser"

//取消关注
#define kNotifityUnLikeUser      @"kNotifityUnLikeUser"

//socket断开通知
#define kNotifitySocketDisConnect   @"kNotifitySocketDisConnect"

// swipte 上滑动 弹出游戏界面
#define kNotifiGameSwipeUp       @"kNotifiGameSwipeUp"

// 下滑动 关闭游戏界面
#define kNotifiGameSwipeDown     @"kNotifiGameSwipeDown"

//用户信息plist文件名
#define PersonInfoFilePath       @"personInfo.plist"

//关注
#define MyAttentionFilePath       @"myAttention.plist"

//粉丝
#define MyFansFilePath       @"myFans.plist"

//我的消息
#define MyMessagePath       @"myMessage.plist"

//设置页面配置文件
#define OnlyAcceptSpecialAttention  @"Only_Accept_Special_Attention" //仅仅接受特别关注的开通通知

#define OpenTheMessageNotificationSound  @"Open_The_Message_Notification_Sound" //开启消息通知音效

#define InformHideChatContent  @"Inform_Hide_Chat_Content" //通知隐藏聊天内容

#define SignTimeOfLastTime   @"signTimeOfLastTime" //上传签到时间

#define SepecialAttention     @"sepecialAttention"  //特别关注通知

#define RefreshMeAccountViewController  @"refreshMeAccountViewController" //刷新my页面通知

#define SocketDidConnect @"SocketDidConnect" //socket重新连接的通知

#define CloseLive   @"CloseLive"   //关闭直播

#endif /* AHConfigConstant_h */
