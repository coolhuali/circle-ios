//
//  MessageToolBarView.m
//  Circle
//
//  Created by admin on 13-10-30.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "MessageToolBarView.h"

@implementation MessageToolBarView

- (id)init
{
    self = [super init];
    if (self) {
        [self setupInputArea];
        [self setupAttachedArea];
    }
    return self;
}
- (void)setupInputArea
{
    self.messageInputView =[[MessageInputView alloc]initWithFrame:CGRectMake(0, 0, 320, INPUT_HEIGHT)];
    self.messageInputView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:self.messageInputView];
}
- (void)setupAttachedArea
{
     self.shareMoreView =[[ChatSelectionView alloc]init];
     [self.shareMoreView setBackgroundColor:[UIColor lightGrayColor]];
     [self.shareMoreView setFrame:CGRectMake(0, INPUT_HEIGHT, 320, KEY_BOARD_HEIGHT)];
     self.shareMoreView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
     [self addSubview:self.shareMoreView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
