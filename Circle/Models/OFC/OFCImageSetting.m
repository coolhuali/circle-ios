//
//  OFCImageSetting.m
//  OpenFireClient
//
//  Created by admin on 13-9-26.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "OFCImageSetting.h"

@implementation OFCImageSetting

- (id) initWithText:(NSString*)newTitle value:(NSString*)newValue
{
    if (self = [super initWithTitle:newTitle description:nil settingsKey:newTitle])
    {
        if(newValue)
        [self setValue:newValue];
    }
    return self;
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
        if(newValue)
        [self setValue:newValue];
    }
    return self;
}
@end
