//
//  UIColor+MSCategory.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSColorValue;
@interface UIColor (MSCategory)

@property (nonatomic, strong, readonly) MSColorValue *value;

- (UIColor *)setColorAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

@interface MSColorValue : NSObject

@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat alpha;

@end
