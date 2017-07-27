//
//  MSSingletonManager.m
//
//  Created by moses on 2017/7/21.
//  Copyright © 2017年 ANT. All rights reserved.
//

#import "MSSingletonManager.h"
#import <Photos/Photos.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

typedef NS_ENUM (NSInteger, MSPickerViewType) {
    MSPickerViewTypeSingle,
    MSPickerViewTypeAddress,
    MSPickerViewTypeDate
};

static id _instace;

@interface MSSingletonManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CNContactPickerDelegate, ABPeoplePickerNavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) NSInteger msStatusBarStyle;
@property (nonatomic, strong, nullable) UIButton *msBackButton;
@property (nonatomic, strong, nullable) UIView *msBackView;
@property (nonatomic, strong, nullable) UIPickerView *msPickerView;
@property (nonatomic, strong, nullable) MSSinglePickerModel *msSingleModel;
@property (nonatomic, strong, nullable) MSAddressPickerModel *msAddressModel;
@property (nonatomic, copy) MSImagePCBlock msImageBlock;
@property (nonatomic, copy) MSContactPCBlock msContactBlock;
@property (nonatomic, copy) MSPickerViewBlock msSingleBlock;
@property (nonatomic, copy) MSPickerViewBlock msAddressBlock;
@property (nonatomic, assign) MSPickerViewType msPickerType;
@property (nonatomic, strong, nullable) NSDictionary *msAddressDict;
@property (nonatomic, strong, nullable) NSArray *msProvinceArray;
@property (nonatomic, strong, nullable) NSArray *msCityArray;
@property (nonatomic, strong, nullable) NSArray *msCountyArray;
@property (nonatomic, copy) MSDatePickerBlock msDateBlock;
@property (nonatomic, strong, nullable) UIDatePicker *msDatePicker;
@property (nonatomic, strong, nullable) NSDateFormatter *msDateFormatter;

@end

@implementation MSSingletonManager

NSString * __nonnull const msAddressSeparator = @"--";

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instace;
}

/**
 弹出照片选择控制器
 
 @param type         相册/相机/相册和相机
 @param allowEditing 选中图片后是否允许编辑
 @param block        返回用户选择的图片
 */
- (void)presentImagePickerControllerWithSourceType:(MSImagePickerControllerSourceType)type allowEditing:(BOOL)allowEditing complete:(MSImagePCBlock)block {
    self.msImageBlock = block;
    if (type == MSImagePickerControllerSourceTypePicture) {
        if ([self photoJurisdiction]) [self selectPictureWithSourceType:(UIImagePickerControllerSourceTypePhotoLibrary) allowEditing:allowEditing];
    } else if (type == MSImagePickerControllerSourceTypeCamera) {
        if ([self cameraJurisdiction]) [self selectPictureWithSourceType:(UIImagePickerControllerSourceTypeCamera) allowEditing:allowEditing];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"打开相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if ([self cameraJurisdiction]) [self selectPictureWithSourceType:(UIImagePickerControllerSourceTypeCamera) allowEditing:allowEditing];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"打开相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if ([self photoJurisdiction]) [self selectPictureWithSourceType:(UIImagePickerControllerSourceTypePhotoLibrary) allowEditing:allowEditing];
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:action2];
        [alertController addAction:action1];
        [alertController addAction:cancle];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (BOOL)photoJurisdiction {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        [self gotoSettingWithTitle:@"请授权相册访问权限"];
    }
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}
- (BOOL)cameraJurisdiction {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        [self gotoSettingWithTitle:@"请授权相机使用权限"];
    }
    return status == AVAuthorizationStatusNotDetermined || status == AVAuthorizationStatusAuthorized;
}

