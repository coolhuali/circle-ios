//
//  OFCRegisterNextController.m
//  OpenFireClient
//
//  Created by admin on 13-9-24.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

 
#import "UserProfileViewController.h"
#import "OFCBuddyListViewController.h"
#import "FavoriteListViewController.h"
#import "ProfileListViewController.h"
#import "FriendsListViewController.h"
#import "FansListViewController.h"
#import "BlackListViewController.h"
#import "AttentionListViewController.h"
#import "BaseMessageViewController.h"
#import "ImageSourceViewController.h"
#import "MProfileInfo.h"
#import "MRelationFavorite.h"
#import "MRelationAttention.h"
#import "MRelationBlacklist.h"
#import "MRelationFans.h"
#import "MRelationFriends.h"
#import "MLoginInfo.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface UserProfileViewController(){
    NSDictionary *curProfile;
}
@end

@implementation UserProfileViewController
@synthesize formItems;
- (id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}
//sourceType:profiles,black,fans,sub,fav,friends
- (id) initWithProfileId:(NSString *)profileId  sourceType:(NSString *)sourceType
{
    self = [super init];
    if(self){
        _profileId = profileId;
        _sourceType = sourceType;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"profile.title", nil);
    [self.settingsTableView setDataSource:self];
    [self.settingsTableView setDelegate:self];
    [self loadProfileInfo:_profileId];
}
- (void) viewDidUnload
{
    [super viewDidUnload]; 
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadProfileInfo:(NSString *)userId{
    [[MProfileInfo alloc] get:userId completed:^(NSObject *result, BOOL hasError) {
        if(hasError)return;
        NSDictionary * data  = (NSDictionary *)result;
        if(data !=nil){
            curProfile = data;
            [self setProfileInfo:data];
            [self.settingsTableView reloadData];
        }
    }];
}
- (void)setProfileInfo:(NSDictionary *)dict{
    self.title = [dict objectForKey:@"name"];
    OFCLabelSetting *nameSetting = [[OFCLabelSetting alloc]initWithText:@"register.label.name" value:[dict objectForKey:@"name"] useKey:NO];
    OFCLabelSetting *genderSetting = [[OFCLabelSetting alloc]initWithText:@"register.label.sex" value:[dict objectForKey:@"sex"] useKey:NO];
    OFCLabelSetting *disciplineSetting = [[OFCLabelSetting alloc]initWithText:@"register.label.major" value:[dict objectForKey:@"major"] useKey:NO];
    OFCLabelSetting *complanySetting = [[OFCLabelSetting alloc]initWithText:@"register.label.org" value:[dict objectForKey:@"org"] useKey:NO];
     
    OFCLabelSetting *modelSetting = [[OFCLabelSetting alloc]initWithText:@"register.label.model" value:[dict objectForKey:@"model"] useKey:NO];
    
    OFCLabelSetting *citySetting = [[OFCLabelSetting alloc]initWithText:@"register.label.city" value:[dict objectForKey:@"city"] useKey:NO];
    
    OFCLabelSetting *signSetting = [[OFCLabelSetting alloc]initWithText:@"register.label.sign" value:[dict objectForKey:@"sign"] useKey:NO];
    
    OFCLabelSetting *purposeSetting = [[OFCLabelSetting alloc]initWithText:@"register.label.purpose" value:[dict objectForKey:@"purpose"] useKey:NO];
    
    
    OFCLabelSetting *emailSetting = [[OFCLabelSetting alloc]initWithText:@"register.label.email" value:[dict objectForKey:@"email"] useKey:NO];
    
    
    OFCLabelSetting *mobileSetting = [[OFCLabelSetting alloc]initWithText:@"register.label.mobile" value:[dict objectForKey:@"mobile"] useKey:NO];
    
    OFCImageSetting *imgSetting = [[OFCImageSetting alloc]initWithText:@"register.label.img" value:[dict objectForKey:@"img"] useKey:NO];
    
    formItems = [[OFCSettingsGroup alloc] initWithTitle:@"register.title" settings:[NSArray arrayWithObjects:imgSetting,nameSetting,genderSetting,disciplineSetting,complanySetting,modelSetting,signSetting,mobileSetting,emailSetting,citySetting,purposeSetting,nil]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(profileAction:)];
}
- (void)profileAction:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"action.title", @"")
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil,nil];
    if([@"profiles" isEqualToString:_sourceType]){
        [sheet addButtonWithTitle:NSLocalizedString(@"action.fav", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.sub", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.friend", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.black", @"")];
    }
    else if([@"friends" isEqualToString:_sourceType]){
        [sheet addButtonWithTitle:NSLocalizedString(@"action.message", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.remove", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.black", @"")];
    }
    else if([@"fav" isEqualToString:_sourceType]){
        [sheet addButtonWithTitle:NSLocalizedString(@"action.message", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.remove", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.black", @"")];
    }
    else if([@"sub" isEqualToString:_sourceType]){
        [sheet addButtonWithTitle:NSLocalizedString(@"action.remove", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.black", @"")];
    }
    else if([@"fans" isEqualToString:_sourceType]){
        [sheet addButtonWithTitle:NSLocalizedString(@"action.remove", @"")];
        [sheet addButtonWithTitle:NSLocalizedString(@"action.black", @"")];
    }
    else if([@"black" isEqualToString:_sourceType]){
        [sheet addButtonWithTitle:NSLocalizedString(@"action.remove", @"")];
    }
    [sheet addButtonWithTitle:NSLocalizedString(@"cancel", @"")];
    sheet.cancelButtonIndex = sheet.numberOfButtons-1;
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
    [sheet showInView:self.view];
    //注意事项，在开发过程中，发现有时候UIActionSheet的最后一项点击失效，点最后一项的上半区域时有效，这是在特定情况下才会发生，这个场景就是试用了UITabBar的时候才有。解决办法：
    //[actionSheet showInView:[UIApplication sharedApplication].keyWindow];或者[sheet showInView:[AppDelegate sharedDelegate].tabBarController.view];
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [formItems.settings count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFCSetting *setting = [formItems.settings objectAtIndex:indexPath.row];
    if([setting isKindOfClass:[OFCImageSetting class]]){
        return 95.0f;
    }else{
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    //OFCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    OFCSettingTableViewCell *cell =(OFCSettingTableViewCell *) [settingsTableView cellForRowAtIndexPath:indexPath];
	if (cell == nil)
	{
		cell = [[OFCSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        OFCSetting *setting = [formItems.settings objectAtIndex:indexPath.row];
        setting.delegate = self;
        cell.ofcSetting = setting;
        if(cell.accessoryView){
            [self setUIAccessoryView:cell.accessoryView];
        }
        if([setting isKindOfClass:[OFCImageSetting class]]){
            self.imageCell = cell;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickImage)];
            [cell addGestureRecognizer:singleTap];
        }
	}
    return cell;
}

-(void)whenClickImage
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:[NSString stringWithFormat:API_DOWN_IMAGE_URL,[curProfile objectForKey:@"img" ]]];
    [photos addObject:photo];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = photos;
    [browser show];
}
- (UITableView *) targetViewer
{
    return settingsTableView;
}
#pragma mark -
#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
 
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([@"profiles" isEqualToString:_sourceType]){
        [self doProfileActionSheet:buttonIndex];
    }
    else if([@"friends" isEqualToString:_sourceType]){
        [self doFriendsActionSheet:buttonIndex];
    }
    else if([@"fav" isEqualToString:_sourceType]){
        [self doFavActionSheet:buttonIndex];
    }
    else if([@"sub" isEqualToString:_sourceType]){
        [self doSubActionSheet:buttonIndex];
    }
    else if([@"fans" isEqualToString:_sourceType]){
        [self doFansActionSheet:buttonIndex];
    }
    else if([@"black" isEqualToString:_sourceType]){
        [self doBlackActionSheet:buttonIndex];
    } 
}
#pragma mark - Friends Actions

- (void)doFriendsActionSheet:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //fav
            [self messageAction];
            break;
        case 1:
            //sub
            [self removeFriendsAction];
            break;
        case 2:
            //black
            [self blackAction];
            break;
    }
}
#pragma mark - Fav Actions

