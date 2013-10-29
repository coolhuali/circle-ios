//
//  RegisterNextViewController.h
//  OpenFireClient
//
//  Created by admin on 13-9-24.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "BaseFormViewController.h"
@interface RegisterNextViewController : BaseFormViewController<UITableViewDataSource,
UITableViewDelegate>
{
    OFCSettingsGroup *formItems;
    NSString *card;
}
@property (nonatomic, strong) OFCSettingsGroup *formItems;
@property (nonatomic, strong) NSString *card;
@end
