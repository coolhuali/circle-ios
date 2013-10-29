//
//  BlackListViewController.m
//  Circle
//
//  Created by admin on 13-9-29.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "BlackListViewController.h"

#import "ProfileTableViewCell.h"
#import "UserProfileViewController.h"
#import "MProfileInfo.h"
#import "MRelationBlacklist.h"

@interface BlackListViewController (){
    MRelationBlacklist *mRelation;
}
// Private helper methods
- (void) refreshDataSource;
- (void) loadNextSource;
@end

@implementation BlackListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    mRelation = [MRelationBlacklist alloc];
    self.title = NSLocalizedString(@"blacklist.title", nil);
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
#pragma mark - Pull to Refresh

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

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *item  = [items objectAtIndex:indexPath.row];
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
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
    NSDictionary *item = [items objectAtIndex:indexPath.row];
    UserProfileViewController *control = [[UserProfileViewController alloc] initWithProfileId:[item objectForKey:@"userid"] sourceType:@"black"];
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
        [mRelation remove:(NSString *)[item objectForKey:@"userid"] completed:^(NSObject *result, BOOL hasError) {
            if(hasError)return;
            [items removeObject:item];
            [self.tableView reloadData];
        }];
    }
}
@end