//
//  ImageViewCell.m
//  OpenFireClient
//
//  Created by admin on 13-7-31.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "ImageViewCell.h"
#import "ProgressIndicator.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "MAppStrings.h"
#import "BubbleView.h" 

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f
#define kTargetWidth 100.0f
#define kTargetHeight 120.0f

@interface ImageViewCell()
@property (assign, nonatomic) BubbleMessageStyle style;
@property (strong, nonatomic) UIImage *incomingBackground;
@property (strong, nonatomic) UIImage *outgoingBackground;

@end

@implementation ImageViewCell
@synthesize imageView;
@synthesize progress;
@synthesize isLoading;
@synthesize sourceUrl;

- (CGRect)imageFrame{
    CGSize bubbleSize = [ImageViewCell bubbleSizeForText];
    CGRect bubbleFrame = CGRectMake(((self.style == BubbleMessageStyleOutgoingImage) ? self.frame.size.width - bubbleSize.width : 0.0f),
                                    kMarginTop,
                                    bubbleSize.width,
                                    bubbleSize.height);
    CGFloat textX = 6.0f + ((self.style == BubbleMessageStyleOutgoingImage) ? bubbleFrame.origin.x : 0.0f);
    CGSize textSize = [ImageViewCell textSizeForText];
    CGRect textFrame = CGRectMake(textX,
                                  kPaddingTop + kMarginTop,
                                  textSize.width+16,
                                  textSize.height);
    return textFrame;
}
- (CGRect)styleFrame{
    CGSize bubbleSize = [ImageViewCell bubbleSizeForText];
    CGRect bubbleFrame = CGRectMake(((self.style == BubbleMessageStyleOutgoingImage) ? self.frame.size.width - bubbleSize.width : 0.0f),
                                    kMarginTop,
                                    bubbleSize.width,
                                    bubbleSize.height);
    return bubbleFrame;
}
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.incomingBackground = [[UIImage imageNamed:@"messageBubbleGray"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
    self.outgoingBackground = [[UIImage imageNamed:@"messageBubbleBlue"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
     
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"defaultPic.png"]];
    [imageView setFrame:[self imageFrame]];
    CGRect pframe = CGRectMake((self.style == BubbleMessageStyleOutgoingImage) ? self.frame.size.width - kTargetWidth-20 : 2.0f,
                               0.0f,
                               kTargetWidth,
                               44);
    progress = [[ProgressIndicator alloc] initWithFrame:pframe];
    [progress setHidden:YES];
    
    //self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *styleView = [[UIImageView alloc] init];
    [styleView setImage:(self.style == BubbleMessageStyleIncomingImage) ? self.incomingBackground : self.outgoingBackground];
    [styleView setFrame:[self styleFrame]];
    
    [self.contentView addSubview:styleView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.progress];
  
}


+ (CGSize)textSizeForText
{
	return CGSizeMake(kTargetWidth,
                      kTargetHeight);
}
+ (CGSize)bubbleSizeForText
{ 
	return CGSizeMake(kTargetWidth + kBubblePaddingRight,
                      kTargetHeight + kPaddingTop + kPaddingBottom);
}
+ (CGFloat)cellHeightForText
{
    return [ImageViewCell bubbleSizeForText].height + kMarginTop + kMarginBottom;
}

- (id)initWithBubbleStyle:(BubbleMessageStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self.style = style;
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup]; 
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setTargetUrl:(NSString *)targetUrl{
    self.sourceUrl = [NSURL URLWithString:targetUrl];
    [self downloadContent:targetUrl];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
} 
- (void)downloadContent:(NSString *)urlStr
{
    //if(isLoading)return;
    isLoading = YES;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    UIImage *image = [[SDWebImageManager sharedManager] imageWithUrl:url];
    if(!image)
    {
        [progress setProgress:0.0 animated:NO];
        [self.progress setHidden:NO];
        [[SDWebImageManager sharedManager] downloadWithURL:url
                                                   options:SDWebImageLowPriority
                                                  progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             
             [progress setTotalSize:expectedSize];
             
             [progress setProgress:(receivedSize * 1.0 / expectedSize) animated:YES];
             
         }
                                                 completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (finished)
             {
                 isLoading = NO;
                 [progress setHidden:YES];
                 [imageView setImage:[self roundCorners:[self imageWithImageSimple:aImage]]];
                 [imageView setFrame:[self imageFrame]];
             }
         }];
    }else{
        isLoading = NO;
        [progress setHidden:YES];
        [imageView setImage:[self roundCorners:[self imageWithImageSimple:image]]];
        [imageView setFrame:[self imageFrame]];
    }
}
-(UIImage*)imageWithImageSimple:(UIImage*)image
{
    CGSize newSize = CGSizeMake(kTargetWidth,kTargetHeight);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect),
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
- (UIImage *) roundCorners: (UIImage*) img
{
    int w = img.size.width;
    int h = img.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
}
@end
