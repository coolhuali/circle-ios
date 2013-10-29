//
//  ImageViewCell.h
//  OpenFireClient
//
//  Created by admin on 13-7-31.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressIndicator.h"
#import "BubbleView.h"

@interface ImageViewCell : UITableViewCell

@property (strong, nonatomic) NSURL *sourceUrl;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) ProgressIndicator *progress;
@property (nonatomic) BOOL isLoading;
- (void)setTargetUrl:(NSString *)targetUrl;
+ (CGFloat)cellHeightForText;
- (id)initWithBubbleStyle:(BubbleMessageStyle)style
          reuseIdentifier:(NSString *)reuseIdentifier;
@end
