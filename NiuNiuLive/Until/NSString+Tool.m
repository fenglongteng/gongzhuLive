//
//  NSString+Tool.m
//  Weather
//
//  Created by ComAnvei on 16/11/2.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

+(NSInteger)screenNumber:(NSString*)string{
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSInteger remainSecond =[[string stringByTrimmingCharactersInSet:nonDigits] integerValue];
    return remainSecond;
}

//判断是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+(BOOL)stringIsImageURL:(NSString*)url{
    if (! (url.length> 0) ) {
        return NO;
    }
    NSArray *array = @[@"bmp",@"dib",@"rle",@"emf",@"gif",@"jpg",@"jpeg",@"jpe",@"jif", @"pcx",@"dcx",@"pic",@"png",@"tga",@"tif",@"tiffxif",@"wmf",@"jfif"];
    for (NSString *suffxString in array) {
        if ([url hasSuffix:suffxString]) {
              return YES;
        }
    }
    return NO;
}

//生成一个uuid的方法
+(NSString *)getUUIDSString{
    NSString *strUUID = nil;
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
    return strUUID;
}

//检查字符串是否包含中文
+(BOOL)testStringContainChineseCharacters:(NSString*)text{
    if(text.length >0){
        
    }else{
        return NO;
    }
    NSError *error = NULL;
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex2 firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    if (result) {
        return YES;
    }else{
        return NO;
    }
}

//将Unicode编码转成中文
+(NSString *)replaceUnicode:(NSString *)unicodeStr{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    returnStr =   [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    //这里去除了换行去除了（） 去除了“” 等特殊符号
    returnStr =   [returnStr stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    returnStr =  [returnStr stringByReplacingOccurrencesOfString:@"\""withString:@""];
    returnStr =  [returnStr stringByReplacingOccurrencesOfString:@")"withString:@""];
    returnStr =  [returnStr stringByReplacingOccurrencesOfString:@"("withString:@""];
    return returnStr;
    
}

- (BOOL)evaluateWithPredicate:(NSString *)predicate{
    NSAssert(predicate != nil, @"请输入一个不为空的正则表达式");
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicate];
    return [emailTest evaluateWithObject:self];
}

+(BOOL)testStringIsPhoneNumber:(NSString*)phoneNumber{
    NSString *phoneRegex1=@"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:phoneNumber];
}

//汉子转拼音
//用kCFStringTransformMandarinLatin方法转化出来的是带音标的拼音，如果需要去掉音标，则继续使用kCFStringTransformStripCombiningMarks方法即可。
+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}

//获取图片url
+(NSURL*)getImageUrlString:(NSString*)imageString{
    static NSString *prefixImageString =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        prefixImageString =  [AHPersonInfoManager manager].getInfoModel.webApiUserGetAvatarURL;
    });
    NSString *imageUrlString = [NSString stringWithFormat:@"%@%@",prefixImageString,imageString];
    NSURL *url = [NSURL URLWithString:imageUrlString];
    return url;
}

//个人金币数 装换成字符串
+ (NSString *)getCurrentGold:(int64_t)goldCoin{
    
    if (goldCoin >= 100000000) {
        return [NSString stringWithFormat:@"%.2f亿",goldCoin / 100000000.0];
    }else if(goldCoin >= 10000 && goldCoin < 100000000){
        return [NSString stringWithFormat:@"%.2fW",goldCoin / 10000.0];
    }else{
        return [NSString stringWithFormat:@"%lld",goldCoin];
    }
}


//json字符串转json   key（字符串）:Value（Bool）,  格式
-(NSMutableDictionary*)getJson{
    NSString *str1 =  [self stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *str2 =  [str1 stringByReplacingOccurrencesOfString:@"{" withString:@""];
    NSString *str3 =  [str2 stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (str3.length>0) {
        if ([str3 componentsSeparatedByString:@":"].count>0) {
            if ([str3 componentsSeparatedByString:@","].count>0) {
                for (NSString *itemString in [str3 componentsSeparatedByString:@","]) {
                    NSArray *array =  [itemString componentsSeparatedByString:@":"];
                    BOOL isTure = NO;
                    if ([array[1] isEqualToString:@"true"]) {
                        isTure = YES;
                    }else{
                        isTure = NO;
                    }
                    [dic setObject:@(isTure) forKey:array[0]];
                }
                return dic;
                
            }else{
                NSArray *array =  [str3 componentsSeparatedByString:@":"];
                BOOL isTure = NO;
                if ([array[1] isEqualToString:@"true"]) {
                    isTure = YES;
                }else{
                    isTure = NO;
                }
                [dic setObject:@(isTure) forKey:array[0]];
            }
            return dic;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}


+ (BOOL) IsEmailAdress:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}


+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

//银行卡
+ (BOOL) IsBankCard:(NSString *)cardNumber
    {
        if(cardNumber.length==0)
        {
            return NO;
        }
        NSString *digitsOnly = @"";
        char c;
        for (int i = 0; i < cardNumber.length; i++)
        {
            c = [cardNumber characterAtIndex:i];
            if (isdigit(c))
            {
                digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
            }
        }
        int sum = 0;
        int digit = 0;
        int addend = 0;
        BOOL timesTwo = false;
        for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
        {
            digit = [digitsOnly characterAtIndex:i] - '0';
            if (timesTwo)
            {
                addend = digit * 2;
                if (addend > 9) {
                    addend -= 9;
                }
            }
            else {
                addend = digit;
            }
            sum += addend;
            timesTwo = !timesTwo;
        }
        int modulus = sum % 10;
        return modulus == 0;
    }


@end
