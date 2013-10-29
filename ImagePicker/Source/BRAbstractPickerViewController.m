//
//  BRAbstractPickerViewController.m
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRAbstractPickerViewController.h"

@interface BRAbstractPickerViewController ()

@end

@implementation BRAbstractPickerViewController

+ (NSBundle*)imagePickerBundle
{
    //TODO load from bundle
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"BRImagePickerBundle.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:filePath];
    return bundle;*/
    return [NSBundle mainBundle];
}

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark

- (void)sendError:(NSError*)error
{
    
}

#pragma mark Controller life and death

- (void)dismiss
{
    if (self.delegate) {
        [self.delegate pickerControllerCanceled:self];
    }
}

@end
