//
//  NSObject+MSProperty.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "NSObject+MSProperty.h"
#import <objc/runtime.h>

@implementation NSObject (MSProperty)

/** 获取对象的所有属性 */
- (NSArray <NSString *> *)getAllProperties {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    return propertiesArray;
}

/** 获取对象的所有属性以及属性值 */
- (NSDictionary *)getAllPropertiesAndValues {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; i++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) [propertiesDictionary setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return propertiesDictionary;
}

/** 获取所有方法 */
- (NSArray <NSString *> *)getAllMethods {
    u_int count;
    Method *methods = class_copyMethodList([self class], &count);
    NSMutableArray *methodsArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        const char * methodName = sel_getName(method_getName(methods[i]));
        [methodsArray addObject:[NSString stringWithUTF8String:methodName]];
    }
    free(methods);
    return methodsArray;
}

@end
