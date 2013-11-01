//
//  OFCXMPPManager.m
//  OpenFireClient
//
//  Created by CTI AD on 29/10/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCXMPPManager.h"
#import "MLoginInfo.h"
#import "MyLocationInfo.h"
#import "MProfileInfo.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface OFCXMPPManager (){
    MyLocationInfo *location;
}

@end

static OFCXMPPManager *sharedManager = nil;

@implementation OFCXMPPManager
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRoom;
@synthesize xmppRosterStorage; 
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppRoomDataStorage;
@synthesize myJID; 


#pragma mark -
#pragma mark singleton
- (id)init
{
    self=[super init];
    if(self){
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        location = [MyLocationInfo alloc];
        [self setupStream];
    }
    return self;
}

+ (OFCXMPPManager *)sharedManager
{
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [super allocWithZone:zone];
            return sharedManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark -
#pragma mark Manage Private
- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    xmppStream = [[XMPPStream alloc]init];
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    
//    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithDatabaseFilename:@"XMPPRoster.sqlite"];
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    //xmppRoomDataStorage = [[XMPPRoomCoreDataStorage alloc] initWithInMemoryStore];
    xmppRoomDataStorage = [[XMPPRoomCoreDataStorage alloc] initWithDatabaseFilename:@"XMPPRoom.sqlite"];
    
    xmppMUC = [[XMPPMUC alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    xmppMessageArchivingStorage = [[XMPPMessageArchivingCoreDataStorage alloc] initWithDatabaseFilename:@"XMPPMessageArchiving.sqlite"];
    
//    dispatch_queue_t messageArchivingQueue = dispatch_queue_create("com.hktv.message.archiving", NULL);
    
    xmppMessageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:xmppMessageArchivingStorage dispatchQueue:dispatch_get_main_queue()];
    xmppMessageArchiving.clientSideMessageArchivingOnly = YES;
    
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    xmppPing = [[XMPPPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    xmppPing.respondsToQueries = YES;
    
	// Activate xmpp modules
    [xmppMUC               activate:xmppStream];
    [xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    [xmppPing              activate:xmppStream];
    [xmppMessageArchiving  activate:xmppStream];
    
    [xmppCapabilities addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppMUC addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    allowSelfSignedCertificates = YES;
    allowSSLHostNameMismatch = YES;
    
}

- (void)setVCard:(XMPPvCardTemp *)vCardTemp{
    [xmppvCardStorage setvCardTemp:vCardTemp forJID:[xmppStream myJID] xmppStream:xmppStream];
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self]; 
	[xmppMUC               deactivate];
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	xmppStream = nil;
	xmppReconnect = nil;
	xmppMUC = nil;
    xmppRoster = nil; 
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}

- (void)goOnline
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    XMPPPresence *presence = [XMPPPresence presence];
    [xmppStream sendElement:presence];
    [self requestSearchFields];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}
- (void)reloadRoom
{
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomDataStorage dispatchQueue:dispatch_get_main_queue()];
    [xmppRoom              activate:xmppStream];
    [xmppRoom fetchRoom];
}
- (void)goIntoChatroom:(XMPPJID *)roomJID
{  
    BOOL result = [MLoginInfo getActiveUseNick];
    NSString *nickName = [MLoginInfo getActiveNickname];
    
    [self leaveChatroom];
    //XMPPJID *roomJID = [XMPPJID jidWithString:roomJIDString];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomDataStorage jid:roomJID];
    [xmppRoom              activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    if(result && nickName.length>0){
        [xmppRoom joinRoomUsingNickname:nickName history:nil];
    }else{
        [xmppRoom joinRoomUsingNickname:self.myJID.user history:nil];
    }
}
- (void)leaveChatroom
{
    [xmppRoom leaveRoom];
    [xmppRoom deactivate];
    [xmppRoom removeDelegate:self];
     xmppRoom = nil;
}
- (void)failedToConnect
{
    [xmppStream disconnect];
    [self resetRosterStatus];
     NSLog(@"reset Roster Status complete");
    
}

- (NSString *)sendMessage:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage
{
    return [self sendMessageToServer:targetBareID withMessage:newMessage type:@"chat" requiredReceipt:YES isImage:NO isFile:NO withType:nil];
}
- (NSString *)sendFile:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage
{
    return [self sendMessageToServer:targetBareID withMessage:newMessage type:@"chat" requiredReceipt:YES isImage:NO isFile:YES withType:nil];
}
- (NSString *)sendImage:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage
{
    return [self sendMessageToServer:targetBareID withMessage:newMessage type:@"chat" requiredReceipt:YES isImage:YES isFile:NO withType:nil];
}
- (NSString *)sendGroupMessage:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage
{
    return [self sendMessageToServer:targetBareID withMessage:newMessage type:@"groupchat" requiredReceipt:YES isImage:NO isFile:NO withType:nil];
}
- (NSString *)sendGroupImage:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage
{
    return [self sendMessageToServer:targetBareID withMessage:newMessage type:@"groupchat" requiredReceipt:YES isImage:YES isFile:NO withType:nil];
}
- (NSString *)sendGroupFile:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage
{
    return [self sendMessageToServer:targetBareID withMessage:newMessage type:@"groupchat" requiredReceipt:YES isImage:NO isFile:YES withType:nil];
}
- (NSString *)sendMessageToServer:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage type:(NSString *)type requiredReceipt:(BOOL)requiredReceipt;
{ 
    return [self sendMessageToServer:targetBareID withMessage:newMessage type:@"groupchat" requiredReceipt:YES isImage:NO isFile:NO withType:nil];
}
- (NSString *)sendMessageToServer:(XMPPJID *)targetBareID withMessage:(NSString *)newMessage type:(NSString *)type requiredReceipt:(BOOL)requiredReceipt isImage:(BOOL)isImage isFile:(BOOL)isFile withType:(NSString *)withType;
{
    //消息编码处理
    NSData *data = [newMessage dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //消息解码处理
    //NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    //NSString *body = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:newMessage];
    XMPPMessage *message = [XMPPMessage elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:type];
    [message addAttributeWithName:@"to" stringValue:[targetBareID full]];
    [message addAttributeWithName:@"from" stringValue:[myJID full]];
    int timeStamp = (int)[[NSDate date] timeIntervalSince1970];
    NSString * messageID = [NSString stringWithFormat:@"%@%d%@",[myJID user],timeStamp,[targetBareID user]];
    [message addAttributeWithName:@"id" stringValue:messageID];
    if (isImage) {
        NSXMLElement * imageRequest = [NSXMLElement elementWithName:@"image"];
        [imageRequest addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:image"];
        [message addChild:imageRequest];
    }
    if (isFile) {
        NSXMLElement * fileRequest = [NSXMLElement elementWithName:@"file"];
        [fileRequest addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:file"];
        [message addChild:fileRequest];
    }
    if (withType!=nil) {
        NSXMLElement * withTypeRequest = [NSXMLElement elementWithName:withType];
        [withTypeRequest addAttributeWithName:@"xmlns" stringValue:[NSString stringWithFormat:@"urn:xmpp:%@",withType]];
        [message addChild:withTypeRequest];
    }
    
    if(requiredReceipt){
        NSXMLElement * receiptRequest = [NSXMLElement elementWithName:@"request"];
        [receiptRequest addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:receipts"];
        [message addChild:receiptRequest];
        [message addChild:body];
        XMPPElementReceipt *receipt = nil;
        [xmppStream sendElement:message andGetReceipt:&receipt];
        if ([receipt wait:-1]) {
            
        };
    }else{
        [message addChild:body];
        [xmppStream sendElement:message];
    }
    return messageID;
}
- (void)requestSearchFields
{
 	NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
	[query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:search"];
	
	NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"type" stringValue:@"get"];
	[iq addAttributeWithName:@"id" stringValue:@"search"];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"search.%@",xmppStream.hostName ]];
    [iq addAttributeWithName:@"from" stringValue:[myJID full]];
    [iq addChild:query];
	[xmppStream sendElement:iq];
}
- (NSString *) gen_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)CFBridgingRelease(uuid_string_ref)];
    
    CFRelease(uuid_string_ref);
    return uuid;
}
- (void)inviteFriendsToJoinChatroom:(NSArray *)buddyLists
{
    NSString *roomHost = [NSString stringWithFormat:@"%@@conference.%@",[self gen_uuid],[xmppStream hostName]];
    XMPPJID *roomJID = [XMPPJID jidWithString:roomHost];
    XMPPRoom *newRoom = [[XMPPRoom alloc]initWithRoomStorage:self.xmppRoomDataStorage
                                                         jid:roomJID
                                               dispatchQueue:dispatch_get_main_queue()];

    xmppRoom = nil;
    xmppRoom = newRoom;
    selectedBuddy = nil;
    selectedBuddy = [NSArray arrayWithArray:buddyLists];
    [newRoom activate:self.xmppStream];
    [newRoom addDelegate:self
           delegateQueue:dispatch_get_main_queue()];
//    [newRoom inviteUser:userJID withMessage:@"come in"];


    [newRoom joinRoomUsingNickname:[myJID user] history:nil];
}

- (void)inviteBuddyToChatRoom
{
    for (NSString *accountName in selectedBuddy) {
        XMPPJID *userJID = [XMPPJID jidWithString:accountName];
        [xmppRoom inviteUser:userJID withMessage:@"come in"];
    }
}

- (void)sendSearchRequest:(NSString *)searchField
{
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:search"];
    
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"submit"];
    
    NSXMLElement *formType = [NSXMLElement elementWithName:@"field"];
    [formType addAttributeWithName:@"type" stringValue:@"hidden"];
    [formType addAttributeWithName:@"var" stringValue:@"FORM_TYPE"];
    [formType addChild:[NSXMLElement elementWithName:@"value" stringValue:@"jabber:iq:search" ]];

    NSXMLElement *userName = [NSXMLElement elementWithName:@"field"];
    [userName addAttributeWithName:@"var" stringValue:@"Username"];
    [userName addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1" ]];
    
    NSXMLElement *name = [NSXMLElement elementWithName:@"field"];
    [name addAttributeWithName:@"var" stringValue:@"Name"];
    [name addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    
    NSXMLElement *email = [NSXMLElement elementWithName:@"field"];
    [email addAttributeWithName:@"var" stringValue:@"Email"];
    [email addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    
    NSXMLElement *search = [NSXMLElement elementWithName:@"field"];
    [search addAttributeWithName:@"var" stringValue:@"search"];
    [search addChild:[NSXMLElement elementWithName:@"value" stringValue:searchField]];
    
    [x addChild:formType];
    [x addChild:userName];
    [x addChild:name];
    [x addChild:email];
    [x addChild:search];
    [query addChild:x];
    
    
	NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"type" stringValue:@"set"];
	[iq addAttributeWithName:@"id" stringValue:[xmppStream generateUUID]];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"search.%@",xmppStream.hostName ]];
    [iq addAttributeWithName:@"from" stringValue:[myJID full]];
    [iq addChild:query];
	[xmppStream sendElement:iq];
}

- (void)declineInvitation:(NSString *)roomJIDString invitorJID:(NSString *)invitorJIDString
{
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCUserNamespace];
    NSXMLElement *declineElement = [NSXMLElement elementWithName:@"decline"];
    [declineElement addAttributeWithName:@"to" stringValue:invitorJIDString];
    [x addChild:declineElement];
    XMPPMessage *message = [[XMPPMessage alloc]init];
    [message addAttributeWithName:@"from" stringValue:[myJID full]];
    [message addAttributeWithName:@"to" stringValue:roomJIDString];
    [message addChild:x];
    [self.xmppStream sendElement:message];
}

