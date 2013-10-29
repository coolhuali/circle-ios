//
//  NSDate+XMPPDateTimeProfiles.m
//
//  NSDate category to implement XEP-0082.
//
//  Created by Eric Chamberlain on 3/9/11.
//  Copyright 2011 RF.com. All rights reserved.
//  Copyright 2010 Martin Morrison. All rights reserved.
//

#import "NSDate+XMPPDateTimeProfiles.h"
#import "XMPPDateTimeProfiles.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@interface NSDate(XMPPDateTimeProfilesPrivate)
- (NSString *)xmppStringWithDateFormat:(NSString *)dateFormat;
@end

#pragma mark -

@implementation NSDate(XMPPDateTimeProfiles)


#pragma mark Convert from XMPP string to NSDate


+ (NSDate *)dateWithXmppDateString:(NSString *)str {
  return [XMPPDateTimeProfiles parseDate:str];
}


+ (NSDate *)dateWithXmppTimeString:(NSString *)str {
  return [XMPPDateTimeProfiles parseTime:str];
}


+ (NSDate *)dateWithXmppDateTimeString:(NSString *)str {
  return [XMPPDateTimeProfiles parseDateTime:str];
}
#pragma mark Convert from NSDate to XMPP string


- (NSString *)xmppDateString {	
	return [self xmppStringWithDateFormat:@"yyyy-MM-dd"];
}


- (NSString *)xmppTimeString {
	return [self xmppStringWithDateFormat:@"HH:mm:ss"];
}


- (NSString *)xmppDateTimeString {
	return [self xmppStringWithDateFormat:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)xmppDateTimeLongString {
	return [self xmppStringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)xmppDisplayDateTimeString{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    
    NSDate * yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    //The day before yesterday
    NSDate * yesterday2 = [today dateByAddingTimeInterval: -secondsPerDay -secondsPerDay];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp0 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:today];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:yesterday];
    NSDateComponents* comp3 = [calendar components:unitFlags fromDate:yesterday2];
    if([comp0 day]   == [comp1 day] &&
       [comp0 month] == [comp1 month] &&
       [comp0 year]  == [comp1 year]){
        NSTimeInterval secondsInterval = [today timeIntervalSinceDate:self];
        if(secondsInterval<5*60){
            return NSLocalizedString(@"time.now.title", nil);
        }
        if(secondsInterval<60*60){
            return [NSString stringWithFormat:@"%d%@",(int)secondsInterval/60,NSLocalizedString(@"time.minute.title", nil)];
        }
        if(secondsInterval>=60*60){
            return [NSString stringWithFormat:@"%d%@",(int)secondsInterval/60/60,NSLocalizedString(@"time.hour.title", nil)];
        }
        return NSLocalizedString(@"time.today.title", nil);
    }
    else if([comp0 day]   == [comp2 day] &&
        [comp0 month] == [comp2 month] &&
            [comp0 year]  == [comp2 year]){
        return NSLocalizedString(@"time.yesterday.title", nil);
    }
    else if([comp0 day]   == [comp3 day] &&
       [comp0 month] == [comp3 month] &&
            [comp0 year]  == [comp3 year]){
        return NSLocalizedString(@"time.beforeyesterday.title", nil);
    }
	return [self xmppStringWithDateFormat:@"yy/MM/dd HH:mm"];
}

#pragma mark XMPPDateTimeProfilesPrivate methods


- (NSString *)xmppStringWithDateFormat:(NSString *)dateFormat
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:dateFormat];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];
	
	NSString *str = [dateFormatter stringFromDate:self];
	
	return str;
}


@end
