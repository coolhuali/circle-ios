//
//  WCRecentListCell.h
//  微信
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "MBaseModel.h"

@interface MessageRecentCell : UITableViewCell
{
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
