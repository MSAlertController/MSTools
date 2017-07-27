//
//  MSSingletonManager.h
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSSinglePickerModel, MSAddressPickerModel;
typedef NS_ENUM (NSInteger, MSImagePickerControllerSourceType) {
    MSImagePickerControllerSourceTypeCamera,
    MSImagePickerControllerSourceTypePicture,
    MSImagePickerControllerSourceTypePictureAndCamera
};

typedef void(^ __nonnull MSImagePCBlock)(UIImage * __nonnull image, NSData * __nonnull data);
typedef void(^ __nonnull MSContactPCBlock)(NSString * __nonnull name, NSString * __nonnull phone);
typedef void(^ __nonnull MSPickerViewBlock)(NSString * __nonnull selectedStr, BOOL enter);
typedef void(^ __nonnull MSDatePickerBlock)(NSString * __nonnull selectedStr, NSString * __nonnull timestamp, NSDate * __nonnull selectedDate);

@interface MSSingletonManager : NSObject

extern NSString * __nonnull const msAddressSeparator;

+ (instancetype __nonnull)defaultManager;

/**
 弹出照片选择控制器
 
 @param type         相册/相机/相册和相机
 @param allowEditing 选中图片后是否允许编辑
 @param block        返回用户选择的图片
 */
- (void)presentImagePickerControllerWithSourceType:(MSImagePickerControllerSourceType)type allowEditing:(BOOL)allowEditing complete:(MSImagePCBlock)block;

/**
 弹出通讯录选择控制器

 @param block 返回通讯录名字和手机号
 */
- (void)presentContactPickerControllerComplete:(MSContactPCBlock)block;

/**
 弹出单列选择控制器

 @param msModel 控制器内容数组等
 @param block   返回选中的字符串
 */
- (void)presentSinglePickerViewWithModel:(MSSinglePickerModel * __nonnull)msModel complete:(MSPickerViewBlock)block;
/** 弹出单列选择控制器（只需要传数组） */
- (void)presentSinglePickerViewWithArray:(NSArray * __nonnull)array complete:(MSPickerViewBlock)block;

/**
 弹出地址选择控制器

 @param model 控制器内容等
 @param block 返回选中的字符串
 */
- (void)presentAddressPickerViewWithModel:(MSAddressPickerModel * __nullable)model complete:(MSPickerViewBlock)block;
/** 弹出地址选择控制器（只需要传原地址） */
- (void)presentAddressPickerViewWithDefaultString:(NSString * __nonnull)string complete:(MSPickerViewBlock)block;
/** 弹出地址选择控制器（只需要传原地址和列数，列数：1、2、3） */
- (void)presentAddressPickerViewWithDefaultString:(NSString * __nonnull)string level:(NSInteger)level complete:(MSPickerViewBlock)block;

/**
 弹出时间选择控制器

 @param format  时间格式，默认：YYYY-MM-dd
 @param dateStr 原始时间
 @param dpModel 选择器模式
 @param block   返回选中的时间
 */
- (void)presentDatePickerViewWithFormat:(NSString * __nullable)format defaultDate:(NSString * __nullable)dateStr dpModel:(UIDatePickerMode)dpModel complete:(MSDatePickerBlock)block;

@end

@interface MSSinglePickerModel : NSObject

@property (nonatomic, strong, nonnull) NSArray *msDataArray;
@property (nonatomic, copy, nullable) NSString *msDefaultStr;
@property (nonatomic, strong, nullable) UIColor *msBackColor;
@property (nonatomic, strong, nullable) UIColor *msBackViewColor;
@property (nonatomic, strong, nullable) UIColor *msPickerViewBackColor;
@property (nonatomic, strong, nullable) UIColor *msEnterButtonTitleColor;
@property (nonatomic, strong, nullable) UIColor *msCenterLabelBackColor;
@property (nonatomic, strong, nullable) UIColor *msCenterLabelTextColor;
@property (nonatomic, assign) CGFloat msRowHeight;
@property (nonatomic, assign) CGFloat msViewHeight;

@end

@interface MSAddressPickerModel : NSObject

@property (nonatomic, assign) NSInteger msLevel;
@property (nonatomic, copy, nullable) NSString *msDefaultStr;
@property (nonatomic, copy, nullable) NSString *msDefaultProvince;
@property (nonatomic, copy, nullable) NSString *msDefaultCity;
@property (nonatomic, copy, nullable) NSString *msDefaultCounty;
@property (nonatomic, strong, nullable) UIColor *msEnterButtonTitleColor;

@end
