//
//  BaseMessageViewController.h
//  Circle
//
//  Created by admin on 13-9-30.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "BaseListViewController.h" 
#import "MessageToolBarView.h"
#import "MessageSoundEffect.h"
#import "POVoiceHUD.h"
#import "CustomMessageCell.h"
#import "ChatSelectionView.h"
#import "UIView+AnimationOptionsForCurve.h" 


@interface BaseMessageViewController : BaseListViewController<UITextViewDelegate,UIGestureRecognizerDelegate,POVoiceHUDDelegate,ShareMoreDelegate,CustomMessageDelegate>{
    NSString* targetJID;
    BOOL isGrouping;
    
}
- (id) initWithId:(NSString *)jid isGroup:(BOOL)isGroup;


@end
