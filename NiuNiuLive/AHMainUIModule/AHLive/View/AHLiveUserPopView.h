//
//  AHLiveUserPopView.h
//  NiuNiuLive
//
//  Created by anhui on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHLiveUserPopView : UIView

@property (weak, nonatomic) IBOutlet UIView *userbackView;

@property (nonatomic,copy) NSString *userId;//用户ID

@property (nonatomic, copy) void (^closeBlock)();
+ (id)LiveUserPopView;

@end
