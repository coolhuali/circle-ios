//
//  MessageToolBarView.h
//  Circle
//
//  Created by admin on 13-10-30.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInputView.h"
#import "ChatSelectionView.h"

#define KEY_BOARD_HEIGHT 216.0f 

@interface MessageToolBarView : UIView

@property (strong, nonatomic) MessageInputView *messageInputView;
@property (strong, nonatomic) ChatSelectionView *shareMoreView;
@end
