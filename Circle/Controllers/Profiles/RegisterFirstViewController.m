//
//  OFCRegisterNextController.m
//  OpenFireClient
//
//  Created by admin on 13-9-24.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//
#import "RegisterFirstViewController.h"
#import "RegisterNextViewController.h"
#import "MProfileInfo.h"
#import "MLoginInfo.h"

@interface RegisterFirstViewController(){
    MProfileInfo *mProfile;
    OFCStringSetting *identitySetting;
}
@end

@implementation RegisterFirstViewController
@synthesize formItems; 
- (id)init
{
    self = [super init];
    if(self){
        self.title = NSLocalizedString(@"register.title.icd", nil);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mProfile = [MProfileInfo alloc];
    identitySetting = [[OFCStringSetting alloc]initWithText:@"register.label.icd" placeholder:@"register.label.icd.placeholder"];
    formItems = [[OFCSettingsGroup alloc] initWithTitle:@"register.title.icd" settings:[NSArray arrayWithObjects:identitySetting,nil]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(nextStep:)];
    
    [self.settingsTableView setDataSource:self];
    [self.settingsTableView setDelegate:self];
    [MLoginInfo clearProfileInfo];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    OFCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
        OFCSetting *setting = [formItems.settings objectAtIndex:indexPath.row];
		cell = [[OFCSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
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

- (void)nextStep:(id)sender{
    [mProfile exists:identitySetting.value completed:^(NSObject *result, BOOL hasError) {
        if(hasError){
            return;
        }
        if([@"true" isEqual:result]){
            [UIHelper alert:@"error.title" content:@"error.register.identity" usingLocalized:YES];
            return;
        }
        RegisterNextViewController *setting = [[RegisterNextViewController alloc] init];
        setting.card = identitySetting.value;
        [self.navigationController pushViewController:setting animated:YES];
    }];
}

@end
