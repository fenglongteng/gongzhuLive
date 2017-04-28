//
//  AHDeleteCellAnimation.h
//  
//
//  Created by Mac on 16/5/6.
//  Copyright © 2016年 YinTokey. All rights reserved.
//
//  This animation class is used for UICollectionViewCell deletion,
//  it's also avaliable in other controls inherited from UIView


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AHDeleteCellAnimation : NSObject
/**
 *  Make the cell vibrate
 *
 *  @param AniView UICollectionViewCell
 */
+(void)vibrateAnimation:(UIView *)AniView;


/**
 *  Delete cell with toMiniAnimation
 *
 *  @param AniView UICollectionViewCell
 */
+ (void)toMiniAnimation:(UIView *)AniView;
@end
