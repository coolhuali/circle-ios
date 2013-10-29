//
//  BRCroppeView.h
//  ImagePicker
//
//  Created by Alexander on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRCroppeView : UIView <UIScrollViewDelegate>
@property (strong, nonatomic) UIImage *image;

- (id)initWithImage:(UIImage*)image;

@end
