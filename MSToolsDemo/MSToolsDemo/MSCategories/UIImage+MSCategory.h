//
//  UIImage+MSCategory.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, WaterMaskPosition) {
    WaterMaskPositionLeftUpper,
    WaterMaskPositionLeftLower,
    WaterMaskPositionRightUpper,
    WaterMaskPositionRightLower
};

@interface UIImage (MSCategory)

/**
 裁剪图片
 
 @param rect 裁剪后的图片相对于原图片的位置和大小
 
 @return 裁剪后的图片
 */
- (UIImage *)cutImageWithRect:(CGRect)rect;

/**
 将图片裁剪成正方形
 
 @return 裁剪后的图片
 */
- (UIImage *)cutSquareImage;

/**
 修改图片颜色
 
 @param color 颜色
 
 @return 修改颜色后的图片
 */
- (UIImage *)imageWithColor:(UIColor *)color;

/**
 加水印（例：如果position设置为右上角，则边距中的top和right生效，bottom和left无效）
 
 @param mask     水印图片
 @param position 水印的位置：左上、左下、右上、右下
 @param edge     水印距离边缘的距离
 
 @return 返回加了水印的图片
 */
- (UIImage *)imageWithWaterMask:(UIImage *)mask inPosition:(WaterMaskPosition)position inEdge:(UIEdgeInsets)edge;

@end
