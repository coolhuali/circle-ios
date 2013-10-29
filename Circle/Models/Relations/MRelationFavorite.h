//
//  MRelationFavorite.h
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//
 
#import "MBaseModel.h"

@interface MRelationFavorite : MBaseModel
- (void) post:(NSString *)userId completed:(ActionCompletedBlock)completedBlock;
- (void) remove:(NSString *)userId completed:(ActionCompletedBlock)completedBlock;
- (void) list:(int)page completed:(ActionCompletedBlock)completedBlock;
@end
