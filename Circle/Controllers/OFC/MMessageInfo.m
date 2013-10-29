//
//  MMessageInfo.m
//  Circle
//
//  Created by admin on 13-9-30.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "MMessageInfo.h"
#import "MLoginInfo.h"
@interface MMessageInfo (){
    NSFetchedResultsController  *fetcher;
    XMPPJID                     *currentJID;
    NSString                     *target;
    ActionPushBlock             messagePushBlock;
    BOOL             isGrouping;
    int             pageSize;
}
@end

@implementation MMessageInfo

- (id) initWithId:(NSString *)jid isGroup:(BOOL)isGroup push:(ActionPushBlock)targetPushBlock
{
    self = [super init];
    if(self){
        pageSize = DEFAULT_PAGE_SIZE;
        isGrouping = isGroup;
        target = jid;
        NSRange foundObj=[jid rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        if(foundObj.length>0){
            currentJID = [XMPPJID jidWithString:jid resource:kOFCXMPPResource];
        }else{
            currentJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jid,[MLoginInfo getActiveServer]] resource:kOFCXMPPResource];
        }
        fetcher = [[OFCXMPPManager sharedManager] messagesFetcher:[currentJID bare]];
        fetcher.delegate = self;
        messagePushBlock = targetPushBlock;
    }
    return self;
}
#pragma mark -
#pragma mark NSFetchedResultsController Delegate
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
        {
            XMPPMessageArchiving_Message_CoreDataObject *msg = (XMPPMessageArchiving_Message_CoreDataObject *)[controller objectAtIndexPath:newIndexPath];
            if(messagePushBlock)messagePushBlock(msg,MDataOperatorForAdd,NO);
            break;
        }
        default:
            break;
    }
}
- (void) post:(NSString *)content completed:(ActionCompletedBlock)completedBlock
{
    NSString *msgId;
    if(isGrouping){
        msgId = [[OFCXMPPManager sharedManager] sendGroupMessage:currentJID withMessage:content];
    }else{
        msgId = [[OFCXMPPManager sharedManager] sendMessage:currentJID withMessage:content];
    }
    if(completedBlock)completedBlock(msgId,NO);
}
//[NSString stringWithFormat:API_DOWN_IMAGE_URL,content]
- (void) postImage:(NSString *)content completed:(ActionCompletedBlock)completedBlock
{
    NSString *msgId;
    if(isGrouping){
        msgId = [[OFCXMPPManager sharedManager] sendGroupImage:currentJID withMessage:content];
    }else{
        msgId = [[OFCXMPPManager sharedManager] sendImage:currentJID withMessage:content];
    }
    if(completedBlock)completedBlock(msgId,NO);
}
- (void) postFile:(NSString *)content completed:(ActionCompletedBlock)completedBlock
{
    NSString *msgId;
    if(isGrouping){
        msgId = [[OFCXMPPManager sharedManager] sendGroupFile:currentJID withMessage:content];
    }else{
       msgId =  [[OFCXMPPManager sharedManager] sendFile:currentJID withMessage:content];
    }
    if(completedBlock)completedBlock(msgId,NO);
}
- (void) remove:(NSString *)msgid completed:(ActionCompletedBlock)completedBlock
{
    
}

- (void) list:(int)page completed:(ActionCompletedBlock)completedBlock
{
    NSArray *additions = [[OFCXMPPManager sharedManager] loadMessages:[currentJID bare] pos:(page-1) * pageSize size:pageSize];
    if(completedBlock)completedBlock(additions,NO);
    
}
@end
