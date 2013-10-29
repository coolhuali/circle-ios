//
//  OFCRegisterNextController.m
//  OpenFireClient
//
//  Created by admin on 13-9-24.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//
#import "RegisterNextViewController.h"
#import "MyProfileViewController.h"
#import "MProfileInfo.h"

@interface RegisterNextViewController(){
    MProfileInfo *mProfile;
}
@end

@implementation RegisterNextViewController
@synthesize formItems;
@synthesize card;
- (id)init
{
    self = [super init];
    if(self){ 
        self.title = NSLocalizedString(@"register.title", nil);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mProfile = [MProfileInfo alloc];
    
    OFCLabelSetting *identityLabel = [[OFCLabelSetting alloc] initWithText:@"register.label.icd" value:self.card];
    OFCStringSetting *nameSetting = [[OFCStringSetting alloc]initWithText:@"register.label.name" placeholder:@"register.label.name.placeholder"];
    OFCStringSetting *genderSetting = [[OFCStringSetting alloc]initWithText:@"register.label.sex"  placeholder:@"register.label.sex.placeholder"];
    OFCStringSetting *disciplineSetting = [[OFCStringSetting alloc]initWithText:@"register.label.major" placeholder:@"register.label.major.placeholder"];
    OFCStringSetting *complanySetting = [[OFCStringSetting alloc]initWithText:@"register.label.org" placeholder:@"register.label.org.placeholder"];
    
    formItems = [[OFCSettingsGroup alloc] initWithTitle:@"register.title" settings:[NSArray arrayWithObjects:identityLabel,nameSetting,genderSetting,disciplineSetting,complanySetting, nil]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(nextStep:)];
    
    [self.settingsTableView setDataSource:self];
    [self.settingsTableView setDelegate:self]; 
    
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

- (void)nextStep:(id)sender{
    [mProfile check:[formItems buildParams] completed:^(NSObject *result, BOOL hasError) {
        if(hasError)return;
        if([@"false" isEqual:result]){
            [UIHelper alert:@"error.title" content:@"error.register.exists" usingLocalized:YES];
            return;
        }
        MyProfileViewController *control = [[MyProfileViewController alloc] initForRegister];
        control.card = self.card;
        [self.navigationController pushViewController:control animated:YES];
    }];
}

@end
