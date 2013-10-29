//
//  BaseListViewController.h
//  Circle
//
//  Created by admin on 13-9-29.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "STableViewController.h"
#import "DEMONavigationController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "UIHelper.h"
#import "MAppStrings.h"
#import "MBaseModel.h"

@interface BaseListViewController : STableViewController{
    NSMutableArray *items;
    int page;
}
@property (strong, nonatomic) NSMutableArray *items;

@end
