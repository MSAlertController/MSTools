//
//  UIView+MSCategory.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MSCategory)

/** 新建随机背景色视图（测试用）
          view,label,imageview,button,textfield均可使用
 text分别对应(),text,imageName,buttonTitle,placeholder
 */
+ (instancetype)viewWithFrame:(CGRect)frame text:(NSString *)text click:(void((^)(id view)))block;

+ (UIVisualEffectView *)visualViewWithFrame:(CGRect)frame effect:(UIBlurEffectStyle)effect;
/** 防止toast非string类型崩溃 */
- (void)toast:(id)content;

/** 位置 */
@property (nonatomic, assign, readwrite) CGPoint origin;
/** 大小 */
@property (nonatomic, assign, readwrite) CGSize size;
/** x */
@property (nonatomic, assign, readwrite) CGFloat x;
/** y */
@property (nonatomic, assign, readwrite) CGFloat y;
/** 宽 */
@property (nonatomic, assign, readwrite) CGFloat width;
/** 高 */
@property (nonatomic, assign, readwrite) CGFloat height;
/** x+宽 */
@property (nonatomic, assign, readonly) CGFloat x_width;
/** y+高 */
@property (nonatomic, assign, readonly) CGFloat y_height;
/** 父视图中心点的x */
@property (nonatomic, assign, readwrite) CGFloat centerX;
/** 父视图中心点的y */
@property (nonatomic, assign, readwrite) CGFloat centerY;
/** 自身中心点 */
@property (nonatomic, assign, readonly) CGPoint boundsCenter;
/** set:bottom不变，变化y和height    get:y */
@property (nonatomic, assign, readwrite) CGFloat top;
/** set:y不变，变化height    get:父视图height-y-height */
@property (nonatomic, assign, readwrite) CGFloat bottom;
/** set:right不变，变化x和width    get:x */
@property (nonatomic, assign, readwrite) CGFloat left;
/** set:x不变，变化width    get:父视图width-x-width */
@property (nonatomic, assign, readwrite) CGFloat right;

@end
