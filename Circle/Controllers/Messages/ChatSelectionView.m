//
//  WCChatSelectionView.m
//  微信
//
//  Created by Reese on 13-8-22.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "ChatSelectionView.h"
#define CHAT_BUTTON_SIZE 70
#define INSETS 10


@implementation ChatSelectionView

- (id)init
{
    self = [super init];
    if (self) {
        //写死面板的高度
        //[self setBackgroundColor:[UIColor whiteColor]];
        
        self.userInteractionEnabled = YES;
        
        // Initialization code
        _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(INSETS, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_photoButton setImage:[UIImage imageNamed:@"sharemore_pic"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(pickPhoto_Button) forControlEvents:UIControlEventTouchUpInside];
        [_photoButton.imageView.layer setMasksToBounds:YES];
        [_photoButton.layer setCornerRadius:5.0f];
        [self addSubview:_photoButton];
        
        _cameraButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setFrame:CGRectMake(INSETS+CHAT_BUTTON_SIZE, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_cameraButton setImage:[UIImage imageNamed:@"sharemore_video"] forState:UIControlStateNormal];
        
        [_cameraButton addTarget:self action:@selector(cameraPhoto_Button) forControlEvents:UIControlEventTouchUpInside];
        [_cameraButton.imageView.layer setMasksToBounds:YES];
        [_cameraButton.layer setCornerRadius:5.0f];
        [self addSubview:_cameraButton];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)pickPhoto_Button
{
    [_delegate pickPhoto];
}

-(void)cameraPhoto_Button
{
    [_delegate cameraPhoto];
}
@end
