//
//  BaseFormViewController.h
//  OpenFireClient
//
//  Created by admin on 13-6-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFCSettingsManager.h"
#import "MAppStrings.h"
#import "MBaseModel.h"
#import "OFCImageSetting.h"
#import "OFCLabelSetting.h"
#import "OFCValueSetting.h"
#import "OFCStringSetting.h"
#import "OFCSettingsGroup.h"
#import "UIHelper.h"
#import "OFCSettingTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface BaseFormViewController : UIViewController<OFCSettingDelegate>
{ 
    UITextField * currentTextField;
    UIToolbar * keyboardToolbar;
    NSUInteger itemCount;
    UITableView *settingsTableView;
}
@property (nonatomic,strong)  UITextField *currentTextField;
@property (nonatomic,strong)  UIToolbar *keyboardToolbar;
@property (nonatomic,strong) UITableView *settingsTableView;
-(void)setUIAccessoryView:(UIView *)target;
-(void)showMenuItem;
@end
