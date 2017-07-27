//
//  NSData+MSCategory.m
//
//  Created by moses on 2017/7/26.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "NSData+MSCategory.h"

@implementation NSData (MSCategory)

/** NSData转字典 */
- (NSDictionary * __nonnull)transformToDict {
    if (self) {
        return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:nil];
    }
    return @{};
}

/** NSData转JSON字符串 */
- (NSString * __nonnull)transformToJSONString {
    if (self) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    return @"";
}

@end
