//
//  MRecentMessage.h
//  Circle
//
//  Created by admin on 13-10-8.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "MBaseModel.h"
#import "OFCXMPPManager.h"

@interface MRecentMessage : MBaseModel<NSFetchedResultsControllerDelegate>{
}
- (id) initWithId:(NSString *)jid push:(ActionPushBlock)targetPushBlock;
- (void) remove:(NSString *)jid completed:(ActionCompletedBlock)completedBlock;
- (void) list:(int)page completed:(ActionCompletedBlock)completedBlock;
@end
