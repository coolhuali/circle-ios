//
//  OFCSettingTableViewCell.h
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFCSetting.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "MBaseModel.h"
@interface OFCSettingTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    OFCSetting *ofcSetting;
}

@property (nonatomic, retain) OFCSetting *ofcSetting;

@end
