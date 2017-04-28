//
//  inviteView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/15.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface inviteView : UIView
+ (inviteView *)initInviteView;

//当前房间id
@property(nonatomic,strong)NSString * roomid;

@property(nonatomic,copy)void (^ closeBlock)();

- (void)settingViewShow;

@end
