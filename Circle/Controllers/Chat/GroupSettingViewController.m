//
//  GroupSettingViewController.m
//  OpenFireClient
//
//  Created by admin on 13-7-16.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "GroupSettingViewController.h"
#import "OFCSettingTableViewCell.h"
#import "UIView+AnimationOptionsForCurve.h"
@interface GroupSettingViewController ()

@end

@implementation GroupSettingViewController
@synthesize settingsManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"group.setting.title", nil);
        self.settingsManager = [[OFCSettingsManager alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [self.settingsTableView setBackgroundColor:[UIColor lightGrayColor]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *) targetViewer
{
    return settingsTableView;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = [self.settingsManager.settingsGroups count];
    return count;
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

#pragma mark -
#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
} 
@end
