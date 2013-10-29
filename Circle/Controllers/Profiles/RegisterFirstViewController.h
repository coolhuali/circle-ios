//
//  RegisterFirstViewController.h
//  Circle
//
//  Created by admin on 13-10-11.
//  Copyright (c) 2013年 icss. All rights reserved.
//
 
#import "BaseFormViewController.h"

@interface RegisterFirstViewController : BaseFormViewController<UITableViewDataSource,
UITableViewDelegate>
{
    OFCSettingsGroup *formItems;
}
@property (nonatomic, strong) OFCSettingsGroup *formItems; 

@end
