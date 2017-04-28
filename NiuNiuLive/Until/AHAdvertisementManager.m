//
//  AHAdvertisementManager.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/19.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHAdvertisementManager.h"
#import "NSString+Tool.h"
#import "Systems.pbobjc.h"
@interface AHAdvertisementManager()
@property(nonatomic, strong)SystemGetADListResponse *adListRespose;
@end

@implementation AHAdvertisementManager
+(instancetype)manager{
    static AHAdvertisementManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AHAdvertisementManager alloc]init];
        [manager requestAdvertisement];
    });
    return manager;
}

//获取广告
-(void)requestAdvertisement{
    SystemGetADListRequest *adListRequst  = [[SystemGetADListRequest alloc]init];
    adListRequst.userId = [AHPersonInfoManager manager].getInfoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:adListRequst classSite:SystemsClassName completion:^(id response, NSString *error) {
        SystemGetADListResponse *adListRespose = response;
        if (adListRespose.result == 0) {
            self.adListRespose = adListRespose;
            self.ad1Array = adListRespose.ad1Array;
            self.ad2Array = adListRespose.ad2Array;
            self.ad3Array = adListRespose.ad3Array;
            [self upDataArray];
        }else{
//            static NSInteger number = 0.1;
//            number = number*2;
//            if(number < 1){
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(number * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self requestAdvertisement];
//                });
//            }
    
        }
    }];
}



-(void)upDataArray{
    NSArray *array1 = self.adListRespose.ad1Array;
    NSArray *array2 = self.adListRespose.ad2Array;
    NSArray  *array3 = self.adListRespose.ad3Array;
    [array1 enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(SystemGetADListResponse_AD* ad, NSUInteger idx, BOOL * _Nonnull stop) {
        ad.URL = [NSString stringWithFormat:@"%@%@",_adListRespose.URLPrefix,ad.URL];
    }];
    [array2 enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(SystemGetADListResponse_AD* ad, NSUInteger idx, BOOL * _Nonnull stop) {
         ad.URL = [NSString stringWithFormat:@"%@%@",_adListRespose.URLPrefix,ad.URL];
    }];
    [array3 enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(SystemGetADListResponse_AD* ad, NSUInteger idx, BOOL * _Nonnull stop) {
        ad.URL = [NSString stringWithFormat:@"%@%@",_adListRespose.URLPrefix,ad.URL];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.updata) {
            self.updata();
        }
    });
}
@end