- (void)gotoSettingWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:cancleAction];
    [alertController addAction:setAction];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)selectPictureWithSourceType:(UIImagePickerControllerSourceType)sourceType allowEditing:(BOOL)allowEditing {
    if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        UIImagePickerController *imagePickerNVC = [[UIImagePickerController alloc] init];
        imagePickerNVC.delegate = self;
        imagePickerNVC.allowsEditing = allowEditing;
        imagePickerNVC.navigationBar.barTintColor = mainColor;
        imagePickerNVC.navigationBar.tintColor = [UIColor blackColor];
        [imagePickerNVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        imagePickerNVC.sourceType = sourceType;
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:imagePickerNVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image;
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        self.msImageBlock(image, data);
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 弹出通讯录选择控制器
 
 @param block 返回通讯录名字和手机号
 */
- (void)presentContactPickerControllerComplete:(MSContactPCBlock)block {
    self.msStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    self.msContactBlock = block;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        CNContactPickerViewController *contactVC = [[CNContactPickerViewController alloc] init];
        contactVC.delegate = self;
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:contactVC animated:YES completion:nil];
    } else {
        ABPeoplePickerNavigationController *contactVC = [[ABPeoplePickerNavigationController alloc] init];
        contactVC.peoplePickerDelegate = self;
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:contactVC animated:YES completion:nil];
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef, identifier);
    CFStringRef nameValue = ABRecordCopyCompositeName(person);
    CFStringRef phoneValue = ABMultiValueCopyValueAtIndex(valuesRef, index);
    if (nameValue == nil || phoneValue == nil) {
        return;
    }
    NSString *phone = [[NSString stringWithFormat:@"%@", phoneValue] removeNoNumbers];
    NSString *name = [[NSString stringWithFormat:@"%@", nameValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.msContactBlock(name, phone);
    [[UIApplication sharedApplication] setStatusBarStyle:(self.msStatusBarStyle)];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    NSArray *phoneNums = contact.phoneNumbers;
    if (phoneNums.count == 0) {
        return;
    }
    NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
    NSMutableArray *phoneArray = [NSMutableArray array];
    for (int i = 0; i < phoneNums.count; i++) {
        CNLabeledValue *labeledValue = phoneNums[i];
        CNPhoneNumber *phoneNumber = labeledValue.value;
        NSString *phoneString = [phoneNumber.stringValue removeNoNumbers];
        [phoneArray addObject:phoneString];
        if ([phoneString validateCellPhone]) {
            self.msContactBlock(name, phoneString);
            [[UIApplication sharedApplication] setStatusBarStyle:(self.msStatusBarStyle)];
            return;
        }
    }
    self.msContactBlock(name, phoneArray[0]);
    [[UIApplication sharedApplication] setStatusBarStyle:(self.msStatusBarStyle)];
}

- (void)presentSinglePickerViewWithArray:(NSArray * __nonnull)array complete:(MSPickerViewBlock)block {
    MSSinglePickerModel *model = [MSSinglePickerModel new];
    model.msDataArray = array;
    NSArray *arr = @[@[@0, @0], @[@59, @155], @[@57, @165], @[@55, @175], @[@53, @185], @[@51, @195]];
    NSArray *a = arr[array.count > 5 ? 5 : array.count];
    model.msRowHeight = [a[0] floatValue];
    model.msViewHeight = [a[1] floatValue];
    [self presentSinglePickerViewWithModel:model complete:block];
}
/**
 弹出单列选择控制器
 
 @param msModel 控制器内容数组等
 @param block   返回选中的字符串
 */
- (void)presentSinglePickerViewWithModel:(MSSinglePickerModel * __nonnull)msModel complete:(MSPickerViewBlock)block {
    if (!msModel.msDataArray || msModel.msDataArray.count == 0) {
        DLog(@"数组不存在或者数组个数为0");
        return;
    }
    self.msPickerType = MSPickerViewTypeSingle;
    self.msSingleBlock = block;
    self.msSingleModel = msModel;
    if (!self.msSingleModel.msBackColor) {
        self.msSingleModel.msBackColor = [UIColor colorWithWhite:0.300 alpha:0.200];
    }
    if (!self.msSingleModel.msBackViewColor) {
        self.msSingleModel.msBackViewColor = [UIColor whiteColor];
    }
    if (!self.msSingleModel.msPickerViewBackColor) {
        self.msSingleModel.msPickerViewBackColor = [UIColor colorWithWhite:0.970 alpha:1.000];
    }
    if (!self.msSingleModel.msCenterLabelBackColor) {
        self.msSingleModel.msCenterLabelBackColor = [UIColor colorWithWhite:0.970 alpha:1.000];
    }
    if (!self.msSingleModel.msRowHeight || self.msSingleModel.msRowHeight < 50 || self.msSingleModel.msRowHeight > 70) {
        self.msSingleModel.msRowHeight = 60;
    }
    CGFloat index = self.msSingleModel.msViewHeight / self.msSingleModel.msRowHeight;
    if (!self.msSingleModel.msViewHeight || index < 3.0 || index > 5.0) {
        self.msSingleModel.msViewHeight = self.msSingleModel.msRowHeight * 3.0;
    }
    if (self.msSingleModel.msBackColor.value.alpha > 0.5) {
        self.msSingleModel.msBackColor = [self.msSingleModel.msBackColor setColorAlpha:0.3];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.msBackButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.msBackButton.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.000];
    self.msBackButton.frame = window.bounds;
    [window addSubview:self.msBackButton];
    [self.msBackButton addTarget:self action:@selector(backButtonAction:)forControlEvents:(UIControlEventTouchUpInside)];
    
    self.msBackView = [[UIView alloc] init];
    self.msBackView.frame = CGRectMake(0, kHeight, kWidth, self.msSingleModel.msViewHeight + 45);
    self.msBackView.backgroundColor = self.msSingleModel.msBackViewColor;
    [self.msBackButton addSubview:self.msBackView];
    
    UIButton *enterButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    enterButton.frame = CGRectMake(kWidth - 80, 0, 80, 45);
    if (self.msSingleModel.msEnterButtonTitleColor) {
        [enterButton setTitleColor:self.msSingleModel.msEnterButtonTitleColor forState:(UIControlStateNormal)];
    }
    [enterButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.msBackView addSubview:enterButton];
    [enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.msPickerView = [[UIPickerView alloc] init];
    self.msPickerView.frame = CGRectMake(0, 45, kWidth, self.msSingleModel.msViewHeight);
    self.msPickerView.backgroundColor = self.msSingleModel.msPickerViewBackColor;
    self.msPickerView.delegate = self;
    self.msPickerView.dataSource = self;
    [self.msBackView addSubview:self.msPickerView];
    
    [self.msPickerView.subviews[1] setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.198]];
    [self.msPickerView.subviews[2] setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.198]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.msBackButton.backgroundColor = self.msSingleModel.msBackColor;
        self.msBackView.frame = CGRectMake(0, kHeight - self.msBackView.frame.size.height, kWidth, self.msBackView.frame.size.height);
    } completion:^(BOOL finished) {
        if (self.msSingleModel.msDefaultStr && [self.msSingleModel.msDataArray containsObject:self.msSingleModel.msDefaultStr]) {
            [self.msPickerView selectRow:[self.msSingleModel.msDataArray indexOfObject:self.msSingleModel.msDefaultStr] inComponent:0 animated:YES];
        } else {
            block(self.msSingleModel.msDataArray[0], NO);
        }
    }];
}

