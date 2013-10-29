//
//  SoundViewCell.m
//  OpenFireClient
//
//  Created by admin on 13-8-1.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>

#import "SoundViewCell.h"
#import "ProgressIndicator.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "MAppStrings.h"
#import "BubbleView.h" 
#import "ASIFormDataRequest.h" 

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 32.0f
#define kTargetWidth 150.0f
#define kTargetHeight 40.0f

@interface SoundViewCell()
@property (assign, nonatomic) BubbleMessageStyle style;
@property (strong, nonatomic) UIImage *incomingBackground;
@property (strong, nonatomic) UIImage *outgoingBackground;
@property (strong, nonatomic) NSString *sourcePath;

@end

@implementation SoundViewCell
@synthesize imageView;
@synthesize progress;
@synthesize isLoading;

- (CGRect)imageFrame{
    CGSize bubbleSize = [SoundViewCell bubbleSizeForText];
    CGRect bubbleFrame = CGRectMake(((self.style == BubbleMessageStyleOutgoingSound) ? self.frame.size.width - bubbleSize.width : 0.0f),
                                    kMarginTop,
                                    bubbleSize.width,
                                    bubbleSize.height);
    CGFloat textX = 12.0f + ((self.style == BubbleMessageStyleOutgoingSound) ? bubbleFrame.origin.x : 0.0f);
    CGSize textSize = [SoundViewCell textSizeForText];
    CGRect textFrame = CGRectMake(textX,
                                  kPaddingTop + kMarginTop,
                                  textSize.width,
                                  textSize.height);
    return textFrame;
}
- (CGRect)styleFrame{
    CGSize bubbleSize = [SoundViewCell bubbleSizeForText];
    CGRect bubbleFrame = CGRectMake(((self.style == BubbleMessageStyleOutgoingSound) ? self.frame.size.width - bubbleSize.width : 0.0f),
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
    CGRect pframe = CGRectMake((self.style == BubbleMessageStyleOutgoingSound) ? self.frame.size.width - kTargetWidth-20 : 2.0f,
                               kMarginTop+kPaddingTop,
                               kTargetWidth,
                               44);
    progress = [[ProgressIndicator alloc] initWithFrame:pframe];
    [progress setHidden:YES];
    
    //self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *styleView = [[UIImageView alloc] init];
    [styleView setImage:(self.style == BubbleMessageStyleIncomingSound) ? self.incomingBackground : self.outgoingBackground];
    [styleView setFrame:[self styleFrame]];
    styleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [styleView addGestureRecognizer:singleTap];
    
    [self.contentView addSubview:styleView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.progress];
    
}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(isLoading || self.sourcePath==nil)return;
    [self playSoundWithName];
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
    return [SoundViewCell bubbleSizeForText].height + kMarginTop + kMarginBottom;
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
    [self downloadContent:targetUrl];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
} 
-(void)downloadContent:(NSString *)targetUrl
{ 
    //if(isLoading)return;
    isLoading = TRUE;
    
    [self.progress setProgress:0.0 animated:NO];
    [self.progress setHidden:FALSE];
    
    NSURL *url = [NSURL URLWithString:targetUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.showAccurateProgress=YES;
    [request setDownloadProgressDelegate:self.progress];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    isLoading = NO;
    [self.progress setHidden:YES];
    // 当以文本形式读取返回内容时用这个方法
    NSData *responseData = [request responseData];
    NSString *fileName = [request.url lastPathComponent];
    self.sourcePath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),fileName];
    if([responseData writeToFile:self.sourcePath atomically:YES]) {
        //[self playSoundWithName];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    isLoading = NO;
    NSError *error = [request error];
    NSLog(@"response:%@", error);
}
- (void)playSoundWithName
{
    if([[NSFileManager defaultManager] fileExistsAtPath:self.sourcePath]) {
        NSURL *url = [NSURL fileURLWithPath:self.sourcePath];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else {
        NSLog(@"**** Sound Error: file not found: %@", self.sourcePath);
    }
}
@end
