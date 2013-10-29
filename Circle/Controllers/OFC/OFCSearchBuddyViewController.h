//
//  OFCSearchBuddyViewController.h
//  OpenFireClient
//
//  Created by CTI AD on 14/1/13.
//  Copyright (c) 2013 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFCXMPPManager.h"

@interface OFCSearchBuddyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>{
    
    UITableView *resultsTableView;
    UISearchBar *search;
    NSArray *results;
    BOOL    isSearching;
}

@property (nonatomic, strong) IBOutlet UITableView *resultsTableView;
@property (nonatomic, strong) IBOutlet UISearchBar *search;
@property (nonatomic, strong) NSArray *results;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;
@end
