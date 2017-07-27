//
//  MSTools.m
//
//  Created by moses on 2017/7/18.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "MSTools.h"
#import <sys/utsname.h>
#import <Photos/Photos.h>

@interface MSTools () 

@end

@implementation MSTools

/** 通过window的根视图控制器弹出新的控制器 */
+ (void)presentViewController:(UIViewController * __nonnull)viewController completion:(void (^ __nullable)(void))completion {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController presentViewController:viewController animated:YES completion:completion];
}

/** 获取当前显示的控制器 */
+ (UIViewController * __nonnull)getCurrentVC {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWindow in windows){
            if (tmpWindow.windowLevel == UIWindowLevelNormal) {
                window = tmpWindow;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    // 如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    } else {
        result = nextResponder;
    }
    return result;
}

/** 获取设备的IDFV(使用keychain保存，APP卸载后不会变) */
+ (NSString * __nonnull)getDeviceIDFV {
    NSString *UUID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    if (![SAMKeychain passwordForService:@"UDID" account:@"MSTools"]) {
        [SAMKeychain setPassword:UUID forService:@"UDID" account:@"MSTools"];
    }
    return [SAMKeychain passwordForService:@"UDID" account:@"MSTools"];
}

/** 获取现在的时间戳 */
+ (NSString * __nonnull)getNowTimestamp {
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

/** 获取现在的时间戳（毫秒级别） */
+ (NSString * __nonnull)getNowMSTimestamp {
    UInt64 nowTime = [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%llu", nowTime];
}

/** 获取APP版本 */
+ (NSString * __nonnull)getAppVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return infoDict[@"CFBundleShortVersionString"];
}

/** 获取应用唯一标识 */
+ (NSString * __nonnull)getAppBundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

/** 获取系统版本 */
+ (NSString * __nonnull)getSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

/** 获取设备型号 */
+ (NSString * __nonnull)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4s";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,3"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 (4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad mini 4";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

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
+ (NSString * __nonnull)getRandomStringWithCount:(NSInteger)count uppercaseString:(BOOL)upper lowercaseString:(BOOL)lower numberString:(BOOL)number firstChar:(MSRandomStringFirstChar)firstChar {
    if (count <= 0) {
        return @"";
    }
    if (count == 1) {
        if (firstChar == MSRandomStringFirstCharAll) {
            char str = [self getRandomString];
            return [NSString stringWithCString:&str encoding:NSUTF8StringEncoding];
        } else if (firstChar == MSRandomStringFirstCharLetter) {
            int random = arc4random_uniform(26);
            char str = arc4random_uniform(2) ? ('A' + random) : ('a' + random);
            return [NSString stringWithCString:&str encoding:NSUTF8StringEncoding];
        } else if (firstChar == MSRandomStringFirstCharUpper) {
            char str = 'A' + (arc4random_uniform(26));
            return [NSString stringWithCString:&str encoding:NSUTF8StringEncoding];
        } else if (firstChar == MSRandomStringFirstCharLower) {
            char str = 'a' + (arc4random_uniform(26));
            return [NSString stringWithCString:&str encoding:NSUTF8StringEncoding];
        } else if (firstChar == MSRandomStringFirstCharNumber) {
            char str = '0' + (arc4random_uniform(10));
            return [NSString stringWithCString:&str encoding:NSUTF8StringEncoding];
        }
        return @"A";
    }
    if (!upper&&!lower&&!number) {
        upper = lower = number = YES;
    }
    char data[count];
    if (firstChar == MSRandomStringFirstCharAll) {
        data[0] = [self getRandomString];
    } else if (firstChar == MSRandomStringFirstCharLetter) {
        data[0] = [self getRandomLetterString];
    } else if (firstChar == MSRandomStringFirstCharUpper) {
        data[0] = [self getRandomUpperString];
    } else if (firstChar == MSRandomStringFirstCharLower) {
        data[0] = [self getRandomLowerString];
    } else if (firstChar == MSRandomStringFirstCharNumber) {
        data[0] = [self getRandomNumberString];
    }
    if (upper&&lower&&number) {
        for (int i = 1; i < count; data[i++] = [self getRandomString]);
        return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    } else if (upper&&lower) {
        for (int i = 1; i < count; data[i++] = [self getRandomLowerString]);
        return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    } else if (upper&&number) {
        for (int i = 1; i < count; data[i++] = [self getRandomUpperAndNumber]);
        return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    } else if (lower&&number) {
        for (int i = 1; i < count; data[i++] = [self getRandomLowerAndNumber]);
        return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    } else if (upper) {
        for (int i = 1; i < count; data[i++] = [self getRandomUpperString]);
        return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    } else if (lower) {
        for (int i = 1; i < count; data[i++] = [self getRandomLowerString]);
        return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    } else if (number) {
        for (int i = 1; i < count; data[i++] = [self getRandomNumberString]);
        return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    }
    return @"";
}

+ (char)getRandomString {
    int random = arc4random_uniform(62);
    if (random >= 0 && random <= 9) {
        return '0' + random;
    } else if (random >= 10 && random <= 35) {
        return 'A' + random - 10;
    } else if (random >= 36 && random <= 61) {
        return 'a' + random - 36;
    }
    return 'A';
}
+ (char)getRandomLetterString {
    int random = arc4random_uniform(26);
    return arc4random_uniform(2) ? ('A' + random) : ('a' + random);
}
+ (char)getRandomUpperString {
    return 'A' + (arc4random_uniform(26));
}
+ (char)getRandomLowerString {
    return 'a' + (arc4random_uniform(26));
}
+ (char)getRandomNumberString {
    return '0' + (arc4random_uniform(10));
}
+ (char)getRandomUpperAndNumber {
    int random = arc4random_uniform(36);
    if (random >= 0 && random <= 9) {
        return '0' + random;
    } else {
        return 'A' + random - 10;
    }
}
+ (char)getRandomLowerAndNumber {
    int random = arc4random_uniform(36);
    if (random >= 0 && random <= 9) {
        return '0' + random;
    } else {
        return 'a' + random - 10;
    }
}

/**
 获取最近的一张照片/屏幕快照
 
 @param screenshots 照片/屏幕快照
 @param imageBlock  返回图片数据
 */
+ (void)getCurrentScreenshots:(BOOL)screenshots imageBlock:(void (^ __nonnull)(UIImage * __nullable image))imageBlock {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        DLog(@"相册权限未开放");
        imageBlock(nil);
        return;
    }
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
        DLog(@"如果用户还没设置权限，提醒用户获取相册权限");
        imageBlock(nil);
        return;
    }
    PHAssetCollection *assetCollection;
    if (screenshots) {
        assetCollection = [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil] firstObject];
    } else {
        assetCollection = [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil] firstObject];
    }
    PHAsset *asset = [[PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]] lastObject];
    if (!asset) {
        DLog(@"相册里没有照片或屏幕快照里没有照片");
        imageBlock(nil);
        return;
    }
    long long now = [[NSDate date] timeIntervalSince1970];
    long long creatTime = [asset.creationDate timeIntervalSince1970];
    if ((now - creatTime) > 86400) {
        DLog(@"最新的照片或屏幕快照是一天以前的");
        imageBlock(nil);
        return;
    }
    if (screenshots) {
        NSInteger index = (kWidth == 414) ? 3 : 2;
        CGSize targetSize = CGSizeMake(kWidth * index, kHeight * index);
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                if (result.size.width == targetSize.width && result.size.height == targetSize.height) {
                    imageBlock(result);
                } else {
                    DLog(@"屏幕快照尺寸不对");
                    imageBlock(nil);
                }
            } else {
                DLog(@"没有获取到最近的屏幕快照");
                imageBlock(nil);
            }
        }];
    } else {
        [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) {
                imageBlock([UIImage imageWithData:imageData]);
            } else {
                DLog(@"没有获取到最近的照片");
                imageBlock(nil);
            }
        }];
    }
}

@end
