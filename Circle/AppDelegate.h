//
//  AppDelegate.h
//  OpenFireClient
//
//  Created by CTI AD on 29/10/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "OFCXMPPManager.h"
#import "MAppStrings.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "BUPOViewController.h"

#define  sharedDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) OFCXMPPManager *xmppManager;

@property (nonatomic, retain) NSTimer *backgroundTimer;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@property (nonatomic) BOOL didShowDisconnectionWarning;

@property (nonatomic, strong)  UINavigationController *navigationController;

@end