- (void)backButtonAction:(UIButton *)button {
    if (self.msPickerType == MSPickerViewTypeSingle) {
        if (self.msSingleModel.msDefaultStr) {
            self.msSingleBlock(self.msSingleModel.msDefaultStr, NO);
        }
    } else if (self.msPickerType == MSPickerViewTypeAddress) {
        NSInteger level = self.msAddressModel.msLevel;
        NSString *province = self.msAddressModel.msDefaultProvince;
        NSString *city = self.msAddressModel.msDefaultCity;
        NSString *county = self.msAddressModel.msDefaultCounty;
        if (province && province.length) {
            NSMutableString *str = [NSMutableString stringWithString:self.msAddressModel.msDefaultProvince];
            if (level > 1 && city && city.length) {
                [str appendFormat:@"%@%@", msAddressSeparator, self.msAddressModel.msDefaultCity];
                if (level > 2 && county && county.length) {
                    [str appendFormat:@"%@%@", msAddressSeparator, self.msAddressModel.msDefaultCounty];
                }
            }
            self.msAddressBlock(str, NO);
        } else if (self.msAddressModel.msDefaultStr) {
            self.msAddressBlock(self.msAddressModel.msDefaultStr, NO);
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.msBackButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.msBackView.frame = CGRectMake(0, kHeight, kWidth, self.msBackView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.msBackButton removeFromSuperview];
    }];
}
- (void)enterButtonAction:(UIButton *)button {
    if (self.msPickerType == MSPickerViewTypeSingle) {
        self.msSingleBlock(self.msSingleModel.msDataArray[[self.msPickerView selectedRowInComponent:0]], YES);
    } else if (self.msPickerType == MSPickerViewTypeAddress) {
        if (self.msAddressModel.msLevel == 1) {
            NSString *province = [self getAddress:self.msProvinceArray[[self.msPickerView selectedRowInComponent:0]]];
            self.msAddressBlock(province, YES);
        } else if (self.msAddressModel.msLevel == 2) {
            NSString *province = [self getAddress:self.msProvinceArray[[self.msPickerView selectedRowInComponent:0]]];
            NSString *city = [self getAddress:self.msCityArray[[self.msPickerView selectedRowInComponent:1]]];
            self.msAddressBlock([NSString stringWithFormat:@"%@%@%@", province, msAddressSeparator, city], YES);
        } else {
            NSString *province = [self getAddress:self.msProvinceArray[[self.msPickerView selectedRowInComponent:0]]];
            NSString *city = [self getAddress:self.msCityArray[[self.msPickerView selectedRowInComponent:1]]];
            NSString *county = [self getAddress:self.msCountyArray[[self.msPickerView selectedRowInComponent:2]]];
            self.msAddressBlock([NSString stringWithFormat:@"%@%@%@%@%@", province, msAddressSeparator, city, msAddressSeparator, county], YES);
        }
    } else if (self.msPickerType == MSPickerViewTypeDate) {
        NSString *dateStr = [self.msDateFormatter stringFromDate:self.msDatePicker.date];
        NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[self.msDatePicker.date timeIntervalSince1970]];
        self.msDateBlock(dateStr, timestamp, self.msDatePicker.date);
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.msBackButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.msBackView.frame = CGRectMake(0, kHeight, kWidth, self.msBackView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.msBackButton removeFromSuperview];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.msPickerType == MSPickerViewTypeAddress) {
        return self.msAddressModel.msLevel;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.msPickerType == MSPickerViewTypeSingle) {
        return self.msSingleModel.msDataArray.count;
    } else if (self.msPickerType == MSPickerViewTypeAddress) {
        if (component == 0) {
            return self.msProvinceArray.count;
        } else if (component == 1) {
            return self.msCityArray.count;
        } else if (component == 2) {
            return self.msCountyArray.count;
        }
    }
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.msPickerType == MSPickerViewTypeSingle) {
        return self.msSingleModel.msRowHeight;
    }
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (self.msPickerType == MSPickerViewTypeSingle) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, kWidth, self.msSingleModel.msRowHeight + 4);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = self.msSingleModel.msCenterLabelBackColor;
        label.text = self.msSingleModel.msDataArray[row];
        if (self.msSingleModel.msCenterLabelTextColor) label.textColor = self.msSingleModel.msCenterLabelTextColor;
        return label;
    } else if (self.msPickerType == MSPickerViewTypeAddress) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, kWidth / self.msAddressModel.msLevel, 44);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithWhite:0.970 alpha:1.000];
        if (component == 0) {
            label.text = [self getAddress:self.msProvinceArray[row]];
        } else if (component == 1) {
            label.text = [self getAddress:self.msCityArray[row]];
        } else if (component == 2) {
            label.text = [self getAddress:self.msCountyArray[row]];
        }
        return label;
    }
    return [UIView new];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.msPickerType == MSPickerViewTypeSingle) {
        self.msSingleBlock(self.msSingleModel.msDataArray[row], NO);
    } else if (self.msPickerType == MSPickerViewTypeAddress) {
        if (self.msAddressModel.msLevel == 1) {
            self.msAddressBlock([self getAddress:self.msProvinceArray[row]], NO);
        } else if (self.msAddressModel.msLevel == 2) {
            if (component == 0) {
                NSString *key = self.msProvinceArray[row];
                NSDictionary *cityDict = self.msAddressDict[key];
                self.msCityArray = [self sortWithPrefix:cityDict.allKeys];
                [pickerView reloadComponent:1];
            }
            NSString *province = [self getAddress:self.msProvinceArray[[pickerView selectedRowInComponent:0]]];
            NSString *city = [self getAddress:self.msCityArray[[pickerView selectedRowInComponent:1]]];
            self.msAddressBlock([NSString stringWithFormat:@"%@%@%@", province, msAddressSeparator, city], NO);
        } else if (self.msAddressModel.msLevel == 3) {
            if (component == 0) {
                NSString *key = self.msProvinceArray[row];
                NSDictionary *cityDict = self.msAddressDict[key];
                self.msCityArray = [self sortWithPrefix:cityDict.allKeys];
                [pickerView reloadComponent:1];
                NSString *cityKey = self.msCityArray[[pickerView selectedRowInComponent:1]];
                self.msCountyArray = cityDict[cityKey];
                [pickerView reloadComponent:2];
            } else if (component == 1) {
                NSString *provinceKey = self.msProvinceArray[[pickerView selectedRowInComponent:0]];
                NSDictionary *provinceDict = self.msAddressDict[provinceKey];
                NSString *key = self.msCityArray[row];
                self.msCountyArray = provinceDict[key];
                [pickerView reloadComponent:2];
                
            }
            NSString *province = [self getAddress:self.msProvinceArray[[pickerView selectedRowInComponent:0]]];
            NSString *city = [self getAddress:self.msCityArray[[pickerView selectedRowInComponent:1]]];
            NSString *county = [self getAddress:self.msCountyArray[[pickerView selectedRowInComponent:2]]];
            self.msAddressBlock([NSString stringWithFormat:@"%@%@%@%@%@", province, msAddressSeparator, city, msAddressSeparator, county], NO);
        }
    }
}

