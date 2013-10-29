//
//  MProfileInfo.m
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "MProfileInfo.h" 

@implementation MProfileInfo

- (void) exists:(NSString *)key completed:(ActionCompletedBlock)completedBlock
{
    [self getRequest:[NSString stringWithFormat:API_PROFILE_EXISTS_URL,key] before:nil completed:^(NSObject *result, BOOL hasError) {
        if (completedBlock) completedBlock(result,hasError);
    }];
}

- (void) check:(NSMutableArray *) params completed:(ActionCompletedBlock)completedBlock
{
    [self postRequest:API_PROFILE_CHECK_URL before:^(ASIHTTPRequest *request) {
        [(ASIFormDataRequest*)request addPostValue:params];
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,hasError);
    }]; 
}

- (void) postAvatar:(NSString *)userid image:(NSData *) photo completed:(ActionCompletedBlock)completedBlock
{
    [self postRequest:API_UPLOAD_AVATAR_URL before:^(ASIHTTPRequest *request) {
        ASIFormDataRequest *_request = (ASIFormDataRequest*)request;
        [_request setData:photo forKey:@"file"];
        [_request addPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)photo.length] forKey:@"length"];
        [_request addPostValue:userid forKey:@"author"];
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,hasError);
    }];
}
- (void) post:(NSString *)userId params:(NSMutableArray *) params completed:(ActionCompletedBlock)completedBlock
{
    [self postRequest:[NSString stringWithFormat:API_PROFILE_ADD_URL,userId] before:^(ASIHTTPRequest *request) {
        [(ASIFormDataRequest*)request addPostValue:params];
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,hasError);
    }];
}

- (void) put:(NSMutableArray *) params completed:(ActionCompletedBlock)completedBlock
{
    [self putRequest:[NSString stringWithFormat:API_PROFILE_EDIT_URL] before:^(ASIHTTPRequest *request) {
        [(ASIFormDataRequest*)request addPostValue:params];
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,[@"false" isEqual:result]);
    }];
}

- (void) remove:(NSString *)userId completed:(ActionCompletedBlock)completedBlock
{
    [self deleteRequest:[NSString stringWithFormat:API_PROFILE_DELETE_URL,userId] before:nil completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,[@"false" isEqual:result]);
    }];
}

- (void) list:(NSString *)paramString page:(int)page completed:(ActionCompletedBlock)completedBlock
{
    if(paramString==nil)paramString=@"";
    [self getRequest:[NSString stringWithFormat:API_PROFILE_SEARCH_URL,[NSString stringWithFormat:@"%d",page],paramString] before:nil completed:^(NSObject *result, BOOL hasError) {
        if(hasError && completedBlock){
            completedBlock(result,hasError);
        }else{
            NSError *error = nil;
            NSObject * data = [(NSString*)result objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode error:&error];
            if([data isKindOfClass:[NSArray class]]){
                [MBaseModel saveBatchNameCache:(NSArray *)data];
                [MBaseModel saveBatchAvatarUrlCache:(NSArray *)data];
                if (completedBlock)completedBlock(data,NO);
            }else{
                if (completedBlock)completedBlock(result,YES);
            }
        }
    }];
}

- (void) get:(NSString *)userId completed:(ActionCompletedBlock)completedBlock
{
    [self getRequest:[NSString stringWithFormat:API_PROFILE_GET_URL,userId] before:nil completed:^(NSObject *result, BOOL hasError) {
        if(result){
            NSError *error = nil;
            NSDictionary * data = [(NSString*)result objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode error:&error];
            if (completedBlock)completedBlock(data,NO);
        }else{
            if (completedBlock)completedBlock(result,YES);
        }
    }];
}
- (void) updateCache:(NSString *)userid completed:(ActionCompletedBlock)completedBlock{
    if([MProfileInfo getNameCache:userid]==nil){
        [self get:userid completed:^(NSObject *result, BOOL hasError) {
            if(hasError){
                if(completedBlock)completedBlock(result,YES);
            }
            NSDictionary *dict = (NSDictionary*)result;
            [MBaseModel saveNameCache:userid value:[dict objectForKey:@"name"]];
            [MBaseModel saveAvatarUrlCache:userid value:[dict objectForKey:@"img"]];
            if(completedBlock)completedBlock(result,NO);
        }];
    }
}
@end
