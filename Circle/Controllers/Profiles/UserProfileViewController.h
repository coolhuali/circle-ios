//
//  UserProfileViewController.h
//  OpenFireClient
//
//  Created by admin on 13-9-25.
//  Copyright (c) 2013年 com.cti. All rights reserved.
// 
 
#import "BaseFormViewController.h" 
 
@interface UserProfileViewController : BaseFormViewController <UITableViewDataSource,
UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    OFCSettingsGroup *formItems;
    NSString *_profileId;
    NSString *_sourceType;
}
@property (nonatomic, strong) OFCSettingsGroup *formItems;
@property (nonatomic, retain) OFCSettingTableViewCell *imageCell;
- (id) initWithProfileId:(NSString *)profileId sourceType:(NSString *)sourceType;
@end

