//
//  MRosterInfo.m
//  Circle
//
//  Created by admin on 13-10-4.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "MRosterInfo.h"
#import "MLoginInfo.h"
@interface MRosterInfo (){
    NSFetchedResultsController  *fetcher;
    XMPPJID                     *currentJID;
    NSString                     *target;
    ActionPushBlock             rosterPushBlock;
    BOOL             isGrouping;
    int             pageSize;
}
@end

@implementation MRosterInfo

- (id) initWithId:(NSString *)jid push:(ActionPushBlock)targetPushBlock
{
    self = [super init];
    if(self){
        pageSize = DEFAULT_PAGE_SIZE;
        target = jid;
        NSRange foundObj = [jid rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        if(foundObj.length>0){
            currentJID = [XMPPJID jidWithString:jid resource:kOFCXMPPResource];
        }else{
            currentJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jid,[MLoginInfo getActiveServer]] resource:kOFCXMPPResource];
        }
        fetcher = [[OFCXMPPManager sharedManager] rosterFetcher:[currentJID bare]];
        fetcher.delegate = self;
        rosterPushBlock = targetPushBlock;
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
            XMPPUserCoreDataStorageObject *item = (XMPPUserCoreDataStorageObject *)[controller objectAtIndexPath:newIndexPath];
            NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
            [obj setValue:item.jidStr forKey:@"jid"];
            [obj setValue:item.nickname?item.nickname:[item.jid user] forKey:@"name"];
            [obj setValue:item.sectionName forKey:@"section"];
            [obj setValue:@"" forKey:@"sign"];
            if(rosterPushBlock)rosterPushBlock(obj,MDataOperatorForAdd,NO);
            break;
        }
        default:
            break;
    }
}
- (void) post:(NSString *)content completed:(ActionCompletedBlock)completedBlock
{
    
    if(completedBlock)completedBlock(nil,NO);
} 
- (void) remove:(NSString *)jid completed:(ActionCompletedBlock)completedBlock
{
    if(completedBlock)completedBlock(nil,NO);
}

- (void) list:(int)page completed:(ActionCompletedBlock)completedBlock
{
    NSArray *additions = [[OFCXMPPManager sharedManager] loadRoster:[currentJID bare] pos:(page-1) * pageSize size:pageSize];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:additions.count];
    if(additions && additions.count>0){
        for(int i=0;i<additions.count;i++){
            XMPPUserCoreDataStorageObject *item = (XMPPUserCoreDataStorageObject *)additions[i];
            NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
            [obj setValue:item.jidStr forKey:@"jid"];
            [obj setValue:item.nickname?item.nickname:[item.jid user] forKey:@"name"];
            [obj setValue:item.sectionName forKey:@"section"];
            [obj setValue:@"" forKey:@"sign"];
            [array addObject:obj];
        }
    }
    if(completedBlock)completedBlock(array,NO);
    
}
@end
