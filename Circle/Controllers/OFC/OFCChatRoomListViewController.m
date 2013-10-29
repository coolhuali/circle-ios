//
//  OFCChatRoomListViewController.m
//  OpenFireClient
//
//  Created by CTI AD on 5/11/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCChatRoomListViewController.h" 
#import "MenuTableViewCell.h"
#import "MAppStrings.h"

@implementation OFCChatRoomListViewController
@synthesize isEditableOrNot;
@synthesize chatroomList;
@synthesize chatroomListView;
- (id)init
{
    self = [super init];
    if(self){
        self.title = NSLocalizedString(@"group.title", nil);
        
    }
    return self;
}
- (void)setEditing:(BOOL)editing{
    [super setEditing:editing];
    [chatroomListView setEditing:editing animated:YES];
    if(editing){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target: self action:@selector(doneEditItems)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target: self action:@selector(popBuddyListView)];
    }
}
- (void)doneEditItems
{
   [self setEditing:false];
}

- (void)popBuddyListView
{ 
        OFCSelectBuddysViewController *selectBuddyViewController = [[OFCSelectBuddysViewController alloc]init];
        [self presentModalViewController:selectBuddyViewController animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    chatroomListView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    chatroomListView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [chatroomListView setDelegate:self];
    [chatroomListView setDataSource:self];
    [self.view addSubview:chatroomListView];
    
    inviteDic = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showNickNameConflictAlter)
                                                name:kOFCNickNameConflictNotification
                                              object:nil ];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(receiveInvitation:)
                                                name:kOFCReceiveInvitationNotification
                                              object:nil];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    roomFetcher = [[OFCXMPPManager sharedManager] roomFetcher];
    roomFetcher.delegate = self;
    [self setEditing:false];
    [chatroomListView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    roomFetcher.delegate = nil;
    roomFetcher = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableViewDataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count= [[roomFetcher fetchedObjects] count];
    self.title = [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"group.title", nil),count];
    if (count==0) {
        NSLog(@"this triggers, but doesn't stop editing..");
        [chatroomListView setEditing:NO animated:YES];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatroomcell"];
    if(!cell){
        cell = [[MenuTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"chatroomcell"];
    }
    XMPPRoomInfoCoreDataStorageObject *room = [roomFetcher objectAtIndexPath:indexPath]; 
    cell.textLabel.text = [room roomName];
    cell.detailTextLabel.text = [[room roomJID]full];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteItems:)];
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}
//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//这个方法用来告诉表格 这一行是否可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//这个方法就是执行移动操作的
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)
sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

}
//这个方法根据参数editingStyle是UITableViewCellEditingStyleDelete
//还是UITableViewCellEditingStyleDelete执行删除或者插入
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPRoomInfoCoreDataStorageObject *room = [roomFetcher objectAtIndexPath:indexPath];
        [[sharedDelegate xmppManager] removeRoom:room];
    }
}
- (void) showDeleteItems:(UIGestureRecognizer *)recognizer{
    [self setEditing:true];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
 #pragma mark -
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    XMPPRoomInfoCoreDataStorageObject *room = [roomFetcher objectAtIndexPath:indexPath];
    [self enterConversationView:[room roomJID]];
}

- (void)enterConversationView:(XMPPJID *)roomJID
{
    GroupChatViewController *control = [[GroupChatViewController alloc] initWithId:[roomJID user] isGroup:NO];
    [self.navigationController pushViewController:control animated:YES];
}
#pragma mark -
#pragma mark NSFetchedResultsController Delegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [chatroomListView reloadData];
}
- (void)showNickNameConflictAlter
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Nick Name exists" message:@"Please change nick name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)receiveInvitation:(NSNotification *)notification
{
    XMPPMessage *message = [[notification userInfo] objectForKey:@"message"];
    NSXMLElement *x = [message elementForName:@"x" xmlns:XMPPMUCUserNamespace];
    NSXMLElement *invite = [x elementForName:@"invite"];
    NSXMLElement *directInvite = [message elementForName:@"x" xmlns:@"jabber:x:conference"];
    XMPPJID *invitor = [XMPPJID jidWithString:[invite attributeStringValueForName:@"from"]];
    
    NSString *inviteMessage = [NSString stringWithFormat:@"%@ invite you to join conference",[invitor user]];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invitation" message:inviteMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Decline", nil];
    alert.tag = 1001;
    NSString *roomJIDString = [directInvite attributeStringValueForName:@"jid"] ;
    NSDictionary *invitationDetails = [NSDictionary dictionaryWithObjectsAndKeys:roomJIDString,@"roomJIDString",[invitor full],@"invitorJIDString",nil];
    [inviteDic setObject:invitationDetails forKey:[NSString stringWithFormat:@"%d",alert.tag]];
    [alert show];
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSDictionary *invitationDetails = [inviteDic objectForKey:[NSString stringWithFormat:@"%d",alertView.tag ]];
    NSString *roomJID = [invitationDetails objectForKey:@"roomJIDString"];
    NSString *invitorJIDString = [invitationDetails objectForKey:@"invitorJIDString"];
    if(buttonIndex == 1){
        [[OFCXMPPManager sharedManager] declineInvitation:roomJID invitorJID:invitorJIDString];
    }else if(buttonIndex == 0){ 
        [self enterConversationView:[XMPPJID jidWithString:roomJID]];
    }
    [inviteDic removeAllObjects];
}

@end
