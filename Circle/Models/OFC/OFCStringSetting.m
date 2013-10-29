//
//  OFCStringSetting.m
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCStringSetting.h"

@implementation OFCStringSetting
@synthesize placeholder;

- (id) initWithText:(NSString *)newTitle placeholder:(NSString *)newPlaceholder
{
    if (self = [super initWithTitle:newTitle description:nil settingsKey:newTitle])
    {
        self.placeholder = NSLocalizedString(newPlaceholder, nil);
        self.action = @selector(input:);
    }
    return self;
}
- (id) initWithText:(NSString *)newTitle placeholder:(NSString *)newPlaceholder description:(NSString *)newDescription
{
    if (self = [super initWithTitle:newTitle description:newDescription settingsKey:newTitle])
    {
        self.placeholder = NSLocalizedString(newPlaceholder, nil);
        self.action = @selector(input:);
    }
    return self;
}

- (id) initWithText:(NSString *)newTitle placeholder:(NSString *)newPlaceholder description:(NSString *)newDescription settingsKey:(NSString *)newSettingsKey
{
    if (self = [super initWithTitle:newTitle description:newDescription settingsKey:newSettingsKey])
    {
        self.placeholder = NSLocalizedString(newPlaceholder, nil);
        self.action = @selector(input:);
    }
    return self;
}

- (id) initWithTitle:(NSString *)newTitle description:(NSString *)newDescription settingsKey:(NSString *)newSettingsKey
{
    if (self = [super initWithTitle:newTitle description:newDescription settingsKey:newSettingsKey])
    {
        self.action = @selector(input:);
    }
    return self;
}
- (void)input:(UITextField *)textField
{
    [self setValue: textField.text];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.delegate setActiveTextField:textField];
    [self.delegate customBeginEditing:textField];
    return YES;
}
//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
//要想在用户结束编辑时阻止文本字段消失，可以返回NO
//这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self input:textField];
    [self.delegate customEndEditing:textField];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self input:textField];
    [self.delegate customShouldReturn:textField];
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self input:textField];
    return YES;
}
@end
