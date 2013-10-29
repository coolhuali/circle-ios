//
//  POPMessageViewController.h
//  OpenFireClient
//
//  Created by admin on 13-7-19.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "STableViewController.h"
#import "MessageInputView.h"
#import "BubbleMessageCell.h"
#import "MessageSoundEffect.h"
#import "POVoiceHUD.h"

@interface POPMessageViewController : STableViewController<UITextViewDelegate,UIGestureRecognizerDelegate,POVoiceHUDDelegate>{
    NSMutableArray *items;
    int totalCount;
    int currentPage;
    int currentPos;
    int pageSize;
    UILabel *topTitle;
    UIActivityIndicatorView *topIndicator;
}
@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (strong, nonatomic) MessageInputView *inputView;
@property (nonatomic, strong) UILabel *topTitle;
@property (nonatomic, strong) UIActivityIndicatorView *topIndicator;

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text;
- (void)sendPressed:(UIButton *)sender;
- (void)attachedImagePressed:(UIButton *)sender withText:(NSString *)text;
- (void)attachedFilePressed:(UIButton *)sender withText:(NSString *)text;
- (void)attachedPressed:(UIButton *)sender;
- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer;

#pragma mark - Messages view controller
- (BOOL) beforeAddItemsOnTop;
- (BubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)finishSend;
- (void)refreshData;
- (void)setBackgroundColor:(UIColor *)color;
- (void)scrollToBottomAnimated:(BOOL)animated;

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification;
- (void)handleWillHideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;
@end