- (void)pushLocalNotification:(NSString *)user body:(NSString *)body
{
    UIApplication *application = [UIApplication sharedApplication];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif) {
        localNotif.applicationIconBadgeNumber = [application applicationIconBadgeNumber]+1;
        localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        localNotif.alertBody = [NSString stringWithFormat:@"%@ : %@",user,body];
        localNotif.alertAction =NSLocalizedString(@"reply", nil);
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        [application presentLocalNotificationNow:localNotif];
    }else{
        NSLog(@"Not Support");
    }
}

#pragma mark -
#pragma mark XMPPStream Connect/Disconnect
- (BOOL)hasSetting{
    return [MLoginInfo hasSetting];
}
- (BOOL)connect:(NSString *)jid pwd:(NSString *)pwd
{
    if(![self hasSetting]){
        return NO;
    }
    if(![xmppStream isDisconnected]){
        return YES;
    }
    NSRange foundObj=[jid rangeOfString:@"@" options:NSCaseInsensitiveSearch];
    if(foundObj.length>0){
        myJID = [XMPPJID jidWithString:jid resource:kOFCXMPPResource];
    }else{
        myJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jid,[MLoginInfo getActiveServer]] resource:kOFCXMPPResource];
    }
    [xmppStream setHostName:[MLoginInfo getActiveServer]];
    [xmppStream setHostPort:(UInt16)[MLoginInfo getActiveServerPort]];
    [xmppStream setMyJID:myJID];
    password = pwd;
    
    NSError *error;
    isAnoymous = NO;
	if (![xmppStream connect:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    return YES;
}

- (BOOL)anoymousConnection
{
    if(![xmppStream isDisconnected]){
        return YES;
    }
    NSString *server = [MLoginInfo getActiveServer];
	UInt16 *port = [MLoginInfo getActiveServerPort];
    
    NSString *res = [NSString stringWithFormat:@"%@",kOFCXMPPResource];
    myJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"anoymous@%@",server] resource:res];
    [xmppStream setMyJID:myJID];
    [xmppStream setHostName:server];
    [xmppStream setHostPort:(UInt16)port];
    
    NSError *error;
    isAnoymous = YES;
	if (![xmppStream connect:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    return NO;
}
-(void)auth:(NSString*) jid password:(NSString*)pwd{
    if(![xmppStream isDisconnected]){
        isAnoymous = NO;
        password = pwd;
        
        NSRange foundObj=[jid rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        if(foundObj.length>0){
            myJID = [XMPPJID jidWithString:jid resource:kOFCXMPPResource];
        }else{
            myJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jid,[MLoginInfo getActiveServer]] resource:kOFCXMPPResource];
        }
        NSError *authenticationError = nil;
        [xmppStream setMyJID:myJID];
        [xmppStream authenticateWithPassword:password error:&authenticationError];
    }
}
- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
    //[self teardownStream];
}
#pragma mark -
#pragma mark XMPPStream Delegate
- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}


- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kOFCServerConnectSuccess object:self];
	 
    if (isAnoymous)return;
	NSError *secureError = nil;
    NSError *authenticationError = nil;
    BOOL isSecureAble = (![sender isSecure])&& [sender supportsStartTLS];
	if (isSecureAble) {
        [sender secureConnection:&secureError];
    }
    if (isAnoymous) {
        if (![[self xmppStream] authenticateAnonymously:&authenticationError])
        {
            if (![[self xmppStream] supportsAnonymousAuthentication]) {
                return;
            }
            DDLogError(@"Can't anoymous: %@", authenticationError);
            isXmppConnected = NO;
            return;
        }
    }else{
        if (![[self xmppStream] authenticateWithPassword:password error:&authenticationError])
        {
            DDLogError(@"Error authenticating: %@", authenticationError);
            isXmppConnected = NO;
            return;
        }
    }
    isXmppConnected = YES;
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    isXmppConnected = NO;
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
        [self failedToConnect];
	}
    else {
        //Lost connection
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kOFCServerConnectFail object:self];
}
- (BOOL)hasAuthed
{
    return isAuthed;
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [[MLoginInfo alloc] login:[myJID user] pwd:password completed:^(NSObject *result, BOOL hasError) {
        if(hasError)return;
        [MLoginInfo setActiveUserPwd:password];
        [MLoginInfo setActiveUserId:[myJID user] completed:^(NSObject *result, BOOL hasError) {
            isAuthed=YES;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kOFCServerAuthedSuccess object:self];
        }];
        //上传位置信息
        [location updateLocation];
    }];
    if(isAnoymous)return;
    NSLog(@"begin");
    [self resetRosterStatus];
    [self reloadRoom];
    NSLog(@"fetch controller complete");
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{ 
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [self failedToConnect];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kOFCServerAuthedFail object:self];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq type]);
    if([iq isSearchResult]){
        NSDictionary *userInfo = [iq searchResults];
        [[NSNotificationCenter defaultCenter] postNotificationName:kOFCSearchResultNotification object:self userInfo:userInfo];
    }
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSString *body = [[message elementForName:@"body"] stringValue];
    NSString * messageBody = [[NSString alloc] initWithData:[body dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
	if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        NSString *userName = [MLoginInfo getNameCache:[[message from] user]];
        [self pushLocalNotification:userName body:messageBody];
    }
    if([message hasReceiptRequest]){
        XMPPMessage *responseMessage = [message generateReceiptResponse];
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"r"];
        [responseMessage addChild:body];
        [xmppStream sendElement:responseMessage];
    }
    if([message hasReceiptResponse]){
        return;
    }
	if ([message isChatMessageWithBody])
	{
        NSString *jid = [[message from] user];
        [[MProfileInfo alloc] updateCache:jid completed:^(NSObject *result, BOOL hasError) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:jid, FROM_JID, messageBody, MESSAGE_BODY, nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:kOFCMessageNotification object:self userInfo:userInfo];
        }];
	}else if([message isGroupChatMessageWithBody]){
        if([messageBody isEqualToString:XMPP_CHATROOM_LOCKED]){
            [xmppRoom configureRoomUsingOptions:nil];
            return ;
        }else if([messageBody isEqualToString:XMPP_CHATROOM_UNLOCKED]){
            [self inviteBuddyToChatRoom];
        }
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message
                                                             forKey:@"message"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kOFCReceiveGroupChat object:self userInfo:userInfo];
    }else if([message isMessageWithBody]){
        
    }
    
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kOFCServerRegisterSuccess object:self];
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kOFCServerRegisterFail object:self];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_room{
    NSAssert([NSThread isMainThread],
	         @"NSManagedObjectContext is not thread safe. It must always be used on the same thread/queue");
	
	if (managedObjectContext_room == nil)
	{
		managedObjectContext_room = [[NSManagedObjectContext alloc] init];
		
		NSPersistentStoreCoordinator *psc = [xmppRoomDataStorage persistentStoreCoordinator];
		[managedObjectContext_room setPersistentStoreCoordinator:psc];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(contextDidSave:)
		                                             name:NSManagedObjectContextDidSaveNotification
		                                           object:nil];
	}
	
	return managedObjectContext_room;
}
- (NSManagedObjectContext *)managedObjectContext_roster
{
	NSAssert([NSThread isMainThread],
	         @"NSManagedObjectContext is not thread safe. It must always be used on the same thread/queue");
	
	if (managedObjectContext_roster == nil)
	{
		managedObjectContext_roster = [[NSManagedObjectContext alloc] init];
		
		NSPersistentStoreCoordinator *psc = [xmppRosterStorage persistentStoreCoordinator];
		[managedObjectContext_roster setPersistentStoreCoordinator:psc];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(contextDidSave:)
		                                             name:NSManagedObjectContextDidSaveNotification
		                                           object:nil];
	}
	
	return managedObjectContext_roster;
}

