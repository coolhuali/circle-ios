//
//  MLoginInfo.h
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "MBaseModel.h"

@interface MLoginInfo : MBaseModel
+ (NSString *)md5HexDigest:(NSString*)string;

+ (NSString *)getActiveLoginName;
+ (void)setActiveLoginName:(NSString *)value;

+ (NSString *)getActiveUserName;
+ (void)setActiveUserName:(NSString *)value;

+ (NSString *)getActiveUserPwd;
+ (void)setActiveUserPwd:(NSString *)value;

+ (NSString *)getActiveServer;
+ (void)setActiveServer:(NSString *)value;

+ (UInt16 *)getActiveServerPort;
+ (void)setActiveServerPort:(NSString *)value;

+ (NSString *)getActiveNickname;
+ (void)setActiveNickname:(NSString *)value;

+ (NSData *)getActivePhoto;
+ (void)setActivePhoto:(NSData *)value;

+ (BOOL)getActiveUseNick;
+ (void)setActiveUseNick:(BOOL)value;

+ (BOOL)getActiveUseReceipts;
+ (void)setActiveUseReceipts:(BOOL)value;

+ (NSString *)getActiveUserId;
+ (void)setActiveUserId:(NSString *)userId completed:(ActionCompletedBlock)completedBlock;

+ (BOOL)hasSetting;
+ (void)setMyProfileInfo:(NSDictionary *)data;

+ (void)clearProfileInfo;
- (void) login:(NSString *) userid pwd:(NSString *) pwd completed:(ActionCompletedBlock)completedBlock;
- (void) logout:(ActionCompletedBlock)completedBlock;
@end
