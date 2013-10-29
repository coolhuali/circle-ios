//
//  OFCImageSetting.h
//  OpenFireClient
//
//  Created by admin on 13-9-26.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFCValueSetting.h"

@interface OFCImageSetting : OFCValueSetting


- (id) initWithText:(NSString*)newTitle value:(NSString*)newValue;
- (id) initWithText:(NSString*)newTitle value:(NSString*)newValue useKey:(BOOL)useKey;
- (id) initWithText:(NSString*)newTitle value:(NSString*)newValue description:(NSString*)newDescription;

@end
