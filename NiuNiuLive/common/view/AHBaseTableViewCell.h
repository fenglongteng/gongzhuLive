//
//  AHBaseTableViewCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHBaseModel.h"
#import "NSURL+AHPercentEncoding.h"
#import "NSString+Tool.h"
#import "AHAlertView.h"
@interface AHBaseTableViewCell : UITableViewCell
//模型基类
@property(nonatomic,strong)id oldModel;

/**
 获取cell的identifier

 @return identifier字符串
 */
+(NSString*)getIdentifier;

/**
 绑定cell模型

 @param oldModel 模型基类
 */
-(void)setOldModel:(id)oldModel;

@end
