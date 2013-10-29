//
//  OFCSelectBuddysViewController.h
//  OpenFireClient
//
//  Created by CTI AD on 21/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface OFCSelectBuddysViewController : UIViewController <UITableViewDataSource , UITableViewDelegate,NSFetchedResultsControllerDelegate>
{
    UITableView *buddyListTableView; 
    UIButton *createButton;
    UINavigationBar *navigationBar;
    NSFetchedResultsController *rosterFetchedResultsController;
}
@property (nonatomic, strong) UITableView *buddyListTableView; 
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@end
