//
//  AHPinyinSort.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/11.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PinyinSort)(NSDictionary<NSString *,NSArray *> *addressBookDict,NSArray *nameKeys);;
@interface AHPinyinSort : NSObject
//拼音block
+(void)PinYin:(NSArray*)array and:(PinyinSort)pinyinSort;
@end
