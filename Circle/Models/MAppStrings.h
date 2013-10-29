//
//  MAppStrings.h
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//
#define IMAGE_RADIUS 5.0f

#define API_UPLOAD_IMAGE_URL @"http://test.fsop.caac.gov.cn/im_rest/media?TK=0987654321"
#define API_UPLOAD_AUDIO_URL @"http://test.fsop.caac.gov.cn/im_rest/media/audio?TK=0987654321"

#define API_UPLOAD_AVATAR_URL @"http://test.fsop.caac.gov.cn/im_rest/media/avatar?TK=0987654321"
#define API_DOWN_IMAGE_URL @"http://test.fsop.caac.gov.cn/im_file/%@?TK=0987654321"
#define API_LOCATION_UPDATE_URL @"http://test.fsop.caac.gov.cn/im_rest/location?TK=0987654321"

#define API_AUTH_LOGIN_URL @"http://test.fsop.caac.gov.cn/im_rest/auth/login?TK=0987654321"
#define API_AUTH_LOGOUT_URL @"http://test.fsop.caac.gov.cn/im_rest/auth/logout?TK=0987654321"

#define API_PROFILE_EXISTS_URL @"http://test.fsop.caac.gov.cn/im_rest/auth/exist/%@?TK=0987654321"
#define API_PROFILE_CHECK_URL @"http://test.fsop.caac.gov.cn/im_rest/auth/check?TK=0987654321"

#define API_PROFILE_ADD_URL @"http://test.fsop.caac.gov.cn/im_rest/auth/%@?TK=0987654321"
#define API_PROFILE_EDIT_URL @"http://test.fsop.caac.gov.cn/im_rest/user?TK=0987654321"
#define API_PROFILE_GET_URL @"http://test.fsop.caac.gov.cn/im_rest/user/%@?TK=0987654321"
#define API_PROFILE_SEARCH_URL @"http://test.fsop.caac.gov.cn/im_rest/user/list/%@?TK=0987654321&%@"
#define API_PROFILE_DELETE_URL @"http://test.fsop.caac.gov.cn/im_rest/user/%@?TK=0987654321"


#define API_RELATION_FAVORITE_LIST_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/favorite/%@?TK=0987654321"
#define API_RELATION_FAVORITE_ADD_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/favorite?TK=0987654321"
#define API_RELATION_FAVORITE_DELETE_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/favorite/%@?TK=0987654321"

#define API_RELATION_ATTENTION_LIST_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/attention/%@?TK=0987654321"
#define API_RELATION_ATTENTION_ADD_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/attention?TK=0987654321"
#define API_RELATION_ATTENTION_DELETE_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/attention/%@?TK=0987654321"

#define API_RELATION_FRIENDS_LIST_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/friends/%@?TK=0987654321"
#define API_RELATION_FRIENDS_ADD_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/friends?TK=0987654321"
#define API_RELATION_FRIENDS_DELETE_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/friends/%@?TK=0987654321"

#define API_RELATION_FANS_LIST_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/fans/%@?TK=0987654321"
#define API_RELATION_FANS_ADD_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/fans?TK=0987654321"
#define API_RELATION_FANS_DELETE_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/fans/%@?TK=0987654321"

#define API_RELATION_BLACK_LIST_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/blacklist/%@?TK=0987654321"
#define API_RELATION_BLACK_ADD_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/blacklist?TK=0987654321"
#define API_RELATION_BLACK_DELETE_URL @"http://test.fsop.caac.gov.cn/im_rest/relation/blacklist/%@?TK=0987654321"

#define API_LOAD_PAGE_SIZE 10

#define IGNORE_STRING @"Ignore"
#define REPLY_STRING @"Reply"
#define CHAT_STRING @"Chat"

#define FROM_JID @"FromJID"
#define MESSAGE_BODY @"MessageBody"


//Notification
#define kOFCServerRegisterSuccess @"registerSuccessNotification"
#define kOFCServerRegisterFail @"registerFailNotification"

#define kOFCServerConnectSuccess @"connectSuccessNotification"
#define kOFCServerConnectFail @"connectFailNotification"

#define kOFCServerAuthedSuccess @"authedSuccessNotification"
#define kOFCServerAuthedFail @"authedFailNotification"


#define kOFCNickNameConflictNotification @"nickNameConflictNotification"
#define kOFCMessageNotification @"messageNotification"
#define kOFCDidQueuedNotification @"messageDidQueuedNotification"
#define kOFCReceiveInvitationNotification @"receiveInvitationNotification"
#define kOFCSearchResultNotification @"searchResultNotification"



#define kOFCXMPPResource @"ios"
#define kOFCStatusUpdate @"statusUpdate"
#define kOFCBuddyListUpdate @"buddyListUpdate"
#define kOFCReceiveGroupChat @"receiveGroupChat"
#define kOFCSendMessages @"sendMessages"

#define kOFCSendGroupChat @"sendGroupChat"
#define KOFCDateFormatter @"yyyy-MM-dd HH:mm:ss"
#define kOFCIQChatroomID @"XEP0045"


#define kOFCDidJoinChatroom @"didJoinChatroom"
#define kOFCDidLeaveChatroom @"didLeaveChatroom"

#define kOFCXMPPServerHost @"test.fsop.caac.gov.cn"
#define kOFCXMPPServerPort 8009

#define XMPP_ERROR @"error"
#define XMPP_ERROR_CONFILCT @"conflict"
#define XMPP_ERROR_CONFILCT_NS @"urn:ietf:params:xml:ns:xmpp-stanzas"
#define XMPP_CHATROOM_LOCKED @"This room is locked from entry until configuration is confirmed."
#define XMPP_CHATROOM_UNLOCKED @"This room is now unlocked."

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
