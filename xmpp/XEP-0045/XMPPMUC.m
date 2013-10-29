#import "XMPPMUC.h"
#import "XMPPFramework.h"
#import "XMPPIDTracker.h"


@implementation XMPPMUC

- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
	if ((self = [super initWithDispatchQueue:queue]))
	{
		rooms = [[NSMutableSet alloc] init];
	}
	return self;
}

- (BOOL)activate:(XMPPStream *)aXmppStream
{
	if ([super activate:aXmppStream])
	{
		responseTracker = [[XMPPIDTracker alloc] initWithDispatchQueue:moduleQueue];
#ifdef _XMPP_CAPABILITIES_H
		[xmppStream autoAddDelegate:self delegateQueue:moduleQueue toModulesOfClass:[XMPPCapabilities class]];
#endif
		return YES;
	}
	
	return NO;
}

- (void)deactivate
{
#ifdef _XMPP_CAPABILITIES_H
	[xmppStream removeAutoDelegate:self delegateQueue:moduleQueue fromModulesOfClass:[XMPPCapabilities class]];
#endif
	
	[super deactivate];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)leaveRoom:(XMPPJID *)roomJID
{
	dispatch_block_t block = ^{ @autoreleasepool { 
		//<presence type='unavailable' to='darkcave@chat.shakespeare.lit/thirdwitch'/> 
		XMPPPresence *presence = [XMPPPresence presence];
		[presence addAttributeWithName:@"from" stringValue:[[xmppStream myJID] full]];
		[presence addAttributeWithName:@"to" stringValue:[roomJID full]];
		[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
		[xmppStream sendElement:presence];
	}};
	if (dispatch_get_current_queue() == moduleQueue)
		block();
	else
		dispatch_async(moduleQueue, block);
}
 
- (void)destoryRoom:(XMPPJID *)roomJID
{
	dispatch_block_t block = ^{ @autoreleasepool {
		// <iq type="set" to="roomName" id="abc123">
		//   <query xmlns="http://jabber.org/protocol/muc#owner">
		//     <destroy/>
		//   </query>
		// </iq>
		
		NSXMLElement *destroy = [NSXMLElement elementWithName:@"destroy"];
		
		NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:XMPPMUCOwnerNamespace];
		[query addChild:destroy];
		
		NSString *iqID = [xmppStream generateUUID];
		
		XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:roomJID elementID:iqID child:query];
		
		[xmppStream sendElement:iq];
	}};
	
	if (dispatch_get_current_queue() == moduleQueue)
		block();
	else
		dispatch_async(moduleQueue, block);
}

- (BOOL)isMUCRoomElement:(XMPPElement *)element
{
	XMPPJID *bareFrom = [[element from] bareJID];
	if (bareFrom == nil)
	{
		return NO;
	}
	
	__block BOOL result = NO;
	
	dispatch_block_t block = ^{ @autoreleasepool {
		
		result = [rooms containsObject:bareFrom];
		
	}};
	
	if (dispatch_get_current_queue() == moduleQueue)
		block();
	else
		dispatch_sync(moduleQueue, block);
	
	return result;
}

- (BOOL)isMUCRoomPresence:(XMPPPresence *)presence
{
	return [self isMUCRoomElement:presence];
}

