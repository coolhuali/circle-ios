//
//  MMessageInfo.m
//  Circle
//
//  Created by admin on 13-9-30.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "MRecentMessage.h"
#import "MLoginInfo.h"
@interface MRecentMessage (){
    NSFetchedResultsController  *fetcher;
    XMPPJID                     *currentJID;
    NSString                     *target;
    ActionPushBlock             messagePushBlock;
    int             pageSize;
}
@end

@implementation MRecentMessage

- (id) initWithId:(NSString *)jid push:(ActionPushBlock)targetPushBlock
{
    self = [super init];
    if(self){
        pageSize = DEFAULT_PAGE_SIZE;
        target = jid;
        NSRange foundObj=[jid rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        if(foundObj.length>0){
            currentJID = [XMPPJID jidWithString:jid resource:kOFCXMPPResource];
        }else{
            currentJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jid,[MLoginInfo getActiveServer]] resource:kOFCXMPPResource];
        }
        fetcher = [[OFCXMPPManager sharedManager] messagesRecentFetcher:[currentJID bare]];
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
    MDataOperator mDataOperator;
    XMPPMessageArchiving_Contact_CoreDataObject *item;
    switch(type) {
        case NSFetchedResultsChangeInsert:
        {
            mDataOperator = MDataOperatorForAdd;
            item = (XMPPMessageArchiving_Contact_CoreDataObject *)[controller objectAtIndexPath:newIndexPath];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            mDataOperator = MDataOperatorForUpdate;
            item = (XMPPMessageArchiving_Contact_CoreDataObject *)[controller objectAtIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            mDataOperator = MDataOperatorForRemove;
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            mDataOperator = MDataOperatorForMove;
            break;
        }
    }
    NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
    [obj setValue:item.bareJidStr forKey:@"jid"];
    [obj setValue:[item.bareJid user] forKey:@"user"];
    [obj setValue:[MBaseModel getNameCache:[item.bareJid user]] forKey:@"name"];
    [obj setValue:item.mostRecentMessageTimestamp forKey:@"time"];
    [obj setValue:item.mostRecentMessageBody forKey:@"body"];
    [obj setValue:item.mostRecentMessageOutgoing forKey:@"outgoing"];
    [obj setValue:[NSNumber numberWithInt:0] forKey:@"msgcount"];
    if(messagePushBlock)messagePushBlock(obj,mDataOperator,NO);
}
- (void) remove:(NSString *)jid completed:(ActionCompletedBlock)completedBlock
{
    BOOL success = [[OFCXMPPManager sharedManager] removeMessagesRecent:[currentJID bare] bareJidStr:jid];
    if(completedBlock)completedBlock(nil,!success);
}

- (void) list:(int)page completed:(ActionCompletedBlock)completedBlock
{
    NSArray *additions = [[OFCXMPPManager sharedManager] loadRecentMessages:[currentJID bare] pos:(page-1) * pageSize size:pageSize];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:additions.count];
    if(additions && additions.count>0){
        for(int i=0;i<additions.count;i++){
            XMPPMessageArchiving_Contact_CoreDataObject *item = (XMPPMessageArchiving_Contact_CoreDataObject *)additions[i];
            NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
            [obj setValue:item.bareJidStr forKey:@"jid"];
            [obj setValue:[item.bareJid user] forKey:@"user"];
            [obj setValue:[MBaseModel getNameCache:[item.bareJid user]] forKey:@"name"];
            [obj setValue:item.mostRecentMessageTimestamp forKey:@"time"];
            [obj setValue:item.mostRecentMessageBody forKey:@"body"];
            [obj setValue:item.mostRecentMessageOutgoing forKey:@"outgoing"];
            [obj setValue:[NSNumber numberWithInt:0] forKey:@"msgcount"];
            [array addObject:obj];
        }
    }
    if(completedBlock)completedBlock(array,NO);
    
}
@end
