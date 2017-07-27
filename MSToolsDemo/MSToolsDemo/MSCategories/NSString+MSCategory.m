//
//  NSString+MSCategory.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "NSString+MSCategory.h"
#import <CommonCrypto/CommonDigest.h>

NSInteger FileHashDefaultChunkSizeForReadingData = 1024 * 8;

@implementation NSString (MSCategory)

NSString *NSStringFromInt(int intValue) {
    return [NSString stringWithFormat:@"%d", intValue];
}
NSString *NSStringFromInteger(NSInteger integerValue) {
    return [NSString stringWithFormat:@"%ld", (long)integerValue];
}
NSString *NSStringFromFloat(float floatValue) {
    return [NSString stringWithFormat:@"%.2f", floatValue];
}
NSString *NSStringFromCGFloat(CGFloat floatValue) {
    return [NSString stringWithFormat:@"%.2f", floatValue];
}
NSString *NSStringFromAnyValue(id anyValue) {
    return [NSString stringWithFormat:@"%@", anyValue];
}

/** JSON字符串转字典 */
- (NSDictionary * __nonnull)transformToDict {
    if (self && self.length) {
        NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    }
    return @{};
}

/** JSON字符串转NSData */
- (NSData * __nonnull)transformToData {
    if (self && self.length) {
        return [self dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [NSData data];
}

/** 移除所有不是数字的字符 */
- (NSString *)removeNoNumbers {
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return  [[self componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
}

/** 验证手机号 */
- (BOOL)validateCellPhone {
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[0-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/** 验证电话号码 */
- (BOOL)validateTelePhone {
    NSString *regex = @"(^(010)\\d{8}$)|(^(02)[^6,\\D]\\d{8}$)|(^(0[3-9])\\d{9,10}$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/** 验证邮箱 */
- (BOOL)validateEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/** 验证密码 */
- (BOOL)validatePassword {
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";//6-12位字母和数字的组合
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/** 验证身份证号码 */
- (BOOL)validateIDNumber {
    NSString *regex = @"\\d{17}[(0-9)|(x)|(X)]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:self]) {
        return [self isCorrect];
    }
    return NO;
}

/** 判断身份证号码最后一位是不是X */
- (BOOL)validateTheLastIDNumberWhetherX {
    NSString *regex = @"\\d{17}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:self]) {
        return [self theLastIsX];
    }
    return NO;
}

/** 根据高度计算宽度 */
- (CGFloat)boundingWidthWithHeight:(CGFloat)height font:(CGFloat)font {
    return [self boundingRectWithSize:(CGSizeMake(MAXFLOAT, height)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.width;
}

/** 根据宽度计算高度 */
- (CGFloat)boundingHeightWithWidth:(CGFloat)width font:(CGFloat)font {
    return [self boundingRectWithSize:(CGSizeMake(width, MAXFLOAT)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.height;
}

/** 对字符串进行MD5加密 */
- (NSString *)MD5Encryption {
    const char *variable1 = [self UTF8String];
    unsigned char variable2[CC_MD5_DIGEST_LENGTH];
    CC_MD5(variable1, (CC_LONG)strlen(variable1), variable2);
    NSMutableString *variable3 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [variable3 appendFormat:@"%02x", variable2[i]];
    }
    return variable3;
}

/** 对文件进行MD5加密,用文件路径调用 */
- (NSString *)FileMD5Encryption {
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPaths((__bridge CFStringRef)self, FileHashDefaultChunkSizeForReadingData);
}

#pragma mark -- 身份证号码验证算法

- (BOOL)isCorrect {
    NSMutableArray *IDArray = [NSMutableArray array];
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        [IDArray addObject:subString];
    }
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    NSString *str = remainderArray[(sum % 11)];
    NSString *string = [self substringFromIndex:17];
    return ([str isEqualToString:string] || [str isEqualToString:[string uppercaseString]]);
}

#pragma mark -- 根据前17位数判断身份证号码最后一位是不是X

- (BOOL)theLastIsX {
    NSMutableArray *IDArray = [NSMutableArray array];
    for (int i = 0; i < 17; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        [IDArray addObject:subString];
    }
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    return sum % 11 == 2;
}

#pragma mark -- C语言代码

CFStringRef FileMD5HashCreateWithPaths(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

@end
