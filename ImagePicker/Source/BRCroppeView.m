//
//  BRCroppeView.m
//  ImagePicker
//
//  Created by Alexander on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRCroppeView.h"
#import <QuartzCore/QuartzCore.h>
#import "BRTouchFreeView.h"

@interface BRCroppeView ()
@property (strong) UIImageView *imageView;
@property (strong) UIScrollView *scrollView;
@property (strong) BRTouchFreeView *cropperBorder;

@end

@implementation BRCroppeView

- (id)initWithImage:(UIImage*)image
{
    self = [self init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 4;
        self.scrollView.delegate = self;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self.scrollView addSubview:self.imageView];
        [self addSubview:self.scrollView];
        
        self.cropperBorder = [[BRTouchFreeView alloc] init];
        self.cropperBorder.backgroundColor = [UIColor clearColor];
        self.cropperBorder.layer.borderColor = [UIColor whiteColor].CGColor;
        self.cropperBorder.layer.borderWidth = 2;
        self.cropperBorder.exclusiveTouch = NO;
        [self addSubview:self.cropperBorder];
        
    }
    return self;
}
- (void)setfffFrame:(CGRect)frame
{
    [super setFrame:frame];
    UIImage *imageFirScreen = [self imageFitScreen:self.image newRect:frame];
    
    CGRect newFrame = [self.imageView frame];
    newFrame.size.width = imageFirScreen.size.width;
    newFrame.size.height = imageFirScreen.size.height;
    newFrame.origin.x = (frame.size.width - imageFirScreen.size.width) / 2;
    newFrame.origin.y = (frame.size.height - imageFirScreen.size.height) / 2;
    
    [UIView beginAnimations:nil context:nil];       //动画开始
    [UIView setAnimationDuration:1];
    
    [self.imageView setImage:imageFirScreen];
    [self.imageView setFrame:frame];
    [self.scrollView setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //CGFloat min = MIN(self.bounds.size.width, self.bounds.size.height);
    self.scrollView.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.imageView.frame = self.scrollView.bounds;
    self.scrollView.center = self.center;
    self.cropperBorder.frame = self.scrollView.frame;
}
- (UIImage *)imageFitScreen:(UIImage *)image newRect:(CGRect) newRect
{
    UIImage *resultsImg;
    
    CGSize origImgSize = [image size];
    
    //确定缩放倍数
    float ratio = MIN(newRect.size.width / origImgSize.width, newRect.size.height / origImgSize.height);
    
    //    UIGraphicsBeginImageContext(newRect.size);
    UIGraphicsBeginImageContextWithOptions(newRect.size, YES, 1.0);
    
    CGRect rect;
    rect.size.width = ratio * origImgSize.width;
    rect.size.height = ratio * origImgSize.height;
    rect.origin.x = (newRect.size.width - rect.size.width) / 2.0;
    rect.origin.y = (newRect.size.height - rect.size.height) / 2.0;
    
    [image drawInRect:rect];
    
    resultsImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultsImg;
    
}
#pragma mark Image

- (void)setImage:(UIImage *)image
{
    self.imageView.image = [self imageFitScreen:image newRect:self.bounds];
}

- (UIImage*)image
{
    return self.imageView.image;
}

#pragma mark - Cropper

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
