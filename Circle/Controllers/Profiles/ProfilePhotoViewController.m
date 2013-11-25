//
//  ProfilePhotoViewController.m
//  Circle
//
//  Created by admin on 13-10-23.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "ProfilePhotoViewController.h"
#import "UserProfileViewController.h"
#import "SearchProfileViewController.h"
#import "MProfileInfo.h"
#import "MRelationFavorite.h"
#import "OFCXMPPManager.h"

@interface ProfilePhotoViewController (){
    MProfileInfo *mProfile;
    MRelationFavorite *mRelation;
    NSString *paramsString;
}
// Private helper methods
- (void) refreshDataSource;
- (void) loadNextSource;
@end

@implementation ProfilePhotoViewController
- (id) init
{
    self = [super init];
    if (self){
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(authSuccess:)
         name:kOFCServerAuthedSuccess
         object:nil];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad
{
    [super viewDidLoad];
    [super showMenuItem];
    mProfile = [MProfileInfo alloc];//1
    mRelation = [MRelationFavorite alloc ];
    self.title = NSLocalizedString(@"find.title", nil);
    [self setupHeader];
    [self setupFooter];
    [self doSearchItems];
    if([[OFCXMPPManager sharedManager] hasAuthed])
    {
        [self refresh];
    }
}
- (void)authSuccess:(NSNotification*)notification
{
    [self refresh];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewFullProile:(NSDictionary *)dict{
    UserProfileViewController *controller = [[UserProfileViewController alloc] initWithProfileId:[dict objectForKey:@"userid"] sourceType:@"profiles"];
    [self.navigationController pushViewController:controller animated:YES];
    
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
        int max = dataItems.count;
        [items removeAllObjects];
        for (int i=0;i<max;i=i+4) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if(i<max)[array addObject:dataItems[i]];
            if(i+1<max)[array addObject:dataItems[i+1]];
            if(i+2<max)[array addObject:dataItems[i+2]];
            if(i+3<max)[array addObject:dataItems[i+3]];
            [items addObject:array];
        }
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
        int max = dataItems.count;
        for (int i=0;i<max;i=i+4) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if(i<max)[array addObject:dataItems[i]];
            if(i+1<max)[array addObject:dataItems[i+1]];
            if(i+2<max)[array addObject:dataItems[i+2]];
            if(i+3<max)[array addObject:dataItems[i+3]];
            [items addObject:array];
        }
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
    NSArray *item  = [items objectAtIndex:indexPath.row];
    ProfilePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProfilePhotoCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    [cell setUnionObject:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEAD_SIZE+INSETS+TEXT_SIZE;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
