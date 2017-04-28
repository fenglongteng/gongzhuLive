//
//  AHPersonInfoManager.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/6.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHPersonInfoModel.h"
@interface AHPersonInfoManager : NSObject



//单利功能
+(instancetype)manager;

//获取用户信息模型
-(AHPersonInfoModel*)getInfoModel;

#pragma mark 修改本地化用户数据

//修改模型
-(void)setInfoModel:(AHPersonInfoModel*)infoModel;

//通过json修改模型
-(void)setWithJson:(id)json;

//我关注的好友
-(void)setMyLikeArray:(NSMutableArray *)myLikeArray;

-(NSMutableArray*)getMyLikeArray;
//我的粉丝
-(void)setLikeMeArray:(NSMutableArray *)likeMeArray;

-(NSMutableArray*)getLikeMeArray;

//我的消息
-(void)setMyMessageArray:(NSMutableArray *)messageArray;

-(NSMutableArray*)getMyMessageArray;
@end
