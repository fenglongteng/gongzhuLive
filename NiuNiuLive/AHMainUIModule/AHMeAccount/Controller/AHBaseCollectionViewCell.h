//
//  AHBaseCollectionViewCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHBaseModel.h"
@interface AHBaseCollectionViewCell : UICollectionViewCell
//模型基类
@property(nonatomic,strong)AHBaseModel *model;

/**
 获取cell的identifier
 
 @return identifier字符串
 */
+(NSString*)getIdentifier;

/**
 绑定cell模型
 
 @param model 模型基类
 */
-(void)setModel:(AHBaseModel *)model;
@end
