//
//  MBaseModel.h
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "MAppStrings.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "OFCXMPPManager.h"

#define DEFAULT_PAGE_SIZE 20

typedef NS_ENUM(NSInteger, MDataOperator) {
    MDataOperatorForNone,
    MDataOperatorForAdd,
    MDataOperatorForUpdate,
    MDataOperatorForRemove,
    MDataOperatorForMove
};
typedef void(^ActionBeforeBlock)(ASIHTTPRequest *request);

typedef void(^ActionCompletedBlock)(NSObject *result,BOOL hasError);

typedef void(^ActionPushBlock)(NSObject *result,MDataOperator mDataOperator,BOOL hasError);

@interface MBaseModel : NSObject

@property (nonatomic, strong) NSString *currentUserId;
+ (void)findForArray:(NSArray *)array target:(NSDictionary *)target forKey:(NSString *)key replaceKeys:(NSArray *)keys;
+ (BOOL)containObjectInArray:(NSArray *)array target:(NSDictionary*)target forKey:(NSString *)key;
+ (BOOL)containValueInArray:(NSArray *)array forKey:(NSString *)key value:(NSString *)value;
+ (void)saveAvatarUrlCache:(NSString *)key value:(NSString *)value;
+ (void)saveBatchAvatarUrlCache:(NSArray *)array;
+ (NSURL *)getAvatarUrlCache:(NSString *)key;
+ (void)saveNameCache:(NSString *)key value:(NSString *)value;
+ (void)saveBatchNameCache:(NSArray *)array;
+ (NSString *)getNameCache:(NSString *)key;

- (NSString *)md5HexDigest:(NSString*)string;

-(void) getRequest:(NSString *)urlString before:(ActionBeforeBlock)beforeBlock completed:(ActionCompletedBlock)completedBlock;
-(void) postRequest:(NSString *)urlString before:(ActionBeforeBlock)beforeBlock completed:(ActionCompletedBlock)completedBlock;
-(void) putRequest:(NSString *)urlString before:(ActionBeforeBlock)beforeBlock completed:(ActionCompletedBlock)completedBlock;
-(void) deleteRequest:(NSString *)urlString before:(ActionBeforeBlock)beforeBlock completed:(ActionCompletedBlock)completedBlock;

- (void) uploadImage:(NSData *) photo progress:(id)progressDelegate completed:(ActionCompletedBlock)completedBlock;
- (void) uploadSound:(NSString *)filePath progress:(id)progressDelegate completed:(ActionCompletedBlock)completedBlock;

@end
