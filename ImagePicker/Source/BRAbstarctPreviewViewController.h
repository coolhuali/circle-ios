//
//  BRAbstarctPreviewViewController.h
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRProgressIndicator.h"

@class BRAbstarctPreviewViewController;

@protocol BRAbstarctPreviewViewControllerDelegate <NSObject>

- (void)previewViewControllerCanceled:(BRAbstarctPreviewViewController*)previewController;
- (void)previewViewController:(BRAbstarctPreviewViewController*)previewController croppedImage:(UIImage*)image imageData:(NSData*)imageData;

@end

@interface BRAbstarctPreviewViewController : UIViewController
@property (weak) id<BRAbstarctPreviewViewControllerDelegate> delegate;
@property (strong) UIImage *previewImage;
@property (strong, nonatomic) BRProgressIndicator *progress;
@property BOOL cropped;

@end
