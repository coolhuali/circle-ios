//
//  BRCameraPickerViewController.h
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRAbstractPickerViewController.h"
#import "BRCameraView.h"

@interface BRCameraPickerViewController : BRAbstractPickerViewController <BRCameraViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *takeImageButton;
@property (nonatomic, weak) IBOutlet UIButton *flashButton;
@property (nonatomic, weak) IBOutlet UIButton *deviceButton;


@end
