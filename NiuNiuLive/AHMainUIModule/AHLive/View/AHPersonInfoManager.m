//
//  AHPersonInfoManager.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/6.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPersonInfoManager.h"
#import "YYModel.h"
@interface AHPersonInfoManager()
//用户信息模型
@property(nonatomic,strong)AHPersonInfoModel *model;
//我关注的列表
@property(nonatomic, strong) NSMutableArray *myLikeArray;
/** 关注我用户id的列表 */
@property(nonatomic, strong) NSMutableArray *likeMeArray;
//我的消息列表
@property(nonatomic, strong) NSMutableArray *MessageArray;
@end

@implementation AHPersonInfoManager
+(instancetype)manager{
    static AHPersonInfoManager *personInfoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized (personInfoManager) {
             personInfoManager = [[AHPersonInfoManager alloc]init];
            personInfoManager.MessageArray = [NSMutableArray array];
        }
       
    });
    return personInfoManager;
}

#pragma mark 个人资料

-(AHPersonInfoModel*)getInfoModel{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    LOG(@"homeDirectory = %@", documentsDirectory);
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:PersonInfoFilePath];
    //读出文件
    if (  [[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSMutableDictionary *infoDic = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] mutableCopy];
        _model = [AHPersonInfoModel yy_modelWithDictionary:infoDic];
    }else{
        //防nil
        _model = [[AHPersonInfoModel alloc]init];
    }
    return _model;
}

-(void)setInfoModel:(AHPersonInfoModel*)infoModel{
    @synchronized (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //    LOG(@"homeDirectory = %@", documentsDirectory);
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:PersonInfoFilePath];
        NSDictionary *dic = [infoModel yy_modelToJSONObject];
        //写入文件
        [dic writeToFile:plistPath atomically:YES];
        _model = infoModel;
    }

}

-(void)setWithJson:(id)json{
    @synchronized (self) {
        NSMutableDictionary *newInfoDic = [json yy_modelToJSONObject];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //    LOG(@"homeDirectory = %@", documentsDirectory);
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:PersonInfoFilePath];
        //原模型字典
        NSMutableDictionary *oldInfoDic= [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] mutableCopy];
        //防nil
        if (!([oldInfoDic allKeys].count >0)) {
            oldInfoDic = [NSMutableDictionary dictionary];
        }
        
        //修改对应的key-value
        NSArray *keyArray  = [newInfoDic allKeys];
        if (keyArray.count>0) {
            for (NSString *key in keyArray) {
                if (  [newInfoDic objectForKey:key]) {
                    //去除星座
                    if ([key isEqualToString:@"constellation"]) {
                        
                    }else{
                        [oldInfoDic setObject:newInfoDic[key] forKey:key];
                    }
                    
                }
            }
            [oldInfoDic writeToFile:plistPath atomically:YES];
        }
    }

}

#pragma mark 关注
//我关注的好友
-(void)setMyLikeArray:(NSMutableArray *)myLikeArray{
    @synchronized (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //    LOG(@"homeDirectory = %@", documentsDirectory);
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:MyAttentionFilePath];
        
        //写入文件
        [myLikeArray writeToFile:plistPath atomically:YES];
        _myLikeArray = myLikeArray;
    }

}

-(NSMutableArray*)getMyLikeArray{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    LOG(@"homeDirectory = %@", documentsDirectory);
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:MyAttentionFilePath];
    //读出文件
    if (  [[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
         _myLikeArray = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    }else{
        //防nil
        _myLikeArray = [NSMutableArray array];
    }
    return _myLikeArray;
}

#pragma mark 粉丝
//我的粉丝
-(void)setLikeMeArray:(NSMutableArray *)likeMeArray{
    @synchronized (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //    LOG(@"homeDirectory = %@", documentsDirectory);
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:MyAttentionFilePath];
        
        //写入文件
        [likeMeArray writeToFile:plistPath atomically:YES];
        _likeMeArray = likeMeArray;
    }

}

-(NSMutableArray*)getLikeMeArray{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    LOG(@"homeDirectory = %@", documentsDirectory);
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:MyFansFilePath];
    //读出文件
    if (  [[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        _likeMeArray = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    }else{
        //防nil
        _likeMeArray = [NSMutableArray array];
    }
    return _likeMeArray;
}

#pragma mark 消息
//我的消息
-(void)setMyMessageArray:(NSMutableArray *)messageArray{
    @synchronized (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //    LOG(@"homeDirectory = %@", documentsDirectory);
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:MyMessagePath];
        //写入文件
        [messageArray writeToFile:plistPath atomically:YES];
        _MessageArray = messageArray;
    }
}

-(NSMutableArray*)getMyMessageArray{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    LOG(@"homeDirectory = %@", documentsDirectory);
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:MyMessagePath];
    //读出文件
    if (  [[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        _MessageArray = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    }else{
        //防nil
        _MessageArray  = [NSMutableArray array];
    }
    return _MessageArray;
}
@end
