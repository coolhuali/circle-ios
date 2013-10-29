#import "XMPPRoomInfoCoreDataStorageObject.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


@interface XMPPRoomInfoCoreDataStorageObject ()
 
@property(nonatomic,strong) XMPPJID * primitiveRoomJID;
@property(nonatomic,strong) NSString * primitiveRoomJIDStr;
@property(nonatomic,strong) NSString * primitiveRoomName;
@property(nonatomic,strong) NSString * primitiveRoomPwd;
@property(nonatomic,strong) NSString * primitiveMyNickname;
@property(nonatomic,strong) NSString * primitiveRoomSubject;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation XMPPRoomInfoCoreDataStorageObject

@dynamic roomJID, primitiveRoomJID;
@dynamic roomJIDStr, primitiveRoomJIDStr;
@dynamic roomName, primitiveRoomName;
@dynamic roomSubject, primitiveRoomSubject;
@dynamic roomPwd, primitiveRoomPwd;
@dynamic myNickname, primitiveMyNickname;
@dynamic createdAt;
@dynamic deleted;
@dynamic streamBareJidStr;
 
#pragma mark Transient roomJID

- (XMPPJID *)roomJID
{
	// Create and cache on demand
	
	[self willAccessValueForKey:@"roomJID"];
	XMPPJID *tmp = self.primitiveRoomJID;
	[self didAccessValueForKey:@"roomJID"];
	
	if (tmp == nil)
	{
		NSString *roomJIDStr = self.roomJIDStr;
		if (roomJIDStr)
		{
			tmp = [XMPPJID jidWithString:roomJIDStr];
			self.primitiveRoomJID = tmp;
		}
	}
	
	return tmp;
}

- (void)setRoomJID:(XMPPJID *)roomJID
{
	[self willChangeValueForKey:@"roomJID"];
	[self willChangeValueForKey:@"roomJIDStr"];
	
	self.primitiveRoomJID = roomJID;
	self.primitiveRoomJIDStr = [roomJID full];
	
	[self didChangeValueForKey:@"roomJID"];
	[self didChangeValueForKey:@"roomJIDStr"];
}

- (void)setRoomJIDStr:(NSString *)roomJIDStr
{
	[self willChangeValueForKey:@"roomJID"];
	[self willChangeValueForKey:@"roomJIDStr"];
	
	self.primitiveRoomJID = [XMPPJID jidWithString:roomJIDStr];
	self.primitiveRoomJIDStr = roomJIDStr;
	
	[self didChangeValueForKey:@"roomJID"];
	[self didChangeValueForKey:@"roomJIDStr"];
}
- (void)setRoomName:(NSString *)roomName
{ 
	[self willChangeValueForKey:@"roomName"];
	 
	self.primitiveRoomName = roomName;
	 
	[self didChangeValueForKey:@"roomName"];
}
- (void)setRoomPwd:(NSString *)roomPwd
{
	[self willChangeValueForKey:@"roomPwd"];
    
	self.primitiveRoomPwd = roomPwd;
    
	[self didChangeValueForKey:@"roomPwd"];
}
- (void)setMyNickname:(NSString *)myNickname
{
	[self willChangeValueForKey:@"myNickname"];
    
	self.primitiveMyNickname = myNickname;
    
	[self didChangeValueForKey:@"myNickname"];
}
- (void)setRoomSubject:(NSString *)roomSubject
{
	[self willChangeValueForKey:@"roomSubject"];
    
	self.primitiveRoomSubject = roomSubject;
    
	[self didChangeValueForKey:@"roomSubject"];
}
@end