- (NSManagedObjectContext *)managedObjectContext_messages
{
	NSAssert([NSThread isMainThread],
	         @"NSManagedObjectContext is not thread safe. It must always be used on the same thread/queue");
	
	if (managedObjectContext_messages == nil)
	{
		managedObjectContext_messages = [[NSManagedObjectContext alloc] init];
		NSPersistentStoreCoordinator *psc = [xmppMessageArchivingStorage persistentStoreCoordinator];
		[managedObjectContext_messages setPersistentStoreCoordinator:psc];
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(messagesContextDidSave:)
		                                             name:NSManagedObjectContextDidSaveNotification
		                                           object:nil];
	}
	
	return managedObjectContext_messages;
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	NSAssert([NSThread isMainThread],
	         @"NSManagedObjectContext is not thread safe. It must always be used on the same thread/queue");
	
	if (managedObjectContext_capabilities == nil)
	{
		managedObjectContext_capabilities = [[NSManagedObjectContext alloc] init];
		
		NSPersistentStoreCoordinator *psc = [xmppCapabilitiesStorage persistentStoreCoordinator];
		[managedObjectContext_roster setPersistentStoreCoordinator:psc];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(contextDidSave:)
		                                             name:NSManagedObjectContextDidSaveNotification
		                                           object:nil];
	}
	
	return managedObjectContext_capabilities;
}

