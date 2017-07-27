//
//  UIImage+MSCategory.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "UIImage+MSCategory.h"

@implementation UIImage (MSCategory)

/**
 裁剪图片

 @param rect 裁剪后的图片相对于原图片的位置和大小

 @return 裁剪后的图片
 */
- (UIImage *)cutImageWithRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, imageRef);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 将图片裁剪成正方形

 @return 裁剪后的图片
 */
- (UIImage *)cutSquareImage {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    if (width == height) {
        return self;
    }
    return width > height ? [self cutImageWithRect:(CGRectMake(width / 2.0 - height / 2.0, 0, height, height))] : [self cutImageWithRect:(CGRectMake(0, height / 2.0 - width / 2.0, width, width))];
}

/**
 修改图片颜色
 
 @param color 颜色
 
 @return 修改颜色后的图片
 */
- (UIImage *)imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 加水印（例：如果position设置为右上角，则边距中的top和right生效，bottom和left无效）
 
 @param mask     水印图片
 @param position 水印的位置：左上、左下、右上、右下
 @param edge     水印距离边缘的距离
 
 @return 返回加了水印的图片
 */
- (UIImage *)imageWithWaterMask:(UIImage *)mask inPosition:(WaterMaskPosition)position inEdge:(UIEdgeInsets)edge {
    int width = self.size.width;
    int height = self.size.height;
    int logoWidth = mask.size.width;
    int logoHeight = mask.size.height;
    CGRect rect;
    if (position == WaterMaskPositionLeftUpper) {
        rect = CGRectMake(edge.left, edge.top, logoWidth, logoHeight);
    } else if (position == WaterMaskPositionRightUpper) {
        rect = CGRectMake(width - logoWidth - edge.right, edge.top, logoWidth, logoHeight);
    } else if (position == WaterMaskPositionLeftLower) {
        rect = CGRectMake(edge.left, height - logoHeight - edge.bottom, logoWidth, logoHeight);
    } else if (position == WaterMaskPositionRightLower) {
        rect = CGRectMake(width - logoWidth - edge.right, height - logoHeight - edge.bottom, logoWidth, logoHeight);
    }
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    [mask drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
