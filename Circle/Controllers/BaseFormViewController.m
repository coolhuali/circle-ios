//
//  BaseViewController.m
//  OpenFireClient
//
//  Created by admin on 13-6-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "BaseFormViewController.h"
#import "UIView+AnimationOptionsForCurve.h"

#define INPUT_HEIGHT 60.0f
@interface BaseFormViewController ()

@end

@implementation BaseFormViewController

@synthesize settingsTableView;
@synthesize currentTextField;
@synthesize keyboardToolbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Keyboard toolbar
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"previous", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
    }
	// Do any additional setup after loading the view.
    self.settingsTableView = [self buildCustomTableView];
    self.settingsTableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[self.settingsTableView setBackgroundView:nil];
    //[self.settingsTableView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview: self.settingsTableView];
    
}
-(UITableView*)buildCustomTableView
{
    return [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
}
-(void)setUIAccessoryView:(UIView *)target{
    if([target isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)target;
        textField.inputAccessoryView = self.keyboardToolbar;
    }
    itemCount++;
    target.tag = itemCount;
}
- (void)viewWillAppear:(BOOL)animated
{  
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        [self animateView:1];
        [self resetLabelsColors:nil];
    }
}


- (id)getNextInputTextField:(NSUInteger)tag{
    NSUInteger index = tag;
    while (index <= itemCount) {
        UIView *textField = (UIView *)[self.view viewWithTag:index];
        if (textField && [textField  isKindOfClass:[UITextField class]]) {
            return textField;
        }
        index++;
    }
    return NO;
}
- (id)getPreviousInputTextField:(NSUInteger)tag{
    NSUInteger index = tag;
    while (index >0) {
        UIView *textField = (UIView *)[self.view viewWithTag:index];
        if (textField && [textField  isKindOfClass:[UITextField class]]) {
            return textField;
        }
        index--;
    }
    return NO;
}
- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if(firstResponder==nil)return;
    UIView *target = (UIView*)firstResponder;
    NSUInteger tag = target.tag;
    NSUInteger previousTag = tag - 1;//== FIELDS_COUNT ? FIELDS_COUNT : tag - 1;
    [self checkBarButton:previousTag];
    [self animateView:previousTag];
    UIView *previous = (UIView *)[self getPreviousInputTextField:previousTag];//[self.view viewWithTag:previousTag];
    if(previous){
        [previous becomeFirstResponder];
        [self checkSpecialFields:previousTag];
    }
    /**
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [(UITextField*)firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        if(previousField)
        {
            [previousField becomeFirstResponder];
            UILabel *nextLabel = (UILabel *)[self.view viewWithTag:previousTag + 10];
            if (nextLabel) {
                [self resetLabelsColors:nextLabel];
            }
            [self checkSpecialFields:previousTag];
        }
    }**/
}
- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if(firstResponder==nil)return;
    UIView *target = (UIView*)firstResponder;
    NSUInteger tag = target.tag;
    NSUInteger nextTag = tag == itemCount ? itemCount : tag + 1;
    [self checkBarButton:nextTag];
    [self animateView:nextTag];
    UIView *next = (UIView *)[self getNextInputTextField:nextTag];//(UIView *)[self.view viewWithTag:nextTag];
    if(next){
        [next becomeFirstResponder];
        [self checkSpecialFields:nextTag];
    }
    /**
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag =[(UITextField*)firstResponder tag];
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        if(nextField){
            [nextField becomeFirstResponder];
            [self checkSpecialFields:nextTag];
        }
    }**/
}

- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= itemCount) {
        UIView *textField = (UIView *)[self.view viewWithTag:index];
        if (textField && [textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 3) {
        rect.origin.y = -44.0f * (tag - 3);
    } else {
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == itemCount ? NO : YES];
}

- (void)checkSpecialFields:(NSUInteger)tag
{
     
}

- (void)resetLabelsColors:(UILabel *)label
{
    
}

#pragma mark - OFCSettingDelegate

- (void)customBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    [self checkSpecialFields:tag];
    UILabel *label = (UILabel *)[self.view viewWithTag:tag + 10];
    if (label) {
        [self resetLabelsColors:label];
    }
}
 
//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
//要想在用户结束编辑时阻止文本字段消失，可以返回NO
//这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
- (void)customEndEditing:(UITextField *)textField{
     
}
- (void)customShouldReturn:(UITextField *)textField
{ 
    [self resignKeyboard:textField];
}
#pragma mark -
#pragma mark OFCSettingDelegate
- (void)refreshView
{
    [self.settingsTableView reloadData];
}
- (void) showDetailViewControllerClass:(OFCSetting *)setting viewControllerClass:(Class)viewControllerClass
{
    
}
- (void) setActiveTextField:(UITextField *)textField
{
    self.currentTextField = textField;
}
@end
