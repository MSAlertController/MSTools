//
//  UILabel+MSCategory.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "UILabel+MSCategory.h"

@implementation UILabel (MSCategory)

/** 根据高度计算宽度 */
- (CGFloat)boundingWidthWithHeight:(CGFloat)height {
    return [self.text boundingRectWithSize:(CGSizeMake(MAXFLOAT, height)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]} context:nil].size.width;
}

/** 根据宽度计算高度 */
- (CGFloat)boundingHeightWithWidth:(CGFloat)width {
    return [self.text boundingRectWithSize:(CGSizeMake(width, MAXFLOAT)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]} context:nil].size.height;
}

@end