- (BOOL)isMUCRoomMessage:(XMPPMessage *)message
{
	return [self isMUCRoomElement:message];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender didRegisterModule:(id)module
{
	if ([module isKindOfClass:[XMPPRoom class]])
	{
		XMPPJID *roomJID = [(XMPPRoom *)module roomJID];
		if(roomJID){
            [rooms addObject:roomJID];
        }
	}
}

- (void)xmppStream:(XMPPStream *)sender willUnregisterModule:(id)module
{
	if ([module isKindOfClass:[XMPPRoom class]])
	{
		XMPPJID *roomJID = [(XMPPRoom *)module roomJID];
		if(!roomJID)return;

		// It's common for the room to get deactivated and deallocated before
		// we've received the goodbye presence from the server.
		// So we're going to postpone for a bit removing the roomJID from the list.
		// This way the isMUCRoomElement will still remain accurate
		// for presence elements that may arrive momentarily.
		
		double delayInSeconds = 30.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, moduleQueue, ^{ @autoreleasepool {
			
			[rooms removeObject:roomJID];
		}});
	}
}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	NSString *type = [iq type];
	if ([type isEqualToString:@"result"] || [type isEqualToString:@"error"])
	{
		return [responseTracker invokeForID:[iq elementID] withObject:iq];
	}
	return NO;
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	// Examples from XEP-0045:
	// 
	// 
	// Example 124. Room Sends Invitation to New Member:
	// 
	// <message from='darkcave@chat.shakespeare.lit' to='hecate@shakespeare.lit'>
	//   <x xmlns='http://jabber.org/protocol/muc#user'>
	//     <invite from='bard@shakespeare.lit'/>
	//     <password>cauldronburn</password>
	//   </x>
	// </message>
	// 
	// 
	// Example 125. Service Returns Error on Attempt by Mere Member to Invite Others to a Members-Only Room
	// 
	// <message from='darkcave@chat.shakespeare.lit' to='hag66@shakespeare.lit/pda' type='error'>
	//   <x xmlns='http://jabber.org/protocol/muc#user'>
	//     <invite to='hecate@shakespeare.lit'>
	//       <reason>
	//         Hey Hecate, this is the place for all good witches!
	//       </reason>
	//     </invite>
	//   </x>
	//   <error type='auth'>
	//     <forbidden xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
	//   </error>
	// </message>
	// 
	// 
	// Example 50. Room Informs Invitor that Invitation Was Declined
	// 
	// <message from='darkcave@chat.shakespeare.lit' to='crone1@shakespeare.lit/desktop'>
	//   <x xmlns='http://jabber.org/protocol/muc#user'>
	//     <decline from='hecate@shakespeare.lit'>
	//       <reason>
	//         Sorry, I'm too busy right now.
	//       </reason>
	//     </decline>
	//   </x>
	// </message>
	// 
	// 
	// Examples from XEP-0249:
	// 
	// 
	// Example 1. A direct invitation
	// 
	// <message from='crone1@shakespeare.lit/desktop' to='hecate@shakespeare.lit'>
	//   <x xmlns='jabber:x:conference'
	//      jid='darkcave@macbeth.shakespeare.lit'
	//      password='cauldronburn'
	//      reason='Hey Hecate, this is the place for all good witches!'/>
	// </message>
	
	NSXMLElement * x = [message elementForName:@"x" xmlns:XMPPMUCUserNamespace];
	NSXMLElement * invite  = [x elementForName:@"invite"];
	NSXMLElement * decline = [x elementForName:@"decline"];
	
	NSXMLElement * directInvite = [message elementForName:@"x" xmlns:@"jabber:x:conference"];
	
	if (invite || directInvite)
	{
		[multicastDelegate xmppMUC:self didReceiveRoomInvitation:message];
	}
	else if (decline)
	{
		[multicastDelegate xmppMUC:self didReceiveRoomInvitationDecline:message];
	}
}

#ifdef _XMPP_CAPABILITIES_H
/**
 * If an XMPPCapabilites instance is used we want to advertise our support for MUC.
**/
- (void)xmppCapabilities:(XMPPCapabilities *)sender collectingMyCapabilities:(NSXMLElement *)query
{
	// This method is invoked on our moduleQueue.
	
	// <query xmlns="http://jabber.org/protocol/disco#info">
	//   ...
	//   <feature var='http://jabber.org/protocol/muc'/>
	//   ...
	// </query>
	
	NSXMLElement *feature = [NSXMLElement elementWithName:@"feature"];
	[feature addAttributeWithName:@"var" stringValue:@"http://jabber.org/protocol/muc"];
	
	[query addChild:feature];
}
#endif

@end
