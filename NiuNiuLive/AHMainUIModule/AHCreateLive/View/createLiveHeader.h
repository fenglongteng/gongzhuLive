//
//  createLiveHeader.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface createLiveHeader : UIView

- (void)initWithHeaderViewFrame:(CGRect)frame;
//公开房间不传密码
@property(nonatomic,assign)BOOL isCommon;

@property(nonatomic,copy)void (^cancelSearchBlock)();

@property(nonatomic,copy)void (^changeBlock)(NSString * searchStr);
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end