- (void)presentAddressPickerViewWithDefaultString:(NSString * __nonnull)string complete:(MSPickerViewBlock)block {
    [self presentAddressPickerViewWithDefaultString:string level:3 complete:block];
}
- (void)presentAddressPickerViewWithDefaultString:(NSString * __nonnull)string level:(NSInteger)level complete:(MSPickerViewBlock)block {
    MSAddressPickerModel *model = [MSAddressPickerModel new];
    model.msDefaultStr = string;
    model.msLevel = level;
    [self presentAddressPickerViewWithModel:model complete:block];
}

/**
 弹出地址选择控制器
 
 @param model 控制器内容等
 @param block 返回选中的字符串
 */
- (void)presentAddressPickerViewWithModel:(MSAddressPickerModel * __nullable)model complete:(MSPickerViewBlock)block {
    self.msPickerType = MSPickerViewTypeAddress;
    self.msAddressBlock = block;
    if (model) {
        self.msAddressModel = model;
        NSInteger level = self.msAddressModel.msLevel;
        if (!level || level < 1 || level > 3) {
            self.msAddressModel.msLevel = 3;
        }
        if (self.msAddressModel.msDefaultStr && [self.msAddressModel.msDefaultStr containsString:msAddressSeparator]) {
            NSArray *arr = [self.msAddressModel.msDefaultStr componentsSeparatedByString:msAddressSeparator];
            if (arr.count == 3) {
                if ([arr[0] length] > 0) self.msAddressModel.msDefaultProvince = arr[0];
                if ([arr[1] length] > 0) self.msAddressModel.msDefaultCity = arr[1];
                if ([arr[2] length] > 0) self.msAddressModel.msDefaultCounty = arr[2];
            } else {
                if ([arr[0] length] > 0) self.msAddressModel.msDefaultProvince = arr[0];
                if ([arr[1] length] > 0) self.msAddressModel.msDefaultCity = arr[1];
            }
        }
    } else {
        self.msAddressModel = [MSAddressPickerModel new];
        self.msAddressModel.msLevel = 3;
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.msBackButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.msBackButton.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.000];
    self.msBackButton.frame = window.bounds;
    [window addSubview:self.msBackButton];
    [self.msBackButton addTarget:self action:@selector(backButtonAction:)forControlEvents:(UIControlEventTouchUpInside)];
    
    self.msBackView = [[UIView alloc] init];
    self.msBackView.frame = CGRectMake(0, kHeight, kWidth, 245);
    self.msBackView.backgroundColor = [UIColor whiteColor];
    [self.msBackButton addSubview:self.msBackView];
    
    UIButton *enterButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    enterButton.frame = CGRectMake(kWidth - 80, 0, 80, 45);
    if (self.msAddressModel.msEnterButtonTitleColor) {
        [enterButton setTitleColor:self.msAddressModel.msEnterButtonTitleColor forState:(UIControlStateNormal)];
    }
    [enterButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.msBackView addSubview:enterButton];
    [enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.msPickerView = [[UIPickerView alloc] init];
    self.msPickerView.frame = CGRectMake(0, 45, kWidth, 200);
    self.msPickerView.backgroundColor = [UIColor colorWithWhite:0.970 alpha:1.000];
    self.msPickerView.delegate = self;
    self.msPickerView.dataSource = self;
    [self.msBackView addSubview:self.msPickerView];
    
    [self.msPickerView.subviews[1] setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.198]];
    [self.msPickerView.subviews[2] setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.198]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.msBackButton.backgroundColor = [UIColor colorWithWhite:0.300 alpha:0.200];
        self.msBackView.frame = CGRectMake(0, kHeight - self.msBackView.frame.size.height, kWidth, self.msBackView.frame.size.height);
    } completion:^(BOOL finished) {
        [self initData];
    }];
}

