//
//  SoundViewCell.h
//  OpenFireClient
//
//  Created by admin on 13-8-1.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProgressIndicator.h"
#import "BubbleView.h"
@interface SoundViewCell : UITableViewCell

@property (strong, nonatomic) NSString *targetUrl;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) ProgressIndicator *progress;
@property (nonatomic) BOOL isLoading;
+ (CGFloat)cellHeightForText;
- (id)initWithBubbleStyle:(BubbleMessageStyle)style
          reuseIdentifier:(NSString *)reuseIdentifier;
@end
