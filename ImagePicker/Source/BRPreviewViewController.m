//
//  BRPreviewViewController.m
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRPreviewViewController.h"
#import "BRCroppeView.h"

@interface BRPreviewViewController ()
@property (nonatomic, weak) IBOutlet UIView *imageCropper;
@property (nonatomic, weak) IBOutlet UILabel *barItemLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonRetake;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonDone;

@end

@implementation BRPreviewViewController

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
    _barItemLabel.text = NSLocalizedString(@"move_and_scale", nil);
    _buttonRetake.title = NSLocalizedString(@"retake", nil);
    _buttonDone.title = NSLocalizedString(@"done", nil);
    CGRect rect = self.imageCropper.frame;
    //CGSize size = self.previewImage.size;
    //确定缩放倍数
    //float scale = MIN(self.imageCropper.bounds.size.width / size.width, self.imageCropper.bounds.size.height / size.height);
    //size.height = size.height*scale;
    //size.width = size.width*scale;
    BRCroppeView *cropper = [[BRCroppeView alloc] init];
    cropper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [cropper setFrame:rect];
    [cropper setImage:self.previewImage];
    [self.imageCropper addSubview:cropper];
    
    self.progress=[[BRProgressIndicator alloc] initWithFrame:CGRectMake(0, 10, 320, 44)];
    [self.view addSubview:self.progress];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.progress setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewViewControllerCanceled:)]) {
        [self.delegate previewViewControllerCanceled:self];
    }
}

- (IBAction)useAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewViewController:croppedImage:imageData:)])
    {
        ((UIBarButtonItem *)sender).enabled = FALSE;
        //UIImage *target = [self imageWithImageSimple:self.previewImage scaledToSize:CGSizeMake(640,960)];
        NSData* imageData = UIImageJPEGRepresentation(self.previewImage,0.5);
        //NSData* imageData = UIImagePNGRepresentation(target);
        //NSData* imageData = UIImagePNGRepresentation(self.previewImage);
        self.progress.totalSize = imageData.length;
        [self.progress setProgress:0.0 animated:NO];
        [self.progress setHidden:YES];
        [self.delegate previewViewController:self croppedImage:self.previewImage imageData:imageData];
    }
}

@end
