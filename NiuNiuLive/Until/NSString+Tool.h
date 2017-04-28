//
//  NSString+Tool.h
//  Weather
//
//  Created by ComAnvei on 16/11/2.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)
//把阿拉伯数字转化成汉子
+(NSString *)translationArabicNum:(NSInteger)arabicNum;

//从字符串中提取出数字
+(NSInteger)screenNumber:(NSString*)string;

//判断是否含emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;

//判读字符串是否是图片url
+(BOOL)stringIsImageURL:(NSString*)url;

//获取UUID
+(NSString *)getUUIDSString;

//判断字符串是否含有中文字符
+(BOOL)testStringContainChineseCharacters:(NSString*)text;

//将Unicode编码转成中文  去除了其中的换行 括号 双引号
+(NSString *)replaceUnicode:(NSString *)unicodeStr;

//通过传入的正则表达式判断字符串
- (BOOL)evaluateWithPredicate:(NSString *)predicate;

//验证字符串是否是手机号码
+(BOOL)testStringIsPhoneNumber:(NSString*)phoneNumber;

//汉子转拼音  性能差 建议单独使用时才用
+ (NSString *)transform:(NSString *)chinese;

//获取图片url
+(NSURL*)getImageUrlString:(NSString*)imageString;

//json字符串转json   key（字符串）:Value（Bool）,  格式
-(NSMutableDictionary*)getJson;

//邮箱
+ (BOOL) IsEmailAdress:(NSString *)Email;

//验证是否是身份证号码
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber;

//银行卡
+ (BOOL) IsBankCard:(NSString *)cardNumber;

//金币数的转化
+ (NSString *)getCurrentGold:(int64_t)goldCoin;

@end
