//
//  MyProfileViewController.h
//  OpenFireClient
//
//  Created by admin on 13-9-28.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "BaseFormViewController.h"

@interface MyProfileViewController :BaseFormViewController <UITableViewDataSource,
UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    OFCSettingsGroup *formItems;
    NSString *card;
}
@property (nonatomic, strong) OFCSettingsGroup *formItems;
@property (nonatomic, strong) NSString *card; 
@property (nonatomic, retain) OFCSettingTableViewCell *imageCell;

- (id)initForRegister;
@end
