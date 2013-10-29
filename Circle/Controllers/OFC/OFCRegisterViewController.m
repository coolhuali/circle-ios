//
//  OFCRegisterViewController.m
//  OpenFireClient
//
//  Created by admin on 13-9-10.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "OFCRegisterViewController.h"
#import "ASIHttpRequest.h"
#import "MAppStrings.h"
#import "RegisterNextViewController.h"
#import "UIHelper.h"
#import "MProfileInfo.h"
#import "MLoginInfo.h"

@interface OFCRegisterViewController (){
    MProfileInfo *mProfile;
}

@end

@implementation OFCRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"register.title.icd", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mProfile = [MProfileInfo alloc];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(nextStep:)];
    self.cardLabel.text = NSLocalizedString(@"register.label.icd",nil);
    self.cardField.placeholder = NSLocalizedString(@"register.label.icd.placeholder",nil);
     
    self.cardField.text = [MLoginInfo getActiveLoginName];
    // Do any additional setup after loading the view from its nib.
}

- (void)nextStep:(id)sender{
    [mProfile exists:self.cardField.text completed:^(NSObject *result, BOOL hasError) {
        if(hasError)return; 
        if([@"true" isEqual:result]){
            [UIHelper alert:@"error.title" content:@"error.register.identity" usingLocalized:YES];
            return;
        }
        RegisterNextViewController *setting = [[RegisterNextViewController alloc] init];
        setting.card = self.cardField.text;
        [self.navigationController pushViewController:setting animated:YES];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
