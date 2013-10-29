//
//  FormTableViewCell.h
//  Circle
//
//  Created by admin on 13-10-11.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "MBaseModel.h"
#import "OFCSetting.h"
#import "OFCBoolSetting.h"
#import "OFCStringSetting.h"
#import "OFCLabelSetting.h"
#import "OFCImageSetting.h"

@interface FormTableViewCell : UITableViewCell{
    
    UIImageView *_bageView;
    UILabel *_bageNumber;
    UILabel *_title;
    UIView *_formview;
    UIImageView *_cellBkg;
}
-(void)setFormItem:(OFCSetting *)setting;

@end
