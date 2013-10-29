//
//  RecentListViewController.m
//  Circle
//
//  Created by admin on 13-10-8.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "RecentListViewController.h"
#import "MessageRecentCell.h"
#import "UserProfileViewController.h"
#import "MLoginInfo.h"
#import "MRecentMessage.h"
#import "ChatViewController.h"
@interface RecentListViewController (){
    MRecentMessage *mRelation;
}
// Private helper methods
- (void) refreshDataSource;
- (void) loadNextSource;
@end

@implementation RecentListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    mRelation = [[MRecentMessage alloc] initWithId:[MLoginInfo getActiveUserId] push:^(NSObject *result,MDataOperator mDataOperator,BOOL hasError) {
        if(hasError)return;
        if(mDataOperator == MDataOperatorForAdd){
            [items addObject:result];
        }
        else if(mDataOperator == MDataOperatorForUpdate){
            [MRecentMessage findForArray:items target:(NSDictionary *)result forKey:@"user" replaceKeys:[NSArray arrayWithObjects:@"body",nil]];
        }
        [self.tableView reloadData];
    }];
    self.title = NSLocalizedString(@"chat.title", nil);
    self.tableView.separatorColor=[UIColor clearColor];
    [self setupHeader];
    [self setupFooter];
    [self undoEditItems];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"menu", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    [self refresh];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(newMessageReceived:)
												 name:kOFCMessageNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kOFCMessageNotification object:nil];
}
-(void)newMessageReceived:(NSNotification *)notification
{
    XMPPJID *from = [[notification userInfo] objectForKey:FROM_JID];
    //NSString *body = [[notification userInfo] objectForKey:MESSAGE_BODY];
    for (NSMutableDictionary *dict in items) {
        if([[dict objectForKey:@"jid"] isEqualToString:[from bare]]){
            NSNumber *count = (NSNumber*)[dict objectForKey:@"msgcount"];
            [dict setValue:[NSNumber numberWithInt:count.integerValue+1] forKey:@"msgcount"];
        }
    }
    [self.tableView reloadData];
    
}
- (void)doEditItems
{
    [self setTableEditing:true];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target: self action:@selector(undoEditItems)];
}
- (void)undoEditItems
{
    [self setTableEditing:false];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target: self action:@selector(doEditItems)];
}

//
// refresh the list. Do your async calls here.
//
- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    [self refreshDataSource];
    return YES;
}

#pragma mark - Load More

- (BOOL) loadMore
{
    if (![super loadMore])
        return NO;
    [self loadNextSource];
    return YES;
}
#pragma mark - Dummy data methods

- (void) refreshDataSource
{
    page = 1;
    [mRelation list:page completed:^(NSObject *result, BOOL hasError) {
        [self refreshCompleted];
        NSArray *dataItems = (NSArray *)result;
        if(hasError || dataItems.count<1){
            page--;
            return;
        }
        [items setArray:dataItems];
        [self.tableView reloadData];
    }];
}
- (void) loadNextSource
{
    if(items.count < API_LOAD_PAGE_SIZE){
        [self loadMoreCompleted];
        return;
    }
    page++;
    [mRelation list:page completed:^(NSObject *result, BOOL hasError) {
        [self loadMoreCompleted];
        NSArray *dataItems = (NSArray *)result;
        if(hasError || dataItems.count<1){
            page--;
            return;
        }
        [items addObjectsFromArray:dataItems];
        [self.tableView reloadData];
    }];
}

#pragma mark - Standard TableView delegates

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *item  = [items objectAtIndex:indexPath.row];
    MessageRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MessageRecentCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CellIdentifier];
    }
    [cell setUnionObject:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [items objectAtIndex:indexPath.row];
    ChatViewController *control = [[ChatViewController alloc] initWithId:[dict objectForKey:@"user"] isGroup:NO];
    [self.navigationController pushViewController:control animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *item  = [items objectAtIndex:indexPath.row];
        [mRelation remove:(NSString *)[item objectForKey:@"jid"] completed:^(NSObject *result, BOOL hasError) {
            if(hasError)return;
            [items removeObject:item];
            [self.tableView reloadData];
        }];
    }
}
@end

