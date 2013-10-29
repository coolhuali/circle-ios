//
//  SearchProfileViewController.m
//  Circle
//
//  Created by admin on 13-9-29.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "SearchProfileViewController.h"
#import "OFCBuddyListViewController.h"
#import "MProfileInfo.h"
#import "MRelationFavorite.h"
#import "MRelationAttention.h"
#import "MRelationBlacklist.h"
#import "MRelationFans.h"
#import "MRelationFriends.h"

@interface SearchProfileViewController(){
    UINavigationBar *navigationBar;
}
@end

@implementation SearchProfileViewController
@synthesize formItems;
- (id)init
{
    self = [super init];
    if(self){
        self.title = NSLocalizedString(@"profile.search.title", nil);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    navigationBar.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UINavigationItem *item =[[UINavigationItem alloc]initWithTitle:NSLocalizedString(@"profile.search.title", nil)];
    item.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"cancel", nil)
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(cancelDismissView)];
    item.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"done", nil)
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(doneDismissView)];
    [navigationBar pushNavigationItem:item animated:NO];
    [self.settingsTableView setFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-40)];
    [self.settingsTableView setDataSource:self];
    [self.settingsTableView setDelegate:self];
    [self setProfileInfo];
    [self.view addSubview:navigationBar];
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)cancelDismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)doneDismissView{
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.completedBlock)self.completedBlock([formItems buildParamsString],NO);
    }];
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
- (void)setProfileInfo{
    
    OFCStringSetting *nameSetting = [[OFCStringSetting alloc]initWithText:@"register.label.name" placeholder:@"register.label.name.placeholder" description:nil settingsKey:@"profile.search.label.name"];
    OFCStringSetting *genderSetting = [[OFCStringSetting alloc]initWithText:@"register.label.sex"  placeholder:@"register.label.sex.placeholder" description:nil settingsKey:@"profile.search.label.sex"];
    OFCStringSetting *disciplineSetting = [[OFCStringSetting alloc]initWithText:@"register.label.major" placeholder:@"register.label.major.placeholder" description:nil settingsKey:@"profile.search.label.major"];
    OFCStringSetting *complanySetting = [[OFCStringSetting alloc]initWithText:@"register.label.org" placeholder:@"register.label.org.placeholder" description:nil settingsKey:@"profile.search.label.org"];
     
    OFCStringSetting *modelSetting = [[OFCStringSetting alloc]initWithText:@"register.label.model" placeholder:@"register.label.model.placeholder" description:nil settingsKey:@"profile.search.label.model"];
    
    OFCStringSetting *citySetting = [[OFCStringSetting alloc]initWithText:@"register.label.city" placeholder:@"register.label.city.placeholder" description:nil settingsKey:@"profile.search.label.city"];
    
    OFCStringSetting *signSetting = [[OFCStringSetting alloc]initWithText:@"register.label.sign" placeholder:@"register.label.sign.placeholder" description:nil settingsKey:@"profile.search.label.sign"];
    
    OFCStringSetting *purposeSetting = [[OFCStringSetting alloc]initWithText:@"register.label.purpose" placeholder:@"register.label.purpose.placeholder" description:nil settingsKey:@"profile.search.label.purpose"];
    
    
    OFCStringSetting *emailSetting = [[OFCStringSetting alloc]initWithText:@"register.label.email" placeholder:@"register.label.email.placeholder" description:nil settingsKey:@"profile.search.label.email"];
    
    
    OFCStringSetting *mobileSetting = [[OFCStringSetting alloc]initWithText:@"register.label.mobile" placeholder:@"register.label.mobile.placeholder" description:nil settingsKey:@"profile.search.label.mobile"];
    
    formItems = [[OFCSettingsGroup alloc] initWithTitle:@"register.title" settings:[NSArray arrayWithObjects:nameSetting,genderSetting,disciplineSetting,complanySetting,modelSetting,signSetting,mobileSetting,emailSetting,citySetting,purposeSetting,nil]]; 
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
		cell = [[OFCSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        OFCSetting *setting = [formItems.settings objectAtIndex:indexPath.row];
        setting.delegate = self;
        cell.ofcSetting = setting;
        if(cell.accessoryView){
            [self setUIAccessoryView:cell.accessoryView];
        }
	}
    return cell;
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
@end
