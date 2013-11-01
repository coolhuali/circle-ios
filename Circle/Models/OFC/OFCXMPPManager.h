//
//  OFCXMPPManager.h
//  OpenFireClient
//
//  Created by CTI AD on 29/10/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "DDLog.h"
#import "MAppStrings.h"
#import "OFCBuddy.h"
#import "OFCChatroom.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "OFCChatMessage.h"
@interface OFCXMPPManager : NSObject <XMPPRosterDelegate,NSFetchedResultsControllerDelegate>
{
    
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPMUC *xmppMUC;
    XMPPRoom *xmppRoom;
    XMPPPing *xmppPing;
	
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPRoomCoreDataStorage *xmppRoomDataStorage;
    
    XMPPMessageArchiving *xmppMessageArchiving;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
    
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;

	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    XMPPJID *myJID;
    
    NSString *password;
    BOOL isXmppConnected;
    BOOL isAuthed;
    
    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
    
    BOOL isAnoymous;
    NSManagedObjectContext *managedObjectContext_room;
    NSManagedObjectContext *managedObjectContext_roster;
    NSManagedObjectContext *managedObjectContext_messages;
	NSManagedObjectContext *managedObjectContext_capabilities;
    NSArray *selectedBuddy;
    
}

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRoom *xmppRoom;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, readonly) XMPPRoomCoreDataStorage *xmppRoomDataStorage;
@property (nonatomic, strong) XMPPJID *myJID;

+ (OFCXMPPManager *)sharedManager;
- (BOOL)hasAuthed;
- (BOOL)hasSetting;
- (BOOL)connect:(NSString *)jid pwd:(NSString *)pwd;
- (BOOL)anoymousConnection;
- (void)auth:(NSString*) jid password:(NSString*)pwd;
- (void)disconnect;
- (void)reloadRoom;
- (void)goIntoChatroom:(XMPPJID *)roomJID;
- (void)leaveChatroom;
- (BOOL)removeRoom:(XMPPRoomInfoCoreDataStorageObject *)room;

- (BOOL)removeRoster:(XMPPUserCoreDataStorageObject *)user;

- (void)setVCard:(XMPPvCardTemp *)vCardTemp;


- (NSArray *)loadMessages:(NSString *)bareJidStr pos:(int)pos size:(int)size;

- (NSArray *)loadRecentMessages:(NSString *)streamBareJidStr pos:(int)pos size:(int)size;

- (BOOL)removeMessagesRecent:(NSString *)streamBareJidStr bareJidStr:(NSString *)bareJidStr;

- (BOOL)removeMessages:(NSString *)streamBareJidStr bareJidStr:(NSString *)bareJidStr;

- (NSString *)sendMessage:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage;

- (NSString *)sendImage:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage;

- (NSString *)sendFile:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage;

- (NSString *)sendGroupMessage:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage;

- (NSString *)sendGroupImage:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage;

- (NSString *)sendGroupFile:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage;

- (void)inviteFriendsToJoinChatroom:(NSArray *)buddyLists;

- (void)declineInvitation:(NSString *)roomJIDString invitorJID:(NSString *)invitorJIDString;

- (NSArray *)loadRoster:(NSString *)bareJidStr pos:(int)pos size:(int)size;

- (NSFetchedResultsController *)rosterFetcher;

- (NSFetchedResultsController *)rosterFetcher:(NSString *)bareJidStr;

- (NSFetchedResultsController *)messagesFetcher:(NSString *)bareJidStr;

- (NSFetchedResultsController *)messagesRecentFetcher:(NSString *)streamBareJidStr;

- (NSFetchedResultsController *)roomFetcher;

- (NSFetchedResultsController *)roomFetcher:(NSString *)bareJidStr;

- (XMPPRoomInfoCoreDataStorageObject *)roomInfoFetchedResult:(XMPPJID *)roomJID;

- (void)sendSearchRequest:(NSString *)searchField;
@end
