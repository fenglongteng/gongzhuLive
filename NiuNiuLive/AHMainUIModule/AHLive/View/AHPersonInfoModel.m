//
//  AHPersonInfoModel.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/6.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPersonInfoModel.h"
#import "YYModel.h"
#import "NSString+Tool.h"
@implementation AHPersonInfoModel
-(NSString*)genderString{
    if (self.gender == 0) {
        _genderString = @"无";
    }else if (self.gender == 1){
        _genderString = @"男";
    }else{
        _genderString = @"女";
    }
    return _genderString;
}

//利用dic初始化
+(instancetype)initWithJson:(id)json{
    AHPersonInfoModel *infoModel = nil;
    NSMutableDictionary *newInfoDic = [json yy_modelToJSONObject];
    infoModel = [AHPersonInfoModel yy_modelWithDictionary:newInfoDic];
    return infoModel;
}

@end