- (void)initData {
    NSInteger level = self.msAddressModel.msLevel;
    NSString *province = self.msAddressModel.msDefaultProvince;
    NSString *city = self.msAddressModel.msDefaultCity;
    NSString *county = self.msAddressModel.msDefaultCounty;
    if (province && province.length) {
        NSInteger provinceIndex = 0;
        for (NSString *str in self.msProvinceArray) {
            if ([str containsString:province]) {
                provinceIndex = [self.msProvinceArray indexOfObject:str];
                break;
            }
        }
        [self.msPickerView selectRow:provinceIndex inComponent:0 animated:YES];
        if (level > 1) {
            self.msCityArray = [self sortWithPrefix:[self.msAddressDict[self.msProvinceArray[provinceIndex]] allKeys]];
            NSInteger cityIndex = 0;
            if (city && city.length) {
                for (NSString *str in self.msCityArray) {
                    if ([str containsString:city]) {
                        cityIndex = [self.msCityArray indexOfObject:str];
                        break;
                    }
                }
            }
            [self.msPickerView selectRow:cityIndex inComponent:1 animated:YES];
            if (level > 2) {
                self.msCountyArray = self.msAddressDict[self.msProvinceArray[provinceIndex]][self.msCityArray[cityIndex]];
                NSInteger countyIndex = 0;
                if (county && county.length) {
                    for (NSString *str in self.msCountyArray) {
                        if ([str containsString:county]) {
                            countyIndex = [self.msCountyArray indexOfObject:str];
                            break;
                        }
                    }
                }
                [self.msPickerView selectRow:countyIndex inComponent:2 animated:YES];
            }
        }
    } else {
        if (self.msAddressModel.msLevel > 1) {
            self.msCityArray = [self sortWithPrefix:[self.msAddressDict[self.msProvinceArray[0]] allKeys]];
            if (self.msAddressModel.msLevel > 2) {
                self.msCountyArray = self.msAddressDict[self.msProvinceArray[0]][self.msCityArray[0]];
            }
        }
        NSString *province = [self getAddress:self.msProvinceArray[0]];
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@", province];
        if (level > 1) {
            [str appendFormat:@"%@%@", msAddressSeparator, [self getAddress:self.msCityArray[0]]];
            if (level > 2) {
                [str appendFormat:@"%@%@", msAddressSeparator, [self getAddress:self.msCountyArray[0]]];
            }
        }
        [self.msPickerView reloadAllComponents];
        self.msAddressBlock(str, NO);
    }
}

