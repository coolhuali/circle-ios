#import <Foundation/Foundation.h>

@class XMPPJID; 


@protocol XMPPRoomInfo <NSObject>
 
/**
 * The MUC room the roominfo is associated with.
 **/
- (XMPPJID *)roomJID;

@end
