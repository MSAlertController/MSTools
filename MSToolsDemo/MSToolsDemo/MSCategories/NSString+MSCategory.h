//
//  NSString+MSCategory.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MSCategory)

UIKIT_EXTERN NSString *_Nonnull NSStringFromInt(int intValue);
UIKIT_EXTERN NSString *_Nonnull NSStringFromInteger(NSInteger integerValue);
UIKIT_EXTERN NSString *_Nonnull NSStringFromFloat(float floatValue);
UIKIT_EXTERN NSString *_Nonnull NSStringFromCGFloat(CGFloat floatValue);
UIKIT_EXTERN NSString *_Nonnull NSStringFromAnyValue(id _Nullable anyValue);

/** JSON字符串转字典 */
- (NSDictionary * __nonnull)transformToDict;

/** JSON字符串转NSData */
- (NSData * __nonnull)transformToData;

/** 移除所有不是数字的字符 */
- (NSString * _Nonnull)removeNoNumbers;

/** 验证手机号 */
- (BOOL)validateCellPhone;

/** 验证电话号码 */
- (BOOL)validateTelePhone;

/** 验证邮箱 */
- (BOOL)validateEmail;

/** 验证密码 */
- (BOOL)validatePassword;

/** 验证身份证号码 */
- (BOOL)validateIDNumber;

/** 判断身份证号码最后一位是不是X */
- (BOOL)validateTheLastIDNumberWhetherX;

/** 根据高度计算宽度 */
- (CGFloat)boundingWidthWithHeight:(CGFloat)height font:(CGFloat)font;

/** 根据宽度计算高度 */
- (CGFloat)boundingHeightWithWidth:(CGFloat)width font:(CGFloat)font;

/** 对字符串进行MD5加密 */
- (NSString * _Nonnull)MD5Encryption;

/** 对文件进行MD5加密,用文件路径调用 */
- (NSString * _Nonnull)FileMD5Encryption;

@end
