//
//  LoginViewController.m
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "MyLoginViewController.h" 
#import "ProfileListViewController.h"
#import "OFCBuddyListViewController.h"
#import "MLoginInfo.h" 
 
@interface MyLoginViewController(){
    MLoginInfo *mLogin;
    OFCStringSetting *nameSetting;
    OFCStringSetting *pwdSetting;
}
@end

@implementation MyLoginViewController
@synthesize formItems; 
- (id)init
{
    self = [super init];
    if(self){
        self.title = NSLocalizedString(@"login.title", nil);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mLogin = [MLoginInfo alloc];
    
    nameSetting = [[OFCStringSetting alloc]initWithText:@"login.label.current.icd" placeholder:@"login.label.current.icd.placeholder"];
    pwdSetting = [[OFCStringSetting alloc]initWithText:@"login.label.current.pwd"  placeholder:@"login.label.current.pwd.placeholder"];
    
    formItems = [[OFCSettingsGroup alloc] initWithTitle:@"login.title" settings:[NSArray arrayWithObjects:nameSetting,pwdSetting, nil]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"menu", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"action.login", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(nextStep:)];
    
    [self.settingsTableView setDataSource:self];
    [self.settingsTableView setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(authSuccess:)
     name:kOFCServerAuthedSuccess
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(authFail:)
     name:kOFCServerAuthedFail
     object:nil];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
- (void)authFail:(NSNotification*)notification
{
    [UIHelper alert:@"error.title" content:@"error.connect.auth.tip" usingLocalized:YES];
}
- (void)authSuccess:(NSNotification*)notification
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    NSString *jid = [MLoginInfo md5HexDigest:nameSetting.value];
    [[OFCXMPPManager sharedManager] disconnect];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:^(){
        [[OFCXMPPManager sharedManager] connect:jid pwd:pwdSetting.value];
    } afterDelay:2.0f];
}
- (void)fireBlockAfterDelay:(void (^)(void))block {
  	    block();
 }
@end
