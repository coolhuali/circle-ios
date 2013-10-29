//
//  ProfileListViewController.m
//  OpenFireClient
//
//  Created by admin on 13-9-26.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "OFCBuddyListViewController.h"
#import "ProfileTableViewCell.h"
#import "UserProfileViewController.h"
#import "SearchProfileViewController.h"
#import "ChatViewController.h"
#import "MRosterInfo.h"
#import "MLoginInfo.h"

@interface OFCBuddyListViewController (){
    MRosterInfo *mRoster;
    NSString *paramsString;
}
// Private helper methods
- (void) refreshDataSource;
- (void) loadNextSource;
@end

@implementation OFCBuddyListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    mRoster = [[MRosterInfo alloc]initWithId:[MLoginInfo getActiveUserId] push:^(NSObject *result, MDataOperator mDataOperator,BOOL hasError) {
        if(hasError)return;
        [items addObject:result];
    }];
    self.title = NSLocalizedString(@"chat.title", nil);
    [self setupHeader];
    [self setupFooter];
    [self doSearchItems];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reveiveMessage:)
												 name:kOFCMessageNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kOFCMessageNotification object:nil];
}

- (void)reveiveMessage:(NSNotification *)notification{
    
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
    [mRoster list:page completed:^(NSObject *result, BOOL hasError) {
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
    [mRoster list:page completed:^(NSObject *result, BOOL hasError) {
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
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CellIdentifier];
        if([item objectForKey:@"img"]){
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_DOWN_IMAGE_URL,[item objectForKey:@"img"]]];
            UIImage *image = [[SDWebImageManager sharedManager] imageWithUrl:url];
            if(image){
                cell.imageView.image = image;
            }
            else{
                [[SDWebImageManager sharedManager] downloadWithURL:url options:SDWebImageLowPriority progress:nil completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                    cell.imageView.image = aImage;
                }];
            }
        }
    }
    if([item objectForKey:@"img"]){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_DOWN_IMAGE_URL,[item objectForKey:@"img"]]];
        UIImage *image = [[SDWebImageManager sharedManager] imageWithUrl:url];
        if(image){
            cell.imageView.image = image;
        }
    }
    cell.textLabel.text = [item objectForKey:@"name"];
    cell.detailTextLabel.text = [item objectForKey:@"sign"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [items objectAtIndex:indexPath.row];
    ChatViewController *control = [[ChatViewController alloc] initWithId:[dict objectForKey:@"jid"] isGroup:NO];
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
        [mRoster remove:(NSString *)[item objectForKey:@"jid"] completed:^(NSObject *result, BOOL hasError) {
            if(hasError)return;
            [items removeObject:item];
            [self.tableView reloadData];
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
