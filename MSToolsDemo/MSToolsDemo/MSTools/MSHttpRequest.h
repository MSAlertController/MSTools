//
//  MSHttpRequest.h
//
//  Created by moses on 2017/7/18.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHttpRequest : NSObject

+ (void)GET:(NSString *)URLString succeed:(void (^)(id responseObject))succeed failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters succeed:(void (^)(id responseObject))succeed failure:(void (^)(NSError *error))failure;

@end
