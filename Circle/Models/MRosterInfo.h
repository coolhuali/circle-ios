//
//  MRosterInfo.h
//  Circle
//
//  Created by admin on 13-10-4.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "MBaseModel.h"

@interface MRosterInfo : MBaseModel<NSFetchedResultsControllerDelegate>{
}
- (id) initWithId:(NSString *)jid push:(ActionPushBlock)targetPushBlock;
- (void) post:(NSString *)content completed:(ActionCompletedBlock)completedBlock;
- (void) remove:(NSString *)jid completed:(ActionCompletedBlock)completedBlock;
- (void) list:(int)page completed:(ActionCompletedBlock)completedBlock;

@end
