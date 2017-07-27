//
//  UIColor+MSCategory.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "UIColor+MSCategory.h"

@implementation UIColor (MSCategory)

- (MSColorValue *)value {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    MSColorValue *value = [MSColorValue new];
    value.red = red;
    value.green = green;
    value.blue = blue;
    value.alpha = alpha;
    return value;
}

- (UIColor *)setColorAlpha:(CGFloat)alpha {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    [self getRed:&red green:&green blue:&blue alpha:0];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    } else if ([hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    if (hexString.length != 6) {
        return nil;
    }
    unsigned long red = strtoul([[hexString substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
    unsigned long green = strtoul([[hexString substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
    unsigned long blue = strtoul([[hexString substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);
    return [self colorWithRed:red green:green blue:blue];
}

@end

@implementation MSColorValue

@end
