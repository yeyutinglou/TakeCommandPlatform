//
//  NSString+SyString.m
//  SyCore
//
//  Created by menghua.wu on 14-4-23.
//  Copyright (c) 2014年 menghua.wu. All rights reserved.
//

#import "NSString+JYDString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (JYDString)

- (NSString *) replaceCharacter:(NSString *)oStr withString:(NSString *)nStr{
    if (oStr && nStr) {
        NSMutableString *_str = [NSMutableString stringWithString:self];
        [_str replaceOccurrencesOfString:oStr withString:nStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, _str.length)];
        return _str;
    }
    else
        return oStr;
}

+ (NSString *)verifySeverStr:(NSString *)str
{
    if (str == nil ||
        [str isEqualToString:@""]) {
        return @"";
    }
    else {
        // 去掉空格
        NSString *resoultStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([resoultStr isEqualToString:@""]) {
            return @"";
        }
        else {
            return resoultStr;
        }
    }
}

-(CGSize)sizeWidth{
    return [self sizeWidthFont:[UIFont systemFontOfSize:17] size:CGSizeMake(0, App_Main_Screen_Height)];
}
-(CGSize)sizeWidthFont:(UIFont *)font size:(CGSize )size{
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    size = [self boundingRectWithSize:CGSizeMake(0, size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    return size;
}

-(CGSize)sizeHeight{
    return [self sizeHeightFont:[UIFont systemFontOfSize:17]  size:CGSizeMake(App_Main_Screen_Height, 0)];
}
-(CGSize)sizeHeightFont:(UIFont *)font size:(CGSize )size{
    
//    NSDictionary *attribute = @{NSFontAttributeName:font};
//    size = [self boundingRectWithSize:CGSizeMake(size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    size = [self boundingRectWithSize:CGSizeMake(size.width, size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

+(NSString *)getFileSizeString:(int )fileSize{
    NSString *fileSizeStr;
    if(fileSize < 1024){
        fileSizeStr = [NSString stringWithFormat:@"%d B",fileSize];
    }else if (fileSize < 1024 * 1024) {
        fileSizeStr = [NSString stringWithFormat:@"%.2f K",fileSize / 1024.0];
    }else if (fileSize < 1024 * 1024 * 1024) {
        fileSizeStr = [NSString stringWithFormat:@"%.2f M",fileSize / 1024.0 / 1024.0];
    }
    
    return fileSizeStr;
}


- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}


+ (NSString *)positiveFormat:(NSString *)text{
    
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }else{
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
    }
    return @"";
}

/**
 *  校验电话号码
 */
#pragma mark 校验电话号码
-(BOOL)isValidPhone:(NSString *)strPhone{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:strPhone] == YES)
        || ([regextestcm evaluateWithObject:strPhone] == YES)
        || ([regextestct evaluateWithObject:strPhone] == YES)
        || ([regextestcu evaluateWithObject:strPhone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}

//小写
- (NSString*)md532BitLower
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
//大写
- (NSString*)md532BitUpper
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}
  

@end
