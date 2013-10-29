//
//  GroupSettingViewController.h
//  OpenFireClient
//
//  Created by admin on 13-7-16.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OFCSettingsManager.h"
#import "BaseFormViewController.h"
@interface GroupSettingViewController : BaseFormViewController<UITableViewDataSource,                                                       OFCSettingDelegate,
UITableViewDelegate,UITextFieldDelegate>
{
    OFCSettingsManager *settingsManager;
}
@property (nonatomic, strong) OFCSettingsManager *settingsManager; 

@end
