//
//  MBaseModel.m
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "MBaseModel.h"
#import "MLoginInfo.h"
 
@implementation MBaseModel
+ (void)findForArray:(NSArray *)array target:(NSDictionary *)target forKey:(NSString *)key replaceKeys:(NSArray *)keys
{
    if(!array || array.count==0)return;
    for (NSDictionary *dict in array) {
        if(![dict isKindOfClass:[NSDictionary class]])continue;
        if ([[dict objectForKey:key] isEqualToString:[target objectForKey:key]]) {
            for (NSString *replaceKey in keys) {
                [dict setValue:[target objectForKey:replaceKey] forKey:replaceKey];
            }
        }
    }
}
+ (BOOL)containObjectInArray:(NSArray *)array target:(NSDictionary*)target forKey:(NSString *)key
{
    if(!array || array.count==0)return NO;
    for (NSDictionary *dict in array) {
        if(![dict isKindOfClass:[NSDictionary class]])continue;
        if ([[dict objectForKey:key] isEqual:[target objectForKey:key]]) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)containValueInArray:(NSArray *)array forKey:(NSString *)key value:(NSString *)value
{
    if(!array || array.count==0)return NO;
    for (NSDictionary *dict in array) {
        if(![dict isKindOfClass:[NSDictionary class]])continue;
        if ([[dict objectForKey:key] isEqualToString:value]) {
            return YES;
        }
    }
    return NO;
}
+ (void)saveAvatarUrlCache:(NSString *)key value:(NSString *)value
{
    if(key==nil || value==nil)return;
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:value forKey:[NSString stringWithFormat:@"cache-avatar-url-%@",[key lowercaseString]]];
    [setting synchronize];
}
+ (void)saveBatchAvatarUrlCache:(NSArray *)array
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if(array && array.count>0){
        for(int i=0;i<array.count;i++){
            NSDictionary *obj = (NSDictionary*)array[i];
            if([obj objectForKey:@"img"]==nil)continue;
            NSString *key = [obj objectForKey:@"userid"];
            [setting setObject:[obj objectForKey:@"img"] forKey:[NSString stringWithFormat:@"cache-avatar-url-%@",[key lowercaseString]]];
        }
    }
    [setting synchronize];
}
+ (NSURL *)getAvatarUrlCache:(NSString *)key
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *value = [settings objectForKey:[NSString stringWithFormat:@"cache-avatar-url-%@",[key lowercaseString]]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_DOWN_IMAGE_URL,value]];
    return url;
}

