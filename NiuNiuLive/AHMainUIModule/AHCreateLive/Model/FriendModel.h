//
//  FriendModel.h
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/6.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

/**
 *  好友昵称
 */
@property(nonatomic,strong)NSString * chineseName;
/**
 *  好友昵称的拼音
 */
@property(nonatomic,strong)NSString * englishName;

/**
 *  好友头像
 */
@property(nonatomic,strong)NSString * faceurl;
/**
 *  标签
 */
@property(nonatomic,strong)NSString * labelText;
/**
 *  用户id
 */
@property(nonatomic,strong)NSString * userid;
@end
