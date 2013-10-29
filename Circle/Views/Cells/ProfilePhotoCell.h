//
//  ProfilePhotoCell.h
//  Circle
//
//  Created by admin on 13-10-23.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "MBaseModel.h"

//头像大小
#define HEAD_SIZE 70.0f
//间距
#define INSETS 8.0f
//文本高度
#define TEXT_SIZE 22.0f

@protocol ProfilePhotoDelegate
-(void)viewFullProile:(NSDictionary *)dict;

@end
@interface ProfilePhotoCell : UITableViewCell{
    UIImageView *_user1;
    UIImageView *_user2;
    UIImageView *_user3;
    UIImageView *_user4;
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UILabel *_label4;
    NSArray *_source;
}
@property(assign,nonatomic)id<ProfilePhotoDelegate> delegate;
-(void)setUnionObject:(NSArray*)aUnionObj;

@end
