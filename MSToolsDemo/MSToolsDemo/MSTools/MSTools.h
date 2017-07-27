//
//  MSTools.h
//
//  Created by moses on 2017/7/18.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MSRandomStringFirstChar) {
    MSRandomStringFirstCharAll,//无限制
    MSRandomStringFirstCharLetter,//字母
    MSRandomStringFirstCharUpper,//大写字母
    MSRandomStringFirstCharLower,//小写字母
    MSRandomStringFirstCharNumber//数字
};

@interface MSTools : NSObject

/** 通过window的根视图控制器弹出新的控制器 */
+ (void)presentViewController:(UIViewController * __nonnull)viewController completion:(void (^ __nullable)(void))completion;

/** 获取当前显示的控制器 */
+ (UIViewController * __nonnull)getCurrentVC;

/** 获取设备的IDFV(使用keychain保存，APP卸载后不会变) */
+ (NSString * __nonnull)getDeviceIDFV;

/** 获取现在的时间戳 */
+ (NSString * __nonnull)getNowTimestamp;

/** 获取现在的时间戳（毫秒级别） */
+ (NSString * __nonnull)getNowMSTimestamp;

/** 获取APP版本 */
+ (NSString * __nonnull)getAppVersion;

/** 获取应用唯一标识 */
+ (NSString * __nonnull)getAppBundleID;

/** 获取系统版本 */
+ (NSString * __nonnull)getSystemVersion;

/** 获取设备型号 */
+ (NSString * __nonnull)getDeviceModel;

/**
 获取N个随机字符串
 (如果count==0返回@"";如果count==1,三个布尔值失效,返回值由firstChar控制)
 @param count  随机字符串的长度
 @param upper  是否包含大写字母
 @param lower  是否包含小写字母
 @param number 是否包含数字
 @param firstChar 首字符类型：MSRandomStringFirstChar
 
 @return 随机字符串
 */
+ (NSString * __nonnull)getRandomStringWithCount:(NSInteger)count uppercaseString:(BOOL)upper lowercaseString:(BOOL)lower numberString:(BOOL)number firstChar:(MSRandomStringFirstChar)firstChar;

/**
 获取最近的一张照片/屏幕快照

 @param screenshots 照片/屏幕快照
 @param imageBlock  返回图片数据
 */
+ (void)getCurrentScreenshots:(BOOL)screenshots imageBlock:(void (^ __nonnull)(UIImage * __nullable image))imageBlock;

@end
