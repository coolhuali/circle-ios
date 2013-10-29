//
//  BRCameraPickerViewController.m
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRCameraPickerViewController.h"

@interface BRCameraPickerViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet BRCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;

@end

@implementation BRCameraPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![BRCameraView isCameraDeviceAvailable:BRCameraPickerViewControllerCameraDeviceFront]) {
        self.deviceButton.hidden = YES;
    }
    self.buttonCancel.title = NSLocalizedString(@"cancel",nil);
    self.cameraView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.flashButton.hidden = ![BRCameraView isFlashAvailableForCameraDevice:BRCameraPickerViewControllerCameraDeviceRear];
    self.deviceButton.hidden = ![BRCameraView isCameraDeviceAvailable:BRCameraPickerViewControllerCameraDeviceFront];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.cameraView stopCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.cameraView startCamera];
    //self.cameraView.zoomIndex = self.zoomSlider.value;
}

#pragma mark - BRCameraViewDelegate

- (void)cameraViewDidLock:(BRCameraView*)cameraCapture
{
    [self blockControls];
}

- (void)cameraViewDidUnLock:(BRCameraView*)cameraCapture
{
    [self unblockControls];
}

- (void)cameraView:(BRCameraView*)cameraCapture startDevice:(BRCameraPickerViewControllerCameraDevice)device
{
    self.flashButton.hidden = ![BRCameraView isFlashAvailableForCameraDevice:device];
    //self.zoomSlider.value = cameraCapture.zoomIndex;
}

- (void)cameraView:(BRCameraView*)cameraCapture captureImage:(UIImage*)image
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerController:captureImage:)]) {
        [self.delegate pickerController:self captureImage:image];
    }
}

- (void)cameraView:(BRCameraView*)cameraCapture setNewFlashMode:(AVCaptureFlashMode)flashMode
{
    UIImage *flashImage;
    switch (flashMode) {
        case AVCaptureFlashModeAuto:
            flashImage = [UIImage imageNamed:@"flash-auto"];
            break;
            
        case AVCaptureFlashModeOff:
            flashImage = [UIImage imageNamed:@"flash-off"];
            break;
            
        case AVCaptureFlashModeOn:
        default:
            flashImage = [UIImage imageNamed:@"flash-on"];
            break;
    }
    [self.flashButton setImage:flashImage forState:UIControlStateNormal];
}

- (void)cameraView:(BRCameraView*)cameraCapture updateZoomIndex:(CGFloat)zoomIndex
{
    //self.zoomSlider.value = zoomIndex;
}

- (void)cameraView:(BRCameraView*)cameraCapture failedWithError:(NSError*)error
{
    
}

#pragma mark - Controlls

#pragma mark -

- (void)blockControls
{
    [self.activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
}

- (void)unblockControls
{
    [self.activityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Actions

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self dismiss];
}

- (IBAction)flashAction:(UIButton *)sender {
    if ([self.cameraView hasFlash]) {
        [self.cameraView setNextFlashMode];
    }
}

- (IBAction)deviceAction:(UIButton *)sender {
    BRCameraPickerViewControllerCameraDevice cameraDevice;
    if (self.cameraView.cameraDevice == BRCameraPickerViewControllerCameraDeviceRear) {
        cameraDevice = BRCameraPickerViewControllerCameraDeviceFront;
    } else {
        cameraDevice = BRCameraPickerViewControllerCameraDeviceRear;
    }
    self.cameraView.cameraDevice = cameraDevice;
}

- (IBAction)takePhotoAction:(UIButton *)sender {
    [self.cameraView takeImage];
}

@end
