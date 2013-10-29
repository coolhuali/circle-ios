//
//  BRCameraView.m
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRCameraView.h"
#import <QuartzCore/QuartzCore.h>

@interface BRCameraView ()
@property (strong) AVCaptureSession *activeDeviceSession;
@property (weak) AVCaptureDevice *activeDevice;
@property (weak) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong) AVCaptureStillImageOutput *stillImageOutput;


@end

@implementation BRCameraView

+ (BOOL)isCameraDeviceAvailable:(BRCameraPickerViewControllerCameraDevice)device
{
    UIImagePickerControllerCameraDevice cameraDevice = (device == BRCameraPickerViewControllerCameraDeviceFront) ?
    UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
    return [UIImagePickerController isCameraDeviceAvailable:cameraDevice];
}

+ (BOOL)isFlashAvailableForCameraDevice:(BRCameraPickerViewControllerCameraDevice)device
{
    UIImagePickerControllerCameraDevice cameraDevice = (device == BRCameraPickerViewControllerCameraDeviceFront) ?
    UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
    return [UIImagePickerController isFlashAvailableForCameraDevice:cameraDevice];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepearCameraView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self prepearCameraView];
}

- (void)prepearCameraView
{
    _zoomIndex = 1;
}

- (void)startCamera
{
    self.cameraDevice = self.cameraDevice;
}

- (void)stopCamera
{
    [self.activeDeviceSession stopRunning];
}

- (void)setCameraDevice:(BRCameraPickerViewControllerCameraDevice)cameraDevice
{
    _cameraDevice = cameraDevice;
    [self startCameraDevice:_cameraDevice];
}

- (BOOL)startCameraDevice:(BRCameraPickerViewControllerCameraDevice)cameraDevice
{
    if (self.activeDeviceSession) {
        [self.activeDeviceSession stopRunning];
        self.activeDeviceSession = nil;
    }
    
    NSError *error = nil;
    
    self.activeDeviceSession = [AVCaptureSession new];
	[self.activeDeviceSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *videoDevice = nil;
    AVCaptureDevicePosition position = cameraDevice == BRCameraPickerViewControllerCameraDeviceFront ?
    AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == position) {
            videoDevice = device;
            break;
        }
    }
    if (!videoDevice) {
        return NO;
    }
    [self lockCameraView];
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
	if (error)
		return NO;
	if ([self.activeDeviceSession canAddInput:input]){
        [self.activeDeviceSession addInput:input];
    }
    self.activeDevice = videoDevice;
    
	// Make a still image output
	self.stillImageOutput = [AVCaptureStillImageOutput new];
    [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey: AVVideoCodecJPEG}];
    
	if ([self.activeDeviceSession canAddOutput:self.stillImageOutput]){
		[self.activeDeviceSession addOutput:self.stillImageOutput];
    }
    
	AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.activeDeviceSession];
	[previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	[previewLayer setFrame:[self bounds]];
    
    CALayer *rootLayer = [self layer];
	[rootLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
	[rootLayer addSublayer:previewLayer];
    self.previewLayer = previewLayer;
    
    [self.activeDeviceSession startRunning];
    [self unlockCameraView];
    if (self.delegate &&
            [self.delegate respondsToSelector:@selector(cameraView:startDevice:)]) {
        [self.delegate cameraView:self
                      startDevice:self.cameraDevice];
    }
    if (self.delegate &&
            [self.delegate respondsToSelector:@selector(cameraView:setNewFlashMode:)]) {
        [self.delegate cameraView:self
                  setNewFlashMode:self.activeDevice.flashMode];
    }
	return YES;
}

- (void)takeImage
{
    [self lockCameraView];
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    void (^handler)(CMSampleBufferRef imageDataSampleBuffer, NSError *error) =
                                                    ^(CMSampleBufferRef imageDataSampleBuffer, NSError *__strong error){
        [self captureStillImageBuffer:imageDataSampleBuffer
                                error:error];
        [self unlockCameraView];
    };
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                       completionHandler:handler];
}

