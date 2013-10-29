//
//  BRImagePickerViewController.h
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCameraPickerDefines.h"
#import "BRAbstractPickerViewController.h"
#import "BRAbstarctPreviewViewController.h"
typedef void(^BRImagePickerViewControllerCaptureImage)(BRAbstarctPreviewViewController *,UIImage *,NSData *);
typedef void(^BRImagePickerViewControllerCanceled)();

@interface BRImagePickerViewController : UINavigationController <BRAbstractPickerViewControllerDelegate, BRAbstarctPreviewViewControllerDelegate>
@property BRImagePickerViewControllerType sourceType;
@property (copy) BRImagePickerViewControllerCaptureImage captureHandler;
@property (copy) BRImagePickerViewControllerCanceled canceledHandler;
@property BOOL allowsEditing; 

+ (BOOL)isSourceTypeAvailable:(BRImagePickerViewControllerType)type;

- (id)initWithSourceType:(BRImagePickerViewControllerType)sourceType;

- (void)presentImagePickerInViewController:(UIViewController*)controller;
- (void)dismissImagePicker;

@end