+ (void)saveNameCache:(NSString *)key value:(NSString *)value
{
    if(key==nil || value==nil)return;
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:value forKey:[NSString stringWithFormat:@"cache-name-%@",[key lowercaseString]]];
    [setting synchronize];
}
+ (void)saveBatchNameCache:(NSArray *)array
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if(array && array.count>0){
        for(int i=0;i<array.count;i++){
            NSDictionary *obj = (NSDictionary*)array[i];
            if([obj objectForKey:@"name"]==nil)continue;
            NSString *key = [obj objectForKey:@"userid"];
            [setting setObject:[obj objectForKey:@"name"] forKey:[NSString stringWithFormat:@"cache-name-%@",[key lowercaseString]]];
        }
    }
    [setting synchronize];
}
+ (NSString *)getNameCache:(NSString *)key
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *value = [settings objectForKey:[NSString stringWithFormat:@"cache-name-%@",[key lowercaseString]]];
    return value;
}
- (NSString *)md5HexDigest:(NSString*)string
{
    return [MLoginInfo md5HexDigest:string];
}
-(void) getRequest:(NSString *)urlString before:(ActionBeforeBlock)beforeBlock completed:(ActionCompletedBlock)completedBlock{
    NSLog(@"current getRequest[%@]",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    if(beforeBlock)beforeBlock(request);
    [request setCompletionBlock :^{
        NSString *result = [request responseString];
        NSLog(@"current resopnse:%@",result);
        if([request responseStatusCode]==200){
            if(completedBlock) completedBlock(result,NO);
        }else{
            if(completedBlock) completedBlock(result,YES);
        }
    }];
    [request setFailedBlock :^{
        if (completedBlock) completedBlock(nil,YES);
        // 请求响应失败，返回错误信息
        [UIHelper alert:@"error.title" content:@"error.request.tip" usingLocalized:YES];
    }];
    [request startAsynchronous ];
}

-(void) deleteRequest:(NSString *)urlString before:(ActionBeforeBlock)beforeBlock completed:(ActionCompletedBlock)completedBlock{
    NSLog(@"current deleteRequest[%@]",urlString); 
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"DELETE"];
    if(beforeBlock)beforeBlock(request);
    [request setCompletionBlock :^{
        NSString *result = [request responseString];
        NSLog(@"current resopnse:%@",result);
        if([request responseStatusCode]==200){
            if(completedBlock) completedBlock(result,NO);
        }else{
            if(completedBlock) completedBlock(result,YES);
        }
    }];
    [request setFailedBlock :^{
        if (completedBlock) completedBlock(nil,YES);
        // 请求响应失败，返回错误信息
        [UIHelper alert:@"error.title" content:@"error.request.tip" usingLocalized:YES];
    }];
    [request startAsynchronous ];
}
-(void) postRequest:(NSString *)urlString before:(ActionBeforeBlock)beforeBlock completed:(ActionCompletedBlock)completedBlock{
    NSLog(@"current postRequest[%@]",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if(beforeBlock)beforeBlock(request);
    [request setCompletionBlock :^{
        NSString *result = [request responseString];
        NSLog(@"current resopnse:%@",result);
        if([request responseStatusCode]==200){
            if(completedBlock) completedBlock(result,NO);
        }else{
            if(completedBlock) completedBlock(result,YES);
        }
    }];
    [request setFailedBlock :^{
        if (completedBlock) completedBlock(nil,YES);
        // 请求响应失败，返回错误信息
        [UIHelper alert:@"error.title" content:@"error.request.tip" usingLocalized:YES];
    }];
    [request startAsynchronous ];
}

-(void) putRequest:(NSString *)urlString before:(ActionBeforeBlock)beforeBlock completed:(ActionCompletedBlock)completedBlock{
    NSLog(@"current putRequest[%@]",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"PUT"];
    if(beforeBlock)beforeBlock(request);
    [request setCompletionBlock :^{
        NSString *result = [request responseString];
        NSLog(@"current resopnse:%@",result);
        if([request responseStatusCode]==200){
            if(completedBlock) completedBlock(result,NO);
        }else{
            if(completedBlock) completedBlock(result,YES);
        }
    }];
    [request setFailedBlock :^{
        if (completedBlock) completedBlock(nil,YES);
        // 请求响应失败，返回错误信息
        [UIHelper alert:@"error.title" content:@"error.request.tip" usingLocalized:YES];
    }];
    [request startAsynchronous ];
}

- (void) uploadImage:(NSData *) photo progress:(id)progressDelegate completed:(ActionCompletedBlock)completedBlock
{
    [self postRequest:API_UPLOAD_IMAGE_URL before:^(ASIHTTPRequest *request) {
        ASIFormDataRequest *_request = (ASIFormDataRequest*)request;
        if(progressDelegate!=nil){
            _request.showAccurateProgress=YES;
            [_request setUploadProgressDelegate:progressDelegate];
        }
        [_request setData:photo forKey:@"file"];
        [_request addPostValue:@"png" forKey:@"ext"];
        [_request addPostValue:[NSString stringWithFormat:@"image_%lu",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"name"];
        [_request addPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)photo.length] forKey:@"length"];
        [_request addPostValue:[MLoginInfo getActiveUserId] forKey:@"author"];
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,hasError);
    }];
}

- (void) uploadSound:(NSString *)filePath progress:(id)progressDelegate completed:(ActionCompletedBlock)completedBlock
{
    [self postRequest:API_UPLOAD_AUDIO_URL before:^(ASIHTTPRequest *request) {
        NSFileManager * fm = [NSFileManager defaultManager];
        //创建缓冲区，利用NSFileManager对象来获取文件中的内容，也就是这个文件的属性可修改
        NSData * fileData = [fm contentsAtPath:filePath];
        ASIFormDataRequest *_request = (ASIFormDataRequest*)request;
        if(progressDelegate!=nil){
            _request.showAccurateProgress=YES;
            [_request setUploadProgressDelegate:progressDelegate];
        }
        [_request addPostValue:[NSString stringWithFormat:@"sound_%lu",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"name"];
        [_request addPostValue:@"mp3" forKey:@"ext"];
        [_request setData:fileData forKey:@"file"];
        [_request addPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)fileData.length] forKey:@"length"];
        [_request addPostValue:[MLoginInfo getActiveUserId] forKey:@"author"];
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,hasError);
    }];
}

@end
