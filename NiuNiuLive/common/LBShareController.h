//
//  LBShareController.h
//  Weather
//
//  Created by luobaoyin on 16/12/2.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 新的分享界面
 */
@interface LBShareController : UIViewController
NS_ASSUME_NONNULL_BEGIN

/**
 分享失败block
 */
@property (copy, nonatomic) void(^shareFailBlock)(void);

/**
 分享成功block
 */
@property (copy, nonatomic) void(^shareSuccessBlock)(void);

/**
 分享取消block
 */
@property (copy, nonatomic) void(^shareCancelBlock)(void);

/**
 *  图片地址
 */
@property (nonatomic,copy) NSString *imgPath;

/**
 *  将要转化成图片的view
 */
@property (nonatomic,strong) UIImageView *shareImgView;
/**
 *  分享的图片
 */
@property (nonatomic,strong) UIImage *shareImg;

/**
 *  分享文字
 */
@property (nonatomic,copy) NSString *shareText;

/**
 调用分享需要传递的viewcontroller
 */
@property (weak, nonatomic) UIViewController *beViewController;

/**
 *  初始化
 *
 *  @param message 分享消息
 *
 *  @return 实例
 */
-(instancetype)initWithMessage:(NSString  *)message;

/**
 *  显示分享view
 *
 *  @return self
 */
+(instancetype)showShareViewWithMessage:(NSString *)message;


/**
 分享地址
 */
@property (copy, nonatomic) NSString *shareUrl;

/**
 *  显示分享视图
 */
- (void)showShareViewAnimation;

/**

 *  隐藏分享视图
 */
- (void)hiddenShareViewAnimation;


NS_ASSUME_NONNULL_END


@end
