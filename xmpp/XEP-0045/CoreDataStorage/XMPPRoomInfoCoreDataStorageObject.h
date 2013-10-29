//
//  XMPPRoomCoreDataStorageObject.h
//  OpenFireClient
//
//  Created by admin on 13-7-3.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "XMPP.h"
#import "XMPPRoom.h"
#import "XMPPRoomInfo.h"

@interface XMPPRoomInfoCoreDataStorageObject : NSManagedObject <XMPPRoomInfo>

/**
 * The properties below are documented in the XMPPRoomInfo protocol.
 **/
 
@property (nonatomic, strong) XMPPJID * roomJID;       // Transient (proper type, not on disk)
@property (nonatomic, strong) NSString * roomJIDStr;   // Shadow (binary data, written to disk)
@property (nonatomic, strong) NSString * roomName;   // Shadow (binary data, written to disk)
@property (nonatomic, strong) NSString * roomSubject;   // Shadow (binary data, written to disk)
@property (nonatomic, strong) NSString * roomPwd;   // Shadow (binary data, written to disk)

@property (nonatomic, strong) NSString * myNickname;   // Shadow (binary data, written to disk)
 
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic) int * deleted;

/**
 * If a single instance of XMPPRoomCoreDataStorage is shared between multiple xmppStream's,
 * this may be needed to distinguish between the streams.
 **/
@property (nonatomic, strong) NSString * streamBareJidStr;

@end
