//
//  UIButton+MSCategory.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MSCategory)

- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)titleColor;
- (void)setBackgroundImage:(UIImage *)image;
- (void)addTarget:(id)target action:(SEL)action;

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)image;
- (void)setBackgroundImageWithURL:(NSString *)url placeholderImage:(UIImage *)image;

@end
