//
//  POPMessageViewController.m
//  OpenFireClient
//
//  Created by admin on 13-7-19.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "POPMessageViewController.h"
#import "MessageInputView.h"
#import "MAppStrings.h"
#import "NSString+MessagesView.h"
#import "UIView+AnimationOptionsForCurve.h" 
#import "ASIFormDataRequest.h"
#import "JSONKit.h" 
#import "BRImagePickerViewController.h"
#import "ImageViewCell.h"
#import "SoundViewCell.h"
#import "POVoiceHUD.h"
#import "GGFullscreenImageViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f
#define INPUT_HEIGHT 5.0f

@interface POPMessageViewController ()
@property (strong, nonatomic) POVoiceHUD *voiceHud;
// Private helper methods
- (void) addItemsOnTop;
@end

@implementation POPMessageViewController

@synthesize topTitle;
@synthesize topIndicator;
@synthesize items;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupInput];
    [self setupHeader];
    [self setupVoice];
    self.tableView.separatorColor=[UIColor clearColor];
    totalCount=0;
    currentPage=0;
    currentPos=0;
    pageSize=20;
    items = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)setupVoice{
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
    self.voiceHud.title = @"Speak Now";
    [self.voiceHud setDelegate:self];
    [self.view addSubview:self.voiceHud];
}
- (void)setupInput
{
    CGSize size = self.view.frame.size;
	 
    self.tableView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height - INPUT_HEIGHT);
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputView = [[MessageInputView alloc] initWithFrame:inputFrame];
    self.inputView.textView.returnKeyType = UIReturnKeySend;
    self.inputView.textView.delegate = self;
    [self.inputView.sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.soundButton addTarget:self action:@selector(soundPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.attachedButton addTarget:self action:@selector(attachedPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputView];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:singleTapRecognizer];
}
- (void)setupHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    topTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    topTitle.font = [UIFont boldSystemFontOfSize:12.0];
    topTitle.textAlignment = NSTextAlignmentCenter;
    
    topIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    topIndicator.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    topIndicator.hidesWhenStopped = YES;
    [headerView addSubview:topTitle];
    [headerView addSubview:topIndicator];
    self.headerView = headerView;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Pull to Refresh

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinHeaderView
{
    [super pinHeaderView];
    [topIndicator startAnimating];
     topTitle.text = @"Loading...";
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinHeaderView
{
    [super unpinHeaderView];
    // do custom handling for the header view
    [topIndicator stopAnimating];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Update the header text while the user is dragging
//
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    if(currentPos == -1){
        return;
    }
    if (willRefreshOnRelease)
        topTitle.text = @"Release to load more...";
    else
        topTitle.text = @"Pull down to load more...";
}
 
//
// refresh the list. Do your async calls here.
//
- (BOOL) refresh
{
    if(currentPos == -1){
        return NO;
    }
    if (![super refresh])
        return NO;
    // Do your async call here
    // This is just a dummy data loader:
    [self performSelector:@selector(addItemsOnTop) withObject:nil afterDelay:1.0];
    // See -addItemsOnTop for more info on how to finish loading
    
    return YES;
}
#pragma mark - Dummy data methods

- (BOOL) beforeAddItemsOnTop
{
    return NO;
}
- (void) addItemsOnTop
{
    if([self beforeAddItemsOnTop]){
        [self.tableView reloadData];
    }else{
        currentPos = -1;
        topTitle.text = @"no data for loading";
    }
    // Call this to indicate that we have finished "refreshing".
    // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
    [self refreshCompleted];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                           0.0f,
                                           self.view.frame.size.height - self.inputView.frame.origin.y - INPUT_HEIGHT,
                                           0.0f);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}
#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text { }
// override in subclass

- (void)sendPressed:(UIButton *)sender
{
    [self sendPressed:sender
             withText:[self.inputView.textView.text trimWhitespace]];
    
    [self.inputView.textView setText:nil];
}

- (void)attachedImagePressed:(UIButton *)sender withText:(NSString *)text { }

- (void)attachedFilePressed:(UIButton *)sender withText:(NSString *)text{ }

- (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}
- (void)soundPressed:(UIButton *)sender{
    [self.inputView resignFirstResponder];
    [self.voiceHud startForFilePath:[NSString stringWithFormat:@"%@/Documents/%@.caf", NSHomeDirectory(),[self getCurrentTimeString]]];
}

- (void)attachedPressed:(UIButton *)sender
{
    [self.inputView resignFirstResponder]; 
}

- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer
{
    [self.inputView.textView resignFirstResponder];
}

#pragma mark - Actions
 
#pragma mark - POVoiceHUD Delegate

- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength sourceUrl:(NSString *)sourceUrl{
    NSLog(@"Sound recorded with file %@ for %.2f seconds", [recordPath lastPathComponent], recordLength);
    //[FileMD5Hash computeMD5HashOfFileInPath:recordPath];
    [self attachedFilePressed:nil withText:[NSString stringWithFormat:API_DOWN_IMAGE_URL,sourceUrl]];
}

- (void)voiceRecordCancelledByUser:(POVoiceHUD *)voiceHUD {
    NSLog(@"Voice recording cancelled for HUD: %@", voiceHUD);
} 

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *_cell;
    BubbleMessageStyle style = [self messageStyleForRowAtIndexPath:indexPath];
    NSString *CellID = [NSString stringWithFormat:@"MessageCell%d", style];
    _cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if(!_cell) {
        if(style==BubbleMessageStyleTime){
            _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            _cell.backgroundColor = [UIColor grayColor];
            _cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        else if(style==BubbleMessageStyleOutgoingImage || style==BubbleMessageStyleIncomingImage){
            _cell = [[ImageViewCell alloc] initWithBubbleStyle:style reuseIdentifier:CellID];
        }
        else if(style==BubbleMessageStyleOutgoingSound || style==BubbleMessageStyleIncomingSound){
            _cell = [[SoundViewCell alloc] initWithBubbleStyle:style reuseIdentifier:CellID];
        }else{
            _cell = [[BubbleMessageCell alloc] initWithBubbleStyle:style
                                               reuseIdentifier:CellID];
        }
    }
        if(style==BubbleMessageStyleTime){
            _cell.textLabel.text = [self textForRowAtIndexPath:indexPath];
        }
        else if(style==BubbleMessageStyleOutgoingImage || style==BubbleMessageStyleIncomingImage){
            ImageViewCell *cell = (ImageViewCell *)_cell;
            [cell setTargetUrl:[self textForRowAtIndexPath:indexPath]];
        }
        else if(style==BubbleMessageStyleOutgoingSound || style==BubbleMessageStyleIncomingSound){
            SoundViewCell *cell = (SoundViewCell *)_cell;
            [cell setTargetUrl:[self textForRowAtIndexPath:indexPath]];
        }
        else{
            BubbleMessageCell *cell = (BubbleMessageCell *)_cell;
            cell.bubbleView.text = [self textForRowAtIndexPath:indexPath];
            cell.backgroundColor = tableView.backgroundColor;
        }
    return _cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BubbleMessageStyle style = [self messageStyleForRowAtIndexPath:indexPath];
    if(style==BubbleMessageStyleOutgoingImage || style==BubbleMessageStyleIncomingImage){
        return [ImageViewCell cellHeightForText];
    }else if(style==BubbleMessageStyleOutgoingSound || style==BubbleMessageStyleIncomingSound){
        return [SoundViewCell cellHeightForText];
    }else{
        return [BubbleView cellHeightForText:[self textForRowAtIndexPath:indexPath]];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    BubbleMessageStyle style = [self messageStyleForRowAtIndexPath:indexPath];
    if(style==BubbleMessageStyleOutgoingImage || style==BubbleMessageStyleIncomingImage){
        ImageViewCell *cell = (ImageViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        UIImage *image = [[SDWebImageManager sharedManager] imageWithUrl:cell.sourceUrl];
        GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
        vc.liftedImageView = [[UIImageView alloc] initWithImage:image];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (BubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0; // Override in subclass
}
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil; // Override in subclass
}
#pragma mark - Messages view controller


- (void)finishSend
{
    [self.inputView.textView setText:nil];
    [self refreshData];
}
- (void)refreshData
{
    [self textViewDidChange:self.inputView.textView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.headerView.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [MessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    changeInHeight = (textViewContentHeight + changeInHeight >= maxHeight) ? 0.0f : changeInHeight;
    
    if(changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, self.tableView.contentInset.bottom + changeInHeight, 0.0f);
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             
                             [self scrollToBottomAnimated:NO];
                             
                             CGRect inputViewFrame = self.inputView.frame;
                             self.inputView.frame = CGRectMake(0.0f,
                                                               inputViewFrame.origin.y - changeInHeight,
                                                               inputViewFrame.size.width,
                                                               inputViewFrame.size.height + changeInHeight);
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    self.inputView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)atext
{
	if(![textView hasText] && [atext isEqualToString:@""])
    {
        return NO;
	}
    
	if ([atext isEqualToString:@"\n"])
    {
        [self sendPressed:nil
                 withText:[self.inputView.textView.text trimWhitespace]];
        
        [self.inputView.textView setText:nil];
        return NO;
    }
	return YES;
}
#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputView.frame;
                         self.inputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           keyboardY - inputViewFrame.size.height,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
} 
@end