// 数组排序，只有省和市需要排序，区县本来就是数组，不需要排序
- (NSArray *)sortWithPrefix:(NSArray *)array {
    return [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = [obj1 componentsSeparatedByString:@"|"][0];
        NSString *str2 = [obj2 componentsSeparatedByString:@"|"][0];
        if (str1.integerValue > str2.integerValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
}
// 显示的时候要去掉前面的行政代码
- (NSString *)getAddress:(NSString *)str {
    if ([str containsString:@"|"]) {
        return [str componentsSeparatedByString:@"|"][1];
    }
    return str;
}

- (NSDictionary *)msAddressDict {
    if (!_msAddressDict) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
        _msAddressDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return _msAddressDict;
}

- (NSArray *)msProvinceArray {
    if (!_msProvinceArray) {
        _msProvinceArray = [self sortWithPrefix:self.msAddressDict.allKeys];
    }
    return _msProvinceArray;
}

- (NSDateFormatter *)msDateFormatter {
    if (!_msDateFormatter) {
        _msDateFormatter = [[NSDateFormatter alloc] init];
    }
    return _msDateFormatter;
}

/**
 弹出时间选择控制器
 
 @param format  时间格式，默认：YYYY-MM-dd
 @param dateStr 原始时间
 @param dpModel 选择器模式
 @param block   返回选中的时间
 */
- (void)presentDatePickerViewWithFormat:(NSString * __nullable)format defaultDate:(NSString * __nullable)dateStr dpModel:(UIDatePickerMode)dpModel complete:(MSDatePickerBlock)block {
    self.msPickerType = MSPickerViewTypeDate;
    if (format) {
        [self.msDateFormatter setDateFormat:format];
    } else {
        [self.msDateFormatter setDateFormat:@"YYYY-MM-dd"];
    }
    self.msDateBlock = block;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.msBackButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.msBackButton.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.000];
    self.msBackButton.frame = window.bounds;
    [window addSubview:self.msBackButton];
    [self.msBackButton addTarget:self action:@selector(backButtonAction:)forControlEvents:(UIControlEventTouchUpInside)];
    
    self.msBackView = [[UIView alloc] init];
    self.msBackView.frame = CGRectMake(0, kHeight, kWidth, 245);
    self.msBackView.backgroundColor = [UIColor whiteColor];
    [self.msBackButton addSubview:self.msBackView];
    
    UIButton *enterButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    enterButton.frame = CGRectMake(kWidth - 80, 0, 80, 45);
    [enterButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.msBackView addSubview:enterButton];
    [enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 45, kWidth, 0.4);
    label.backgroundColor = [UIColor lightGrayColor];
    [self.msBackView addSubview:label];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, 50, kWidth, 200);
    long timestamp = [[NSDate date] timeIntervalSince1970];
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:(timestamp - 3600 * 24 * 365 * 100)];
    datePicker.maximumDate = [NSDate date];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = dpModel;
    [self.msBackView addSubview:datePicker];
    self.msDatePicker = datePicker;
    if (dateStr) datePicker.date = [self.msDateFormatter dateFromString:dateStr];
    [UIView animateWithDuration:0.25 animations:^{
        self.msBackButton.backgroundColor = [UIColor colorWithWhite:0.300 alpha:0.200];
        self.msBackView.frame = CGRectMake(0, kHeight - 245, kWidth, 245);
    }];
}

@end

@implementation MSSinglePickerModel

@end

@implementation MSAddressPickerModel

@end
