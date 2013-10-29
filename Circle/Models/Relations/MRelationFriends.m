//
//  MRelationFriends.m
//  OpenFireClient
//
//  Created by admin on 13-9-28.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "MRelationFriends.h"

@implementation MRelationFriends

- (void) post:(NSString *)userId completed:(ActionCompletedBlock)completedBlock
{
    [self postRequest:[NSString stringWithFormat:API_RELATION_FRIENDS_ADD_URL] before:^(ASIHTTPRequest *request) {
        [(ASIFormDataRequest*)request addPostValue:userId forKey:@"userid"];
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,[@"true" isEqual:result]);
    }];
}

- (void) remove:(NSString *)userId completed:(ActionCompletedBlock)completedBlock
{
    [self deleteRequest:[NSString stringWithFormat:API_RELATION_FRIENDS_DELETE_URL,userId] before:nil completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,[@"false" isEqual:result]);
    }];
}

- (void) list:(int)page completed:(ActionCompletedBlock)completedBlock
{
    [self getRequest:[NSString stringWithFormat:API_RELATION_FRIENDS_LIST_URL,[NSString stringWithFormat:@"%d",page]] before:nil completed:^(NSObject *result, BOOL hasError) {
        if(hasError && completedBlock){
            completedBlock(result,hasError);
        }else{
            NSError *error = nil;
            NSArray * data = [(NSString*)result objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode error:&error];
            if([data isKindOfClass:[NSArray class]]){
                if (completedBlock)completedBlock(data,NO);
            }else{
                if (completedBlock)completedBlock(result,YES);
            }
        }
    }];
}
@end


