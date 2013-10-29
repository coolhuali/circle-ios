//
//  MProfileInfo.h
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "MBaseModel.h"

@interface MProfileInfo : MBaseModel
- (void) exists:(NSString *)key  completed:(ActionCompletedBlock)completedBlock;
- (void) check:(NSMutableArray *)params completed:(ActionCompletedBlock)completedBlock;
- (void) post:(NSString *)userId params:(NSMutableArray *)params completed:(ActionCompletedBlock)completedBlock;
- (void) put:(NSMutableArray *)params completed:(ActionCompletedBlock)completedBlock;
- (void) remove:(NSString *)userId completed:(ActionCompletedBlock)completedBlock;
- (void) list:(NSString *)paramString page:(int)page completed:(ActionCompletedBlock)completedBlock;
- (void) get:(NSString *)userId completed:(ActionCompletedBlock)completedBlock;
- (void) postAvatar:(NSString *)userid image:(NSData *) photo completed:(ActionCompletedBlock)completedBlock;
- (void) updateCache:(NSString *)userid completed:(ActionCompletedBlock)completedBlock;

@end
