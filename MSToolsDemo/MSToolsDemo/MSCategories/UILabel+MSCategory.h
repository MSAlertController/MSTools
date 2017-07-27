//
//  UILabel+MSCategory.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MSCategory)

/** 根据高度计算宽度 */
- (CGFloat)boundingWidthWithHeight:(CGFloat)height;

/** 根据宽度计算高度 */
- (CGFloat)boundingHeightWithWidth:(CGFloat)width;

@end
