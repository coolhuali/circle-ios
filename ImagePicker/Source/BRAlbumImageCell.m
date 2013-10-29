//
//  BRAlbumImageCell.m
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRAlbumImageCell.h"

@interface BRAlbumImageCell ()
@property (strong, readwrite) UIImageView *imageView;

@end

@implementation BRAlbumImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end
