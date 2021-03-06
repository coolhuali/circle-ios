//
//  OFCSelectBuddysViewController.m
//  OpenFireClient
//
//  Created by CTI AD on 21/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCSelectBuddysViewController.h"
#import "OFCXMPPManager.h"
#import "OFCBuddy.h"
#import "OFCXMPPManager.h"
@interface OFCSelectBuddysViewController ()

@end

@implementation OFCSelectBuddysViewController
 
@synthesize buddyListTableView;
@synthesize createButton;
@synthesize navigationBar;
- (id)init
{
    self = [super init];
    if(self){
        self.title = NSLocalizedString(@"select.title", nil);
        buddyListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        buddyListTableView.dataSource = self;
        buddyListTableView.delegate = self;
         
        
        navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        UINavigationItem *item =[[UINavigationItem alloc]initWithTitle:@"New Group"];
        item.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"cancel"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(dismissView)];
        
        item.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(createChatroom)];
        [navigationBar pushNavigationItem:item animated:NO];
        rosterFetchedResultsController = [[OFCXMPPManager sharedManager] rosterFetcher];
        rosterFetchedResultsController.delegate = self;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [buddyListTableView setFrame:CGRectMake(0, 40, 320, 440)];
    [buddyListTableView setEditing:YES];
    [buddyListTableView setAllowsMultipleSelectionDuringEditing : YES];
    [self.view addSubview:buddyListTableView];
    [self.view addSubview:navigationBar];
	// Do any additional setup after loading the view.
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count= [[rosterFetchedResultsController fetchedObjects] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"selectBuddyListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    XMPPUserCoreDataStorageObject *user = [rosterFetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [user.jid user];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)createChatroom
{
    [self dismissView];
    NSMutableArray *selectedBuddy = [NSMutableArray arrayWithCapacity:self.buddyListTableView.indexPathsForSelectedRows.count];
    for (NSIndexPath *indexPath in self.buddyListTableView.indexPathsForSelectedRows) {
        XMPPUserCoreDataStorageObject *user = [rosterFetchedResultsController objectAtIndexPath:indexPath];
        [selectedBuddy addObject:[user jid]];
    }
    [[OFCXMPPManager sharedManager] inviteFriendsToJoinChatroom:selectedBuddy];
}

- (void)dismissView
{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark NSFetchedResultsController Delegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [buddyListTableView reloadData];
}
@end
