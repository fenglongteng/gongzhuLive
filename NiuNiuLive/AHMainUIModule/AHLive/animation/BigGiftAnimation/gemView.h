//
//  gemView.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/31.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gemView : UIView

@property(nullable,strong)UIView * backView;

@property (weak, nonatomic,nullable) IBOutlet UIImageView *redImage;
@property (weak, nonatomic,nullable) IBOutlet UIImageView *yellowImage;
@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;

/**
 *  放大倍数：从(from)scale 到(to)scale 
 */
@property (nullable, strong) id scaleFromValue;
@property (nullable, strong) id scaleToValue;
/**
 *  动画结束后动画层是否从当前视图上移除，默认 NO
 */
@property (nonatomic, assign) BOOL removedOnCompletion;
/**
 *  加载动画视图
 *  @return 返回你需要的动画视图
 */
+ (nullable instancetype)loadGemViewWithPoint:(CGPoint)point;


- (void)addGemAnimationFromValue:(CGFloat)scaleFromValue toValue:(CGFloat)scaleToValue;
@end
