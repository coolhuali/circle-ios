//
//  LoginViewController.h
//  OpenFireClient
//
//  Created by admin on 13-9-27.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "BaseFormViewController.h"

@interface MyLoginViewController : BaseFormViewController<UITableViewDataSource,
UITableViewDelegate>
{
    OFCSettingsGroup *formItems; 
}
@property (nonatomic, strong) OFCSettingsGroup *formItems; 

@end
