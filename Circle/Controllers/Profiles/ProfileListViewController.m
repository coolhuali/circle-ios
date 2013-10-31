//
//  ProfileListViewController.m
//  OpenFireClient
//
//  Created by admin on 13-9-26.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "ProfileListViewController.h" 
#import "ProfileTableViewCell.h" 
#import "UserProfileViewController.h"
#import "SearchProfileViewController.h"
#import "MProfileInfo.h"
#import "MRelationFavorite.h"

@interface ProfileListViewController (){
    MProfileInfo *mProfile;
    MRelationFavorite *mRelation;
    NSString *paramsString;
}
// Private helper methods
- (void) refreshDataSource;
- (void) loadNextSource;
@end

@implementation ProfileListViewController

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad
{
    [super viewDidLoad];
    [super showMenuItem];
    mProfile = [MProfileInfo alloc];
    mRelation = [MRelationFavorite alloc ];
    self.title = NSLocalizedString(@"find.title", nil);
    [self setupHeader];
    [self setupFooter];
    [self doSearchItems]; 
    [self refresh];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Dummy data methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) refreshDataSource
{
    page = 1; 
    [mProfile list:paramsString page:page completed:^(NSObject *result, BOOL hasError) {
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

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadNextSource
{
    if(items.count < API_LOAD_PAGE_SIZE){
        [self loadMoreCompleted];
        return;
    }
    page++;
    [mProfile list:paramsString page:page completed:^(NSObject *result, BOOL hasError) {
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
 
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
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
    UserProfileViewController *control = [[UserProfileViewController alloc] initWithProfileId:[item objectForKey:@"userid"] sourceType:@"profiles"];
    [self.navigationController pushViewController:control animated:YES]; 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSDictionary *item  = [items objectAtIndex:indexPath.row];
        [mRelation post:(NSString *)[item objectForKey:@"userid"] completed:^(NSObject *result, BOOL hasError) {
            if(hasError)return;
        }];
    }
}
- (void)popSearchProfileView{
    SearchProfileViewController *control = [[SearchProfileViewController alloc]init];
    control.completedBlock = ^(NSObject *result,BOOL hasError){
        paramsString = (NSString *)result;
        [self refreshDataSource];
    };
    [self presentViewController:control animated:YES completion:nil];
}
- (void)doSearchItems
{
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(popSearchProfileView)];
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
@end
