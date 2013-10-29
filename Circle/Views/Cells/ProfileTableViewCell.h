//
//  ProfileTableViewCell.h
//  OpenFireClient
//
//  Created by admin on 13-9-26.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "MBaseModel.h"
@interface ProfileTableViewCell : UITableViewCell{
    
    UIImageView *_userHead;
    UIImageView *_bageView;
    UILabel *_bageNumber;
    UILabel *_userNickname;
    UILabel *_messageConent;
    UILabel *_timeLable;
    UIImageView *_cellBkg;
}

-(void)setUnionObject:(NSDictionary*)aUnionObj;
@end
