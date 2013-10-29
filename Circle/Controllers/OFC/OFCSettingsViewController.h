//
//  OFCSettingsViewController.h
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFormViewController.h"
@interface OFCSettingsViewController : BaseFormViewController <UITableViewDataSource,
UITableViewDelegate>
{ 
    OFCSettingsManager *settingsManager;
}
@property (nonatomic, strong) OFCSettingsManager *settingsManager;
@end
