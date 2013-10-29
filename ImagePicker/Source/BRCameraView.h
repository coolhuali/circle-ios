//
//  BRCameraView.h
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCameraPickerDefines.h"
#import <AVFoundation/AVFoundation.h>

@class BRCameraView;

@protocol BRCameraViewDelegate <NSObject>

- (void)cameraViewDidLock:(BRCameraView*)cameraCapture;
- (void)cameraViewDidUnLock:(BRCameraView*)cameraCapture;
- (void)cameraView:(BRCameraView*)cameraCapture startDevice:(BRCameraPickerViewControllerCameraDevice)device;
- (void)cameraView:(BRCameraView*)cameraCapture captureImage:(UIImage*)image;
- (void)cameraView:(BRCameraView*)cameraCapture setNewFlashMode:(AVCaptureFlashMode)flashMode;
- (void)cameraView:(BRCameraView*)cameraCapture updateZoomIndex:(CGFloat)zoomIndex;

- (void)cameraView:(BRCameraView*)cameraCapture failedWithError:(NSError*)error;

@end

@interface BRCameraView : UIView
@property id<BRCameraViewDelegate> delegate;
@property (nonatomic) CGFloat zoomIndex;
@property (nonatomic) BRCameraPickerViewControllerCameraDevice cameraDevice;

+ (BOOL)isCameraDeviceAvailable:(BRCameraPickerViewControllerCameraDevice)device;
+ (BOOL)isFlashAvailableForCameraDevice:(BRCameraPickerViewControllerCameraDevice)device;

- (void)startCamera;
- (void)stopCamera;

- (BOOL)hasFlash;
- (void)setNextFlashMode;
- (void)takeImage;

@end