- (void)contextDidSave:(NSNotification *)notification
{
	NSManagedObjectContext *sender = (NSManagedObjectContext *)[notification object];
	
	if (sender != managedObjectContext_roster &&
	    [sender persistentStoreCoordinator] == [managedObjectContext_roster persistentStoreCoordinator])
	{
		DDLogVerbose(@"%@: %@ - Merging changes into managedObjectContext_roster", THIS_FILE, THIS_METHOD);
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[managedObjectContext_roster mergeChangesFromContextDidSaveNotification:notification];
            
            
		});
    }
	if (sender != managedObjectContext_room &&
	    [sender persistentStoreCoordinator] == [managedObjectContext_room persistentStoreCoordinator])
	{
		DDLogVerbose(@"%@: %@ - Merging changes into managedObjectContext_room", THIS_FILE, THIS_METHOD);
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[managedObjectContext_room mergeChangesFromContextDidSaveNotification:notification]; 
		});
    }
    
	if (sender != managedObjectContext_capabilities &&
	    [sender persistentStoreCoordinator] == [managedObjectContext_capabilities persistentStoreCoordinator])
	{
		DDLogVerbose(@"%@: %@ - Merging changes into managedObjectContext_capabilities", THIS_FILE, THIS_METHOD);
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[managedObjectContext_capabilities mergeChangesFromContextDidSaveNotification:notification];
		});
	}
}
- (void)messagesContextDidSave:(NSNotification *)notification
{
    NSManagedObjectContext *sender = (NSManagedObjectContext *)[notification object];
    if(sender != managedObjectContext_messages &&
       [sender persistentStoreCoordinator] == [managedObjectContext_messages persistentStoreCoordinator])
    {
 		DDLogVerbose(@"%@: %@ - Merging changes into managedObjectContext_message", THIS_FILE, THIS_METHOD);
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[managedObjectContext_messages mergeChangesFromContextDidSaveNotification:notification];
            
		});
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSuserFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)loadRoster:(NSString *)bareJidStr pos:(int)pos size:(int)size{
    NSFetchedResultsController *fetcher = [self rosterFetcher:bareJidStr];
    [fetcher.fetchRequest setFetchLimit:size];
    [fetcher.fetchRequest setFetchOffset:pos];
    NSError * error = nil;
    NSArray *items = [[self managedObjectContext_roster]executeFetchRequest:fetcher.fetchRequest error:&error];
    if(error){
        
    }
    return items;
}
- (NSFetchedResultsController *)rosterFetcher
{
    return [self rosterFetcher:[[xmppStream myJID] bare]];
}
- (NSFetchedResultsController *)rosterFetcher:(NSString *)bareJidStr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"streamBareJidStr == %@", bareJidStr];
    return [self rosterFetcherByPredicate:predicate];
}
- (NSFetchedResultsController *)rosterFetcherByPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *moc = [self managedObjectContext_roster];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSFetchedResultsController * fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:moc
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    
    NSError *error = nil;
    if (![fetcher performFetch:&error])
    {
        NSLog(@"Error performing fetch: %@", error);
    }
	return fetcher;
}
- (XMPPRoomInfoCoreDataStorageObject *)roomInfoFetchedResult:(XMPPJID *)roomJID
{
    return [xmppRoomDataStorage infoForJID:roomJID stream:xmppStream inContext:managedObjectContext_room];
}
- (BOOL)removeRoom:(XMPPRoomInfoCoreDataStorageObject *)room
{
    [xmppMUC leaveRoom:room.roomJID];
    [managedObjectContext_room deleteObject:room];
    return NO;
}
- (BOOL)removeRoster:(XMPPUserCoreDataStorageObject *)user
{
    [managedObjectContext_roster deleteObject:user];
    [xmppRoster removeUser:user.jid];
    return NO;
}

