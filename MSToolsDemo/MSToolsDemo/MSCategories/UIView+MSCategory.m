//
//  UIView+MSCategory.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "UIView+MSCategory.h"

@implementation UIView (MSCategory)

static char selfBlock;

- (void)toast:(id)content {
    [self makeToast:[NSString stringWithFormat:@"%@", content] duration:1 position:CSToastPositionCenter];
}

+ (instancetype)viewWithFrame:(CGRect)frame text:(NSString *)text click:(void((^)(id view)))block {
    return [[self alloc] viewWithFrame:frame text:text click:block];
}

- (instancetype)viewWithFrame:(CGRect)frame text:(NSString *)text click:(void((^)(id view)))block {
    UIView *view = [self initWithFrame:frame];
    view.backgroundColor = [[UIColor colorWithRed:(arc4random_uniform(100) + 155) green:(arc4random_uniform(80) + 150) blue:(arc4random_uniform(100) + 100)] setColorAlpha:0.7];
    objc_setAssociatedObject(self, &selfBlock, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        label.text = text;
        label.numberOfLines = 0;
    } else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        [button setTitle:text];
        [button setTitleColor:[UIColor blackColor]];
        [button addTarget:self action:@selector(targetAction:)];
    } else if ([view isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)view;
        textField.placeholder = text;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    } else if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view;
        imageView.image = [UIImage imageNamed:text];
    }
    if (![view isKindOfClass:[UIButton class]] && ![view isKindOfClass:[UITextField class]]) {
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetAction:)]];
    }
    return view;
}

- (void)targetAction:(id)obj {
    void((^block)(id view)) = objc_getAssociatedObject(self, &selfBlock);
    if ([obj isKindOfClass:[UIButton class]]) {
        if (block) block(obj);
    } else {
        UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)obj;
        if (block) block(gesture.view);
    }
}

+ (UIVisualEffectView *)visualViewWithFrame:(CGRect)frame effect:(UIBlurEffectStyle)effect {
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithFrame:frame];
    view.effect = [UIBlurEffect effectWithStyle:effect];
    view.userInteractionEnabled = YES;
    return view;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y {
    return self.frame.origin.x;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)x_width {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)y_height {
    return CGRectGetMaxY(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY {
    return self.center.y;
}

- (CGPoint)boundsCenter {
    return CGPointMake(self.width / 2.0, self.height / 2.0);
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.size.height -= top - self.y;
    frame.origin.y = top;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.size.height -= bottom - self.bottom;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.superview.y - self.y_height;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.size.width -= left - self.x;
    frame.origin.x = left;
    self.frame = frame;
}
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.size.width -= right - self.right;
    self.frame = frame;
}
- (CGFloat)right {
    return self.superview.x - self.x_width;
}

@end
