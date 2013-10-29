//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

#import "RecentListViewController.h"
#import "ProfileListViewController.h"
#import "ProfilePhotoViewController.h"
#import "FavoriteListViewController.h"
#import "FriendsListViewController.h"
#import "FansListViewController.h"
#import "BlackListViewController.h"

#import "RegisterFirstViewController.h"
#import "MyProfileViewController.h"
#import "MyLoginViewController.h"
#import "ChatViewController.h"
#import "MProfileInfo.h"
#import "MRecentMessage.h"
#import "MLoginInfo.h"

@interface DEMOMenuViewController (){
    MProfileInfo *mProfile;
    MRecentMessage *mRelation;
    NSString *paramsString;
    NSMutableArray *items;
    UILabel *userLabel;
    UIImageView *userHead;
}
@end
@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        userHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        userHead.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        //imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        userHead.layer.masksToBounds = YES;
        userHead.layer.cornerRadius = 50.0;
        userHead.layer.borderColor = [UIColor whiteColor].CGColor;
        userHead.layer.borderWidth = 3.0f;
        userHead.layer.rasterizationScale = [UIScreen mainScreen].scale;
        userHead.layer.shouldRasterize = YES;
        userHead.clipsToBounds = YES;
        [userHead setImageWithURL:[MLoginInfo getAvatarUrlCache:[MLoginInfo getActiveUserId]]];
        
        
        [userHead setUserInteractionEnabled:YES];
        UITapGestureRecognizer *_userSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myProfileHandleSingleTap:)];
        [userHead addGestureRecognizer:_userSingleTap];
        
        userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        userLabel.text = [MLoginInfo getActiveUserName];
        userLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        userLabel.backgroundColor = [UIColor clearColor];
        userLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [userLabel sizeToFit];
        userLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:userHead];
        [view addSubview:userLabel];
        view;
    });
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(authSuccess:)
     name:kOFCServerAuthedSuccess
     object:nil];
    
    items = [[NSMutableArray alloc] init];
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
    [mRelation list:1 completed:^(NSObject *result, BOOL hasError) {
        NSArray *dataItems = (NSArray *)result;
        if(hasError || dataItems.count<1){
            return;
        }
        [items setArray:dataItems];
        [self.tableView reloadData];
    }];
}
- (void)authSuccess:(NSNotification*)notification
{
    userLabel.text = [MLoginInfo getActiveUserName];
    [userHead setImageWithURL:[MLoginInfo getAvatarUrlCache:[MLoginInfo getActiveUserId]]];
}
-(void) myProfileHandleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    MyProfileViewController *controller = [[MyProfileViewController alloc] init];
    navigationController.viewControllers = @[controller];
    [self.frostedViewController hideMenuViewController];
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.8f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = NSLocalizedString(@"chat.title", nil);
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    if (indexPath.section == 0 && indexPath.row == 0) {
        MyLoginViewController *controller = [[MyLoginViewController alloc] init];
        navigationController.viewControllers = @[controller];
    }
    else if(indexPath.section == 0 && indexPath.row == 1) {
        ProfilePhotoViewController *controller = [[ProfilePhotoViewController alloc] init];
        navigationController.viewControllers = @[controller];
    }
    else if(indexPath.section == 0 && indexPath.row == 2) {
        FriendsListViewController *controller = [[FriendsListViewController alloc] init];
        navigationController.viewControllers = @[controller];
    }
    else  if(indexPath.section == 0 && indexPath.row == 3) {
        FavoriteListViewController *controller = [[FavoriteListViewController alloc] init];
        navigationController.viewControllers = @[controller];
    }
    else{
        if(items.count<=indexPath.row)return;
        NSDictionary *dict = [items objectAtIndex:indexPath.row];
        ChatViewController *controller = [[ChatViewController alloc] initWithId:[dict objectForKey:@"user"] isGroup:NO];
        navigationController.viewControllers = @[controller];
    }
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if(sectionIndex==0)
        return 4;
    else
        return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        NSArray *titles = @[NSLocalizedString(@"login.title", nil),NSLocalizedString(@"find.title", nil),NSLocalizedString(@"friends.title", nil),NSLocalizedString(@"favorite.title", nil)];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        if(items.count>indexPath.row){
            cell.textLabel.text = [items[indexPath.row] objectForKey:@"name"];
        }
    }
    return cell;
}

@end
