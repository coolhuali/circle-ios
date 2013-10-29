//
//  MyProfileViewController.m
//  OpenFireClient
//
//  Created by admin on 13-9-28.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//
 
#import "MyProfileViewController.h"
#import "OFCBuddyListViewController.h"
#import "MLoginInfo.h"
#import "MProfileInfo.h"
#import "MRelationFavorite.h"

@interface MyProfileViewController(){
    MProfileInfo *mProfile;
    BOOL isRegister;
    OFCValueSetting *pwdSetting;
    OFCImageSetting *imgSetting;
}
@end

@implementation MyProfileViewController
@synthesize formItems;
@synthesize card;
- (id)init
{
    self = [super init];
    if(self){
        self.card = [MLoginInfo getActiveLoginName];
        isRegister = NO;
        self.title = NSLocalizedString(@"profile.title", nil);
    }
    return self;
}
- (id)initForRegister
{
    self = [super init];
    if(self){
        isRegister = YES;
        self.title = NSLocalizedString(@"profile.title", nil);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mProfile = [MProfileInfo alloc];
    [self.settingsTableView setDataSource:self];
    [self.settingsTableView setDelegate:self]; 
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"menu", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
	// Do any additional setup after loading the view.
    [self myProfile];
    if(!isRegister){
        [mProfile get:[MLoginInfo getActiveUserId] completed:^(NSObject *result, BOOL hasError) {
            if(hasError)return;
            NSDictionary * data  = (NSDictionary *)result;
            if(data !=nil){
                self.title = [data objectForKey:@"name"];
                [MLoginInfo setMyProfileInfo:data];
                [settingsTableView reloadData];
            }
        }];
    }
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(connectFail:)
     name:kOFCServerConnectFail
     object:nil];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myProfile{
     
    OFCLabelSetting *identityLabel = [[OFCLabelSetting alloc] initWithText:@"register.label.icd" value:self.card useKey:NO];
    OFCStringSetting *nameSetting = [[OFCStringSetting alloc]initWithText:@"register.label.name" placeholder:@"register.label.name.placeholder"];
    OFCStringSetting *genderSetting = [[OFCStringSetting alloc]initWithText:@"register.label.sex"  placeholder:@"register.label.sex.placeholder"];
    OFCStringSetting *disciplineSetting = [[OFCStringSetting alloc]initWithText:@"register.label.major" placeholder:@"register.label.major.placeholder"];
    OFCStringSetting *complanySetting = [[OFCStringSetting alloc]initWithText:@"register.label.org" placeholder:@"register.label.org.placeholder"];
    
    pwdSetting = [[OFCStringSetting alloc]initWithText:@"login.label.current.pwd" placeholder:@"login.label.current.pwd.placeholder"];
    
    OFCStringSetting *modelSetting = [[OFCStringSetting alloc]initWithText:@"register.label.model" placeholder:@"register.label.model.placeholder"];
    
    OFCStringSetting *citySetting = [[OFCStringSetting alloc]initWithText:@"register.label.city" placeholder:@"register.label.city.placeholder"];
    
    OFCStringSetting *signSetting = [[OFCStringSetting alloc]initWithText:@"register.label.sign" placeholder:@"register.label.sign.placeholder"];
    
    OFCStringSetting *purposeSetting = [[OFCStringSetting alloc]initWithText:@"register.label.purpose" placeholder:@"register.label.purpose.placeholder"];
    
    
    OFCStringSetting *emailSetting = [[OFCStringSetting alloc]initWithText:@"register.label.email" placeholder:@"register.label.email.placeholder"];
    
    
    OFCStringSetting *mobileSetting = [[OFCStringSetting alloc]initWithText:@"register.label.mobile" placeholder:@"register.label.mobile.placeholder"];
    
    imgSetting = [[OFCImageSetting alloc] initWithText:@"register.label.img" value:nil];
    
    formItems = [[OFCSettingsGroup alloc] initWithTitle:@"register.title" settings:[NSArray arrayWithObjects:imgSetting,identityLabel,nameSetting,genderSetting,disciplineSetting,complanySetting,pwdSetting,modelSetting,signSetting,mobileSetting,emailSetting,citySetting,purposeSetting,nil]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(nextStep:)];
} 
- (void)nextStep:(id)sender{
    if(isRegister){
        [mProfile post:[mProfile md5HexDigest:self.card] params:[formItems buildParams] completed:^(NSObject *result, BOOL hasError) {
            if(hasError)return;
            [self uploadAvatar];
        }];
    }else{
        [mProfile put:[formItems buildParams] completed:^(NSObject *result, BOOL hasError) {
            if(hasError)return;
            [self uploadAvatar];
        }];
    }
}
-(void)uploadAvatar{
    UIImageView *imageView = (UIImageView*)self.imageCell.accessoryView;
    NSData* imageData = UIImageJPEGRepresentation(imageView.image,1.0);
    NSString *userid = [MLoginInfo md5HexDigest:card];
    [mProfile postAvatar:userid image:imageData completed:^(NSObject *result, BOOL hasError) {
        //upload success
        if(hasError)return;
        imgSetting.value = result;
        if([[[OFCXMPPManager sharedManager] xmppStream] isConnected])
            [[OFCXMPPManager sharedManager] disconnect];
        else
            [self connectFail:nil];
    }];
}

- (void)connectFail:(NSNotification*)notification
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
    OFCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    OFCSetting *setting = [formItems.settings objectAtIndex:indexPath.row];
    BOOL isFirst = NO;
	if (cell == nil)
	{
		cell = [[OFCSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        setting.delegate = self;
        if([setting isKindOfClass:[OFCImageSetting class]]){
            self.imageCell = cell;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickImage)];
            [cell addGestureRecognizer:singleTap];
        }
        isFirst = YES;
	}
    cell.ofcSetting = setting;
    if(isFirst && cell.accessoryView){
        [self setUIAccessoryView:cell.accessoryView];
    }
    return cell;
}

- (UITableView *) targetViewer
{
    return settingsTableView;
}
-(void)whenClickImage
{ 
    UIActionSheet *choosePhotoActionSheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_camera", @""), NSLocalizedString(@"take_photo_from_library", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_library", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
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
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
	[self presentModalViewController:imagePickerController animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageView *imageView = (UIImageView*)self.imageCell.accessoryView;
    imageView.image = image;
    
    NSString *userid = [MLoginInfo md5HexDigest:self.card];
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    [mProfile postAvatar:userid image:imageData completed:^(NSObject *result, BOOL hasError) {
        //upload success
        if(hasError)return;
        imgSetting.value = result;
    }];
    //OFCImageSetting *imageSetting = (OFCImageSetting*)self.imageCell.ofcSetting;
    //NSData* imageData = UIImageJPEGRepresentation(image,1.0);
    //imageSetting.value = imageData;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}
@end

