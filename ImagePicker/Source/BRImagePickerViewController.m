//
//  BRImagePickerViewController.m
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRImagePickerViewController.h"
#import "BRCameraPickerViewController.h"
#import "BRAlbumPickerViewController.h"
#import "BRPreviewViewController.h"
#import "BRProgressIndicator.h"

@interface BRImagePickerViewController ()
@property (strong, nonatomic) BRProgressIndicator *progress;

@end

@implementation BRImagePickerViewController

+ (BOOL)isSourceTypeAvailable:(BRImagePickerViewControllerType)type
{
    //TODO rewrite with AV
    UIImagePickerControllerSourceType source;
    switch (type) {
        case BRImagePickerViewControllerTypeCamera:
            source = UIImagePickerControllerSourceTypeCamera;
            break;
            
        case BRImagePickerViewControllerTypePhotoLibrary:
            source = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    return [UIImagePickerController isSourceTypeAvailable:source];
}

- (id)initWithSourceType:(BRImagePickerViewControllerType)sourceType
{
    self = [super init];
    if (self) {
        self.sourceType = sourceType;
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [self init];
    return self;
}

- (id)init
{
    self = [self initWithSourceType:BRImagePickerViewControllerTypePhotoLibrary];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSBundle *imagePickerBundle = [BRAbstractPickerViewController imagePickerBundle];
    BRAbstractPickerViewController *rootController;
	if (self.sourceType == BRImagePickerViewControllerTypeCamera) {
        rootController = [[BRCameraPickerViewController alloc] initWithNibName:@"BRCameraPickerViewController"
                                                                        bundle:imagePickerBundle];
    } else {
        rootController = [[BRAlbumPickerViewController alloc] init];
    }
    rootController.delegate = self;
    [self setViewControllers:@[ rootController ]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentImagePickerInViewController:(UIViewController*)controller
{
    [controller presentViewController:self
                             animated:YES
                           completion:nil];
}

- (void)dismissImagePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BRAbstractPickerViewControllerDelegate

- (void)pickerControllerCanceled:(BRAbstractPickerViewController*)pickerController
{
    if (self.canceledHandler) {
        [self dismissImagePicker];
        dispatch_async(dispatch_get_main_queue(), self.canceledHandler);
    } else {
        [self dismissImagePicker];
    }
}

- (void)pickerController:(BRAbstractPickerViewController*)pickerController captureImage:(UIImage*)image
{
    [self previewImage:image];
}

#pragma mark - Preview

- (void)previewImage:(UIImage*)image
{
    BRPreviewViewController *previewController = [[BRPreviewViewController alloc] init];
    previewController.delegate = self;
    previewController.previewImage = image;
    previewController.cropped = self.allowsEditing;
    [self pushViewController:previewController animated:YES];
}

- (void)previewViewControllerCanceled:(BRAbstarctPreviewViewController*)previewController
{
    [self popViewControllerAnimated:YES];
}

- (void)previewViewController:(BRAbstarctPreviewViewController*)previewController croppedImage:(UIImage*)image imageData:(NSData*)imageData
{
    if (self.captureHandler) {
        dispatch_block_t block = ^(){
            self.captureHandler(previewController,image,imageData);
        };
        dispatch_async(dispatch_get_main_queue(), block);
    } }

#pragma mark Save image

@end
