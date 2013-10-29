//
//  OFCSettingsViewController.m
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCSettingsViewController.h"
#import "OFCSettingTableViewCell.h"
#import "AppDelegate.h"

@implementation OFCSettingsViewController
@synthesize settingsManager;
- (id)init
{
    self = [super init];
    if(self){
        self.title = NSLocalizedString(@"setting.title", nil);
        self.settingsManager = [[OFCSettingsManager alloc]init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}
- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [self.settingsTableView setDataSource:self];
    [self.settingsTableView setDelegate:self]; 
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if (tag > 2 &&tag < 5 ) {
        rect.origin.y = -44.0f * (tag - 2);
    }
    else if (tag > 4) {
        rect.origin.y = -44.0f * (tag - 2 + 2);
    } else {
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.settingsManager.settingsGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingsManager numberOfSettingsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    OFCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[OFCSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        OFCSetting *setting = [settingsManager settingAtIndexPath:indexPath];
        setting.delegate = self;
        cell.ofcSetting = setting;
        if(cell.accessoryView){
            [self setUIAccessoryView:cell.accessoryView];
        }
	}
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [settingsManager stringForGroupInSection:section];
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