- (void)doFavActionSheet:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //fav
            [self messageAction];
            break;
        case 1:
            //sub
            [self removeFavAction];
            break;
        case 2:
            //black
            [self blackAction];
            break;
    }
}


#pragma mark - Fans Actions
- (void)doSubActionSheet:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //fav
            [self removeSubAction];
            break;
        case 1:
            //sub
            [self blackAction];
            break;
    }
}
#pragma mark - Fans Actions

- (void)doFansActionSheet:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //fav
            [self removeFansAction];
            break;
        case 1:
            //sub
            [self blackAction];
            break;
    }
}
#pragma mark - Black Actions

- (void)doBlackActionSheet:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //fav
            [self removeBlackAction];
            break;
    }
}

#pragma mark - Profile Actions

- (void)doProfileActionSheet:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //fav
            [self favAction];
            break;
        case 1:
            //sub
            [self subAction];
            break;
        case 2:
            //black
            [self friendsAction];
            break;
        case 3:
            //del
            [self blackAction];
            break;
    }
}

#pragma mark - Actions
- (void)messageAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    BaseMessageViewController *control = [[BaseMessageViewController alloc] initWithId:userId isGroup:NO];
    [self.navigationController pushViewController:control animated:YES];
}
- (void)favAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationFavorite alloc] post:userId completed:^(NSObject *result, BOOL hasError) {
         
    }];
}
- (void)friendsAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationFriends alloc] post:userId completed:^(NSObject *result, BOOL hasError) {
        
    }];
}
- (void)subAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationAttention alloc] post:userId completed:^(NSObject *result, BOOL hasError) {
        
    }]; 
}
- (void)blackAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationBlacklist alloc] post:userId completed:^(NSObject *result, BOOL hasError) {
        
    }]; 
}

- (void)removeFavAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationFavorite alloc] remove:userId completed:^(NSObject *result, BOOL hasError) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)removeFriendsAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationFriends alloc] remove:userId completed:^(NSObject *result, BOOL hasError) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)removeFansAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationFans alloc] remove:userId completed:^(NSObject *result, BOOL hasError) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)removeSubAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationAttention alloc] remove:userId completed:^(NSObject *result, BOOL hasError) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)removeBlackAction{
    NSString *userId = [curProfile objectForKey:@"userid"];
    [[MRelationBlacklist alloc] remove:userId completed:^(NSObject *result, BOOL hasError) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end
