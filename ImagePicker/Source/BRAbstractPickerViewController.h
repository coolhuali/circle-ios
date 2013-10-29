//
//  BRAbstractPickerViewController.h
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRAbstractPickerViewController;

@protocol BRAbstractPickerViewControllerDelegate <NSObject>
@required

- (void)pickerControllerCanceled:(BRAbstractPickerViewController*)pickerController;
- (void)pickerController:(BRAbstractPickerViewController*)pickerController captureImage:(UIImage*)image;

@end

@interface BRAbstractPickerViewController : UIViewController
@property (weak) id<BRAbstractPickerViewControllerDelegate> delegate;

+ (NSBundle*)imagePickerBundle;

- (void)dismiss;

@end
