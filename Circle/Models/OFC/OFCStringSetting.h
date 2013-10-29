//
//  OFCStringSetting.h
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCValueSetting.h"

@interface OFCStringSetting : OFCValueSetting <UITextFieldDelegate>{
    
    NSString *placeholder;
}

@property (nonatomic, strong) NSString *placeholder; 
- (id) initWithText:(NSString *)newTitle placeholder:(NSString *)newPlaceholder;
- (id) initWithText:(NSString *)newTitle placeholder:(NSString *)newPlaceholder description:(NSString *)newDescription;
- (id) initWithText:(NSString *)newTitle placeholder:(NSString *)newPlaceholder description:(NSString *)newDescription settingsKey:(NSString *)newSettingsKey;
@end
