//
//  NSURL+AHPercentEncoding.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/6.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "NSURL+AHPercentEncoding.h"
#import "NSString+Tool.h"
@implementation NSURL (AHPercentEncoding)
+(instancetype)URLWithPercentEncodingString:(NSString *)URLString{
    if (URLString.length >0) {
        if ([NSString testStringContainChineseCharacters:URLString]) {
            URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
           NSURL *url = [NSURL URLWithString:URLString];
        return url;
    }else{
        return nil;
    }
}
@end
