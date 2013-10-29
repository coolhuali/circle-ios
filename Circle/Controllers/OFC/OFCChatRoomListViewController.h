//
//  OFCChatRoomListViewController.h
//  OpenFireClient
//
//  Created by CTI AD on 5/11/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "OFCChatroom.h"
#import "GroupChatViewController.h"
#import "OFCSelectBuddysViewController.h"
@interface OFCChatRoomListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,NSFetchedResultsControllerDelegate>
{
    BOOL *isEditableOrNot;
    UITableView *chatroomListView;
    NSArray *chatroomList;
    NSMutableDictionary *inviteDic;
    NSFetchedResultsController *roomFetcher;
}
@property (nonatomic) BOOL *isEditableOrNot;
@property (nonatomic,strong) NSArray *chatroomList;
@property (nonatomic,strong)  UITableView *chatroomListView; 
@end
