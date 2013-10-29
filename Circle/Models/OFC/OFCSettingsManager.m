//
//  OFCSettingsManager.m
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCSettingsManager.h"
#import "OFCBoolSetting.h"
#import "OFCStringSetting.h"
#import "OFCSettingsGroup.h"
#import "MAppStrings.h"
@implementation OFCSettingsManager
@synthesize settingsGroups ;
@synthesize settingsDictionary ;

- (id) init
{
    if (self = [super init])
    {
        settingsGroups = [NSMutableArray array];
        [self populateSettings];
    }
    return self;
}
- (void) populateSettings
{
    OFCStringSetting *userNameSetting = [[OFCStringSetting alloc]initWithText:@"login.label.current.icd" placeholder:@"login.label.current.icd.placeholder"];
     
    OFCStringSetting *passwordStringSetting = [[OFCStringSetting alloc]initWithText:@"login.label.current.pwd" placeholder:@"login.label.current.pwd.placeholder"];
    
    OFCStringSetting *serverStringSetting = [[OFCStringSetting alloc]initWithText:@"login.label.current.server" placeholder:@"login.label.current.server.placeholder"];
    
     
    OFCStringSetting *portStringSetting = [[OFCStringSetting alloc] initWithText:@"login.label.current.port" placeholder:@"login.label.current.port.placeholder"];
    
    
    OFCSettingsGroup *loginSettingsGroup = [[OFCSettingsGroup alloc] initWithTitle:@"setting.title.login" settings:[NSArray arrayWithObjects:userNameSetting,passwordStringSetting,serverStringSetting,portStringSetting, nil]];
    [settingsGroups addObject:loginSettingsGroup];
    
    OFCBoolSetting *useNickNameSetting = [[OFCBoolSetting alloc]initWithTitle:@"setting.switch.nickname" description:nil settingsKey:@"setting.switch.nickname"];
    
    OFCStringSetting *nickNameStringSetting = [[OFCStringSetting alloc]initWithText:@"login.label.current.nickname"  placeholder:@"login.label.current.nickname.placeholder"];
    
    OFCBoolSetting *allowReceptionAndRequest = [[OFCBoolSetting alloc]initWithTitle:@"setting.switch.receipts" description:nil settingsKey:@"setting.switch.receipts"];
    
    OFCSettingsGroup *chatSettingsGroup = [[OFCSettingsGroup alloc] initWithTitle:@"setting.title.chat" settings:[NSArray arrayWithObjects:useNickNameSetting,nickNameStringSetting,allowReceptionAndRequest, nil]];
    
    [settingsGroups addObject:chatSettingsGroup];
}

- (NSUInteger) numberOfSettingsInSection:(NSUInteger)section
{
    OFCSettingsGroup *settingsGroup = [settingsGroups objectAtIndex:section];
    return [settingsGroup.settings count];
}

- (OFCSetting*) settingAtIndexPath:(NSIndexPath*)indexPath
{
    OFCSettingsGroup *settingsGroup = [settingsGroups objectAtIndex:indexPath.section];
    return [settingsGroup.settings objectAtIndex:indexPath.row];
}

- (NSString*) stringForGroupInSection:(NSUInteger)section
{
    OFCSettingsGroup *settingsGroup = [settingsGroups objectAtIndex:section];
    return settingsGroup.title;
} 
@end
