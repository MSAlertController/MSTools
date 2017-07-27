//
//  NSData+MSCategory.h
//
//  Created by moses on 2017/7/26.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MSCategory)

/** NSData转字典 */
- (NSDictionary * __nonnull)transformToDict;

/** NSData转JSON字符串 */
- (NSString * __nonnull)transformToJSONString;

@end
