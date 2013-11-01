//
//  OFCSettingTableViewCell.m
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import "OFCSettingTableViewCell.h"
#import "OFCBoolSetting.h"
#import "OFCStringSetting.h"
#import "OFCLabelSetting.h"
#import "OFCImageSetting.h"

@implementation OFCSettingTableViewCell
@synthesize ofcSetting;

- (void)setOfcSetting:(OFCSetting *)setting
{
    self.textLabel.text = setting.title;
    self.detailTextLabel.text = setting.description;
    if(setting.imageName)
    {
        self.imageView.image = [UIImage imageNamed:setting.imageName];
    }
    else
    {
        self.imageView.image = nil;
    }
    UIView *accessoryView = nil;
    if ([setting isKindOfClass:[OFCBoolSetting class]]) {
        OFCBoolSetting *boolSetting = (OFCBoolSetting *)setting;
        UISwitch *boolSwitch = nil;
        BOOL animated;
        if (ofcSetting == setting) {
            boolSwitch = (UISwitch*)self.accessoryView;
            animated = YES;
        } else {
            boolSwitch = [[UISwitch alloc] init];
            [boolSwitch addTarget:boolSetting action:boolSetting.action forControlEvents:UIControlEventValueChanged];
            animated = NO;
        }
        [boolSwitch setOn:[boolSetting enabled] animated:animated];
        accessoryView = boolSwitch;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if([setting isKindOfClass:[OFCStringSetting class]]){
        OFCStringSetting *stringSetting = (OFCStringSetting *)setting;
        UITextField *valueTextField = nil;
        if(ofcSetting == setting){
            valueTextField = (UITextField *)self.accessoryView;
        }else {
            valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10,180, 36)];
            valueTextField.backgroundColor = [UIColor clearColor];
            valueTextField.placeholder = stringSetting.placeholder;
            valueTextField.returnKeyType = UIReturnKeyDone;
            valueTextField.delegate = stringSetting;
        }
        valueTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        valueTextField.text = stringSetting.value;
        accessoryView = valueTextField;
    }else if([setting isKindOfClass:[OFCLabelSetting class]]){
        OFCLabelSetting *stringSetting = (OFCLabelSetting *)setting;
        UILabel *labelTextField = nil;
        if(ofcSetting == setting){
            labelTextField = (UILabel *)self.accessoryView;
        }else {
            labelTextField = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,180, 36)];
            labelTextField.backgroundColor = [UIColor clearColor];
        }
        labelTextField.text = stringSetting.value;
        accessoryView = labelTextField;
    }else if([setting isKindOfClass:[OFCImageSetting class]]){
        OFCImageSetting *stringSetting = (OFCImageSetting *)setting;
        UIImageView *ui = nil; 
        if(ofcSetting == setting){
            ui = (UIImageView *)self.accessoryView;
        }else {
            ui = [[UIImageView alloc] initWithFrame:CGRectMake(90, 0,90, 90)];
            ui.userInteractionEnabled = YES;
            //[ui.layer setCornerRadius:IMAGE_RADIUS];
        }
        if(stringSetting.value){
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_DOWN_IMAGE_URL,(NSString*)stringSetting.value]];
            [ui setImageWithURL:url];
        }
        accessoryView = ui;
    }
    self.accessoryView = accessoryView;
    ofcSetting = setting;
}
@end