- (NSFetchedResultsController *)roomFetcher
{
    return [self roomFetcher:[[xmppStream myJID] bare]];
}
- (NSFetchedResultsController *)roomFetcher:(NSString *)bareJidStr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"streamBareJidStr == %@", bareJidStr];
    return [self roomFetcherByPredicate:predicate];
}
- (NSFetchedResultsController *)roomFetcherByPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *moc = [self managedObjectContext_room];
    NSString *entityName = xmppRoomDataStorage.infoEntityName;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:moc];
    
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"roomName" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSFetchedResultsController *roomFetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                         managedObjectContext:moc
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil];
    
    NSError *error = nil;
    if (![roomFetcher performFetch:&error])
    {
        NSLog(@"Error performing fetch: %@", error);
    }
	return roomFetcher;
}

- (NSArray *)loadMessages:(NSString *)bareJidStr pos:(int)pos size:(int)size{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@ AND bareJidStr == %@",[myJID bare], bareJidStr];
    NSFetchedResultsController *fetcher = [self messageArchivingFetcher:predicate];
    [fetcher.fetchRequest setFetchLimit:size];
    [fetcher.fetchRequest setFetchOffset:pos];
    NSError * error = nil;
    NSArray *items = [[self managedObjectContext_messages]executeFetchRequest:fetcher.fetchRequest error:&error];
    if(error){
        
    }
    return items;
}