- (void)captureStillImageBuffer:(CMSampleBufferRef) imageDataSampleBuffer error:(NSError *)error
{
    if (error == nil) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *picture = [[UIImage alloc] initWithData:imageData];
        
        if (picture != nil) {
            switch ([[UIDevice currentDevice] orientation]) {
                case UIDeviceOrientationLandscapeLeft:
                    picture = [UIImage imageWithCGImage:picture.CGImage
                                                  scale:1
                                            orientation:UIImageOrientationUp];
                    //picture = [picture rotateImage:UIImageOrientationUp];
                    break;
                case UIDeviceOrientationLandscapeRight:
                    picture = [UIImage imageWithCGImage:picture.CGImage
                                                  scale:1
                                            orientation:UIImageOrientationDown];
                    //picture = [picture rotateImage:UIImageOrientationDown];
                    break;
                case UIDeviceOrientationPortrait:
                    picture = [UIImage imageWithCGImage:picture.CGImage
                                                  scale:1
                                            orientation:UIImageOrientationRight];
                    //picture = [picture rotateImage:UIImageOrientationRight];
                default:
                    break;
            }
            //TODO zoom image!
            /*
            if (self.zoomIndex > 1) {
                picture = [picture zoomImage:self.zoomIndex];
            }
            */
            if (self.delegate && [self.delegate respondsToSelector:@selector(cameraView:captureImage:)]) {
                [self.delegate cameraView:self captureImage:picture];
            }
        } else {
            NSDictionary *info = @{NSLocalizedDescriptionKey:
                                       NSLocalizedString(@"Error while save image, please try later", nil)};
            error = [NSError errorWithDomain:@"AVCamera.controller"
                                        code:1
                                    userInfo:info];
            [self sendError:error];
        }
    } else {
        [self sendError:error];
    }
}

- (void)sendError:(NSError*)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraView:failedWithError:)]) {
        [self.delegate cameraView:self failedWithError:error];
    }
}

- (void)lockCameraView
{
    if (self.delegate &&
            [self.delegate respondsToSelector:@selector(cameraViewDidLock:)]) {
        [self.delegate cameraViewDidLock:self];
    }
}

- (void)unlockCameraView
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cameraViewDidUnLock:)]) {
        [self.delegate cameraViewDidUnLock:self];
    }
}

- (BOOL)hasFlash
{
    return self.activeDevice.hasFlash;
}

- (AVCaptureFlashMode)flashMode
{
    return self.activeDevice.flashMode;
}

- (void)setNextFlashMode
{
    [self setNextFlashModeAfter:self.activeDevice.flashMode];
}

- (BOOL)setNextFlashModeAfter:(AVCaptureFlashMode)mode
{
    AVCaptureFlashMode newMode;
    if (mode == AVCaptureFlashModeOff) {
        newMode = AVCaptureFlashModeAuto;
    } else if (mode == AVCaptureFlashModeAuto) {
        newMode = AVCaptureFlashModeOn;
    } else {
        newMode = AVCaptureFlashModeOff;
    }
    if ([self tryToSetFlashMode:newMode]) {
        return YES;
    } else {
        return [self setNextFlashModeAfter:newMode];
    }
}

- (BOOL)tryToSetFlashMode:(AVCaptureFlashMode)mode
{
    if ([self.activeDevice isFlashModeSupported:mode]) {
        NSError *error;
        if (![self.activeDevice lockForConfiguration:&error]) {
            [self sendError:error];
            return YES;
        }
        self.activeDevice.flashMode = mode;
        if (self.delegate && [self.delegate respondsToSelector:@selector(cameraView:setNewFlashMode:)]) {
            [self.delegate cameraView:self setNewFlashMode:mode];
        }
        [self.activeDevice unlockForConfiguration];
        return YES;
    }
    return NO;
}

- (void)setZoomIndex:(CGFloat)zoomIndex
{
    if (zoomIndex < 1) {
        zoomIndex = 1;
    }
    if (zoomIndex > 10) {
        zoomIndex = 10;
    }
    _zoomIndex = zoomIndex;
    [self makeAndApplyAffineTransform];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraView:updateZoomIndex:)]) {
        [self.delegate cameraView:self updateZoomIndex:zoomIndex];
    }
}

- (void)makeAndApplyAffineTransform
{
    CGAffineTransform affineTransform = CGAffineTransformIdentity;
	affineTransform = CGAffineTransformScale(affineTransform, self.zoomIndex, self.zoomIndex);
	[CATransaction begin];
	[CATransaction setAnimationDuration:.025];
    [self.previewLayer setAffineTransform:affineTransform];
	[CATransaction commit];
}

@end
