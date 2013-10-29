//
//  MMessageInfo.h
//  Circle
//
//  Created by admin on 13-9-30.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "MBaseModel.h"
#import "OFCXMPPManager.h"
@interface MMessageInfo : MBaseModel<NSFetchedResultsControllerDelegate>{
}
- (id) initWithId:(NSString *)jid isGroup:(BOOL)isGroup push:(ActionPushBlock)targetPushBlock;
- (void) post:(NSString *)content completed:(ActionCompletedBlock)completedBlock;
- (void) postImage:(NSString *)content completed:(ActionCompletedBlock)completedBlock;
- (void) postFile:(NSString *)content completed:(ActionCompletedBlock)completedBlock;
- (void) remove:(NSString *)msgid completed:(ActionCompletedBlock)completedBlock;
- (void) list:(int)page completed:(ActionCompletedBlock)completedBlock;
@end
