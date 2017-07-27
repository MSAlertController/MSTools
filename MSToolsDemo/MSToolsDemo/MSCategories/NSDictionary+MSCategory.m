//
//  NSDictionary+MSCategory.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "NSDictionary+MSCategory.h"

@implementation NSDictionary (MSCategory)

/** 字典转JSON字符串 */
- (NSString * __nonnull)transformToJSONString {
    if (self && self.count) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/** 字典转NSData */
- (NSData * __nonnull)transformToData {
    if (self && self.count) {
        return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    }
    return [NSData data];
}

/** 替换字典中的ID等特殊键的名字 */
- (NSDictionary * __nonnull)replaceKeyName {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
    if ([dict.allKeys containsObject:@"ID"]) {
        [dict setObject:self[@"ID"] forKey:@"id"];
        [dict removeObjectForKey:@"ID"];
    }
    return dict;
}

@end
