//
//  OFCSetting.m
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCSetting.h"

@implementation OFCSetting
@synthesize title;
@synthesize description;
@synthesize imageName;
@synthesize action;
@synthesize delegate;

- (id) initWithTitle:(NSString *)newTitle description:(NSString *)newDescription
{
    self = [super init];
    if(self){ 
        title = NSLocalizedString(newTitle, nil);
        description =  NSLocalizedString(newDescription, nil);
    }
    return self;
} 

@end
