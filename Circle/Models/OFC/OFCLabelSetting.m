//
//  OFCLabelSetting.m
//  OpenFireClient
//
//  Created by admin on 13-9-24.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "OFCLabelSetting.h"

@implementation OFCLabelSetting  

- (id) initWithText:(NSString*)newTitle value:(NSString*)newValue
{ 
    return [self initWithText:newTitle value:newValue useKey:YES];
}
- (id) initWithText:(NSString*)newTitle value:(NSString*)newValue useKey:(BOOL)useKey
{
    if (self = [super initWithTitle:newTitle description:nil settingsKey:useKey?newTitle:nil])
    {
        [self setValue:newValue];
    }
    return self;
}
- (id) initWithText:(NSString*)newTitle value:(NSString*)newValue description:(NSString*)newDescription
{
    if (self = [super initWithTitle:newTitle description:newDescription settingsKey:newTitle])
    {
        [self setValue:newValue];
    }
    return self;
}
@end
