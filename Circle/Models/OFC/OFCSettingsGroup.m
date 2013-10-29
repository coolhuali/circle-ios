//
//  OFCSettingsGroup.m
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCSettingsGroup.h"
#import "OFCSetting.h"
#import "OFCValueSetting.h"
#import "OFCImageSetting.h"

@implementation OFCSettingsGroup
@synthesize title = _title;
@synthesize settings = _settings;
- (void) dealloc
{
    _title = nil;
    _settings = nil;
}

- (id) initWithTitle:(NSString*)newTitle settings:(NSArray*)newSettings
{
    if (self = [super init])
    {
        _title = NSLocalizedString(newTitle, nil);
        _settings = newSettings;
    }
    return self;
}

- (OFCValueSetting *) objectForKey:(NSString *)key
{
    NSUInteger i;
    for (i=0; i<[_settings count]; i++)
    {
        NSObject *item = [_settings objectAtIndex:i];
        if([item isKindOfClass:[OFCValueSetting class]]){
            OFCValueSetting *kv = (OFCValueSetting*)item;
            if([kv.key isEqualToString:key])
                return kv;
        }
	}
    return nil;
}

- (NSMutableArray *) buildParams
{
    NSMutableArray *params = [NSMutableArray array];
    NSUInteger i;
    for (i=0; i<[_settings count]; i++)
    {
        NSObject *item = [_settings objectAtIndex:i];
        if(![item isKindOfClass:[OFCImageSetting class]] && [item isKindOfClass:[OFCValueSetting class]]){
            OFCValueSetting *kv = (OFCValueSetting*)item;
            NSMutableDictionary *keyValuePair = [NSMutableDictionary dictionaryWithCapacity:2]; 
            [keyValuePair setValue:[[kv.key componentsSeparatedByString:@"."] lastObject] forKey:@"key"];
            [keyValuePair setValue:kv.value==nil?@"":kv.value forKey:@"value"];
            [params addObject:keyValuePair];
        }
	}
    return params;
}

- (NSString *) buildParamsString
{
    NSMutableString *params = [[NSMutableString alloc] init];
    NSUInteger i;
    for (i=0; i<[_settings count]; i++)
    {
        NSObject *item = [_settings objectAtIndex:i];
        if(![item isKindOfClass:[OFCImageSetting class]] && [item isKindOfClass:[OFCValueSetting class]]){
            OFCValueSetting *kv = (OFCValueSetting*)item;
            if(kv.value==nil)continue;
            if(i>0)[params appendString:@"&"];
            [params appendString:[NSString stringWithFormat:@"%@=%@",[[kv.key componentsSeparatedByString:@"."] lastObject],kv.value]];
        }
	}
    return [[NSString alloc] initWithUTF8String:[params UTF8String]];
}
@end
