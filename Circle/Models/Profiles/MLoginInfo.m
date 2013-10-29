//
//  MLoginInfo.m
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "MLoginInfo.h"
#import <CommonCrypto/CommonDigest.h>
#import "MAppStrings.h"
#import "MProfileInfo.h"
#import "UIImageView+WebCache.h"

@implementation MLoginInfo

+ (NSString *)md5HexDigest:(NSString*)string
{
    if(string==nil)return string;
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    NSLog(@"Encryption Result = %@ cut 16:%@",mdfiveString,[mdfiveString substringWithRange:NSMakeRange(8, 16)]);
    return [mdfiveString substringWithRange:NSMakeRange(8, 16)];
}

- (void) login:(NSString *) userid pwd:(NSString *) pwd completed:(ActionCompletedBlock)completedBlock
{
    [self postRequest:API_AUTH_LOGIN_URL before:^(ASIHTTPRequest *request) {
        [(ASIFormDataRequest*)request addPostValue:userid forKey:@"userid"];
        [(ASIFormDataRequest*)request addPostValue:pwd forKey:@"pwd"];
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,hasError);
    }];
}

- (void) logout:(ActionCompletedBlock)completedBlock
{
    [self postRequest:API_AUTH_LOGOUT_URL before:nil completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,hasError);
    }];
}


+ (NSString *)getActiveServer{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    NSString * value = [defaults  objectForKey:@"login.label.current.server"];
    if(value ==nil || value.length ==0){
        return kOFCXMPPServerHost;
    }
    return value;
}
+ (void)setActiveServer:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"login.label.current.server"];
    [defaults synchronize];
}
+ (UInt16 *)getActiveServerPort{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * value = [defaults objectForKey:@"login.label.current.port"];
    if(value ==nil || value.length ==0){
        return (UInt16 *)kOFCXMPPServerPort;
    }
    return (UInt16 *)[value intValue];
}
+ (void)setActiveServerPort:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"login.label.current.port"];
    [defaults synchronize];
}

+ (NSString *)getActiveLoginName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"login.label.current.icd"];
}
+ (void)setActiveLoginName:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"login.label.current.icd"];
    [defaults synchronize];
}
+ (NSString *)getActiveUserName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"login.label.current.name"];
}
+ (void)setActiveUserName:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"login.label.current.name"];
    [defaults synchronize];
}
+ (NSString *)getActiveUserPwd{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"login.label.current.pwd"];
}
+ (void)setActiveUserPwd:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"login.label.current.pwd"];
    [defaults synchronize];
}
+ (NSString *)getActiveNickname{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"login.label.current.nickname"];
}
+ (void)setActiveNickname:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"login.label.current.nickname"];
    [defaults synchronize];
}
+ (NSData *)getActivePhoto{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"register.label.img"];
}
+ (void)setActivePhoto:(NSData *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"register.label.img"];
    [defaults synchronize];
}
+ (BOOL)getActiveUseNick{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey :@"setting.switch.nickname"];
}
+ (void)setActiveUseNick:(BOOL)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:@"setting.switch.nickname"];
    [defaults synchronize];
}
+ (BOOL)getActiveUseReceipts{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"setting.switch.receipts"];
}
+ (void)setActiveUseReceipts:(BOOL)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:@"setting.switch.receipts"];
    [defaults synchronize];
}
+ (NSString *)getActiveUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"login.current.userid"];
}
+ (void)setActiveUserId:(NSString *)userId completed:(ActionCompletedBlock)completedBlock{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userId forKey:@"login.current.userid"];
    [defaults synchronize];
    //login success and update profile for setting
    MProfileInfo *profile = [MProfileInfo alloc];
    [profile get:userId completed:^(NSObject *result, BOOL hasError) {
        if(hasError)return;
        NSDictionary * data  = (NSDictionary *)result;
        if(data==nil || data.count==0)return;
        [MLoginInfo setActiveUserName:[data objectForKey:@"name"]];
        [MLoginInfo setActiveNickname:[data objectForKey:@"nickname"]];
        [MLoginInfo setMyProfileInfo:data];
        [MLoginInfo saveAvatarUrlCache:userId value:[data objectForKey:@"img"]];
        if(completedBlock)completedBlock(result,hasError);
    }];
}

+ (void)setMyProfileInfo:(NSDictionary *)data{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[data objectForKey:@"icd"] forKey:@"register.label.icd"];
    [defaults setObject:[data objectForKey:@"name"] forKey:@"register.label.name"];
    [defaults setObject:[data objectForKey:@"sex"] forKey:@"register.label.sex"];
    [defaults setObject:[data objectForKey:@"major"] forKey:@"register.label.major"];
    [defaults setObject:[data objectForKey:@"org"] forKey:@"register.label.org"];
    [defaults setObject:[data objectForKey:@"model"] forKey:@"register.label.model"];
    [defaults setObject:[data objectForKey:@"city"] forKey:@"register.label.city"];
    [defaults setObject:[data objectForKey:@"sign"] forKey:@"register.label.sign"];
    [defaults setObject:[data objectForKey:@"purpose"] forKey:@"register.label.purpose"];
    [defaults setObject:[data objectForKey:@"email"] forKey:@"register.label.email"];
    [defaults setObject:[data objectForKey:@"mobile"] forKey:@"register.label.mobile"];
    [defaults setObject:[data objectForKey:@"img"] forKey:@"register.label.img"];
    
    [defaults synchronize];
    [MLoginInfo saveAvatarUrlCache:[data objectForKey:@"userid"] value:[data objectForKey:@"img"]];
}
+ (void)clearProfileInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"register.label.icd"];
    [defaults removeObjectForKey:@"register.label.name"];
    [defaults removeObjectForKey:@"register.label.sex"];
    [defaults removeObjectForKey:@"register.label.major"];
    [defaults removeObjectForKey:@"register.label.org"];
    [defaults removeObjectForKey:@"register.label.model"];
    [defaults removeObjectForKey:@"register.label.city"];
    [defaults removeObjectForKey:@"register.label.sign"];
    [defaults removeObjectForKey:@"register.label.purpose"];
    [defaults removeObjectForKey:@"register.label.email"];
    [defaults removeObjectForKey:@"register.label.mobile"];
    [defaults removeObjectForKey:@"register.label.img"];
    [defaults synchronize];
}
+ (BOOL)hasSetting{
	NSString *jid = [MLoginInfo getActiveUserId];
	NSString *pwd = [MLoginInfo getActiveUserPwd];
	NSString *server = [MLoginInfo getActiveServer];
	UInt16 *port = [MLoginInfo getActiveServerPort];
    if(jid == nil || pwd == nil|| server == nil|| port == nil){
        return NO;
    }
    return YES;
}

@end
