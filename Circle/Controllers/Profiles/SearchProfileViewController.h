//
//  SearchProfileViewController.h
//  Circle
//
//  Created by admin on 13-9-29.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "BaseFormViewController.h"

@interface SearchProfileViewController : BaseFormViewController <UITableViewDataSource,
UITableViewDelegate,UINavigationControllerDelegate>
{
    OFCSettingsGroup *formItems;
}
@property (nonatomic, strong) OFCSettingsGroup *formItems;
@property (copy) ActionCompletedBlock completedBlock;
@end