- (BOOL)removeMessages:(NSString *)streamBareJidStr bareJidStr:(NSString *)bareJidStr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@ and bareJidStr == %@",streamBareJidStr,bareJidStr];
    NSFetchedResultsController *fetcher = [self messageArchivingFetcher:predicate];
    NSError * error = nil;
    NSArray *items = [[self managedObjectContext_messages]executeFetchRequest:fetcher.fetchRequest error:&error];
    if(error){
        return NO;
    }
    if(items && items.count>0){
        for(int i=0;i<items.count;i++){
            [[self managedObjectContext_messages] deleteObject:items[i]];
        }
        [[self managedObjectContext_messages] save:&error];
        if(error){
            return NO;
        }
        return YES;
    }
    return NO;
}
- (NSFetchedResultsController *)messagesFetcher:(NSString *)bareJidStr
{ 
    NSDate * timestamp= [[NSDate alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@ AND bareJidStr == %@ AND timestamp >= %@",[myJID bare], bareJidStr,timestamp]; 
    NSFetchedResultsController *fetcher = [self messageArchivingFetcher:predicate];
    return fetcher;
}

- (NSFetchedResultsController *)messageArchivingFetcher:(NSPredicate *)predicate
{ 
		NSManagedObjectContext *moc = [self managedObjectContext_messages];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setReturnsObjectsAsFaults:NO];
	NSFetchedResultsController *fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc     sectionNameKeyPath:nil   cacheName:nil];
    NSError *error = nil;
    if (![fetcher performFetch:&error])
    {
        NSLog(@"Error performing fetch: %@", error);
    }
	return fetcher;
}

