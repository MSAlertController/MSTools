//
//  NSObject+MSProperty.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MSProperty)

/** 获取对象的所有属性 */
- (NSArray <NSString *> *)getAllProperties;

/** 获取对象的所有属性以及属性值 */
- (NSDictionary *)getAllPropertiesAndValues;

/** 获取所有方法 */
- (NSArray <NSString *> *)getAllMethods;

@end
