//
//  NSDictionary+MSCategory.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MSCategory)

/** 字典转JSON字符串 */
- (NSString * __nonnull)transformToJSONString;

/** 字典转NSData */
- (NSData * __nonnull)transformToData;

/** 替换字典中的ID等特殊键的名字 */
- (NSDictionary * __nonnull)replaceKeyName;

@end