- (NSArray *)loadRecentMessages:(NSString *)streamBareJidStr pos:(int)pos size:(int)size{
    NSFetchedResultsController *fetcher = [self messagesRecentFetcher:streamBareJidStr];
    [fetcher.fetchRequest setFetchLimit:size];
    [fetcher.fetchRequest setFetchOffset:pos];
    NSError * error = nil;
    NSArray *items = [[self managedObjectContext_messages]executeFetchRequest:fetcher.fetchRequest error:&error];
    if(error){
        
    }
    return items;
}

- (BOOL)removeMessagesRecent:(NSString *)streamBareJidStr bareJidStr:(NSString *)bareJidStr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@ and bareJidStr == %@",streamBareJidStr,bareJidStr];
    NSFetchedResultsController *fetcher = [self messageRecentFetcher:predicate];
    NSError * error = nil;
    NSArray *items = [[self managedObjectContext_messages]executeFetchRequest:fetcher.fetchRequest error:&error];
    if(error){
        return NO;
    }
    if(items && items.count>0){
        for(int i=0;i<items.count;i++){
            XMPPMessageArchiving_Contact_CoreDataObject *item = (XMPPMessageArchiving_Contact_CoreDataObject *)items[i];
            [[self managedObjectContext_messages] deleteObject:item];
        }
        [[self managedObjectContext_messages] save:&error];
        if(error){
            return NO;
        }
        return [self removeMessages:streamBareJidStr bareJidStr:bareJidStr];
    }
    return NO;
}
- (NSFetchedResultsController *)messagesRecentFetcher:(NSString *)streamBareJidStr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",streamBareJidStr];
    NSFetchedResultsController *fetcher = [self messageRecentFetcher:predicate]; 
    return fetcher;
}

- (NSFetchedResultsController *)messageRecentFetcher:(NSPredicate *)predicate
{
    NSManagedObjectContext *moc = [self managedObjectContext_messages];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                              inManagedObjectContext:moc];
    
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"mostRecentMessageTimestamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsObjectsAsFaults:NO];
	NSFetchedResultsController *fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc     sectionNameKeyPath:nil   cacheName:nil];
    NSError *error = nil;
    if (![fetcher performFetch:&error])
    {
        NSLog(@"Error performing fetch: %@", error);
    }
	return fetcher;
}
#pragma mark -
#pragma mark update BuddyList
- (void) resetRosterStatus
{
    NSFetchedResultsController *frc = [self rosterFetcher];
    NSArray *sections = [frc sections];
    int sectionsCount = [sections count];
    for(int sectionIndex = 0; sectionIndex < sectionsCount; sectionIndex++)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        for(int j = 0; j < sectionInfo.numberOfObjects; j++)
        {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:sectionIndex];
            XMPPUserCoreDataStorageObject *user = [frc objectAtIndexPath:indexPath];
            [user setSection:2];
        }
    }
}
#pragma mark -
#pragma mark XMPPRoom Delegate
- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOFCDidJoinChatroom object:self];
}
- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOFCDidLeaveChatroom object:self];
}


#pragma mark -
#pragma mark XMPPMUC 
- (void)xmppMUC:(XMPPMUC *)sender didReceiveRoomInvitation:(XMPPMessage *)message
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kOFCReceiveInvitationNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)xmppMUC:(XMPPMUC *)sender didReceiveRoomInvitationDecline:(XMPPMessage *)message
{
    NSString *alertMessage = [NSString stringWithFormat:@"%@ decline the invitation",[message declineFromString]];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invitation Decline" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
