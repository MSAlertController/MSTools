//
//  UIButton+MSCategory.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "UIButton+MSCategory.h"

@implementation UIButton (MSCategory)

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:(UIControlStateNormal)];
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:(UIControlStateNormal)];
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor forState:(UIControlStateNormal)];
}

- (void)setBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:(UIControlStateNormal)];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)image {
    [self sd_setImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateNormal) placeholderImage:image];
}

- (void)setBackgroundImageWithURL:(NSString *)url placeholderImage:(UIImage *)image {
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateNormal) placeholderImage:image];
}

@end
