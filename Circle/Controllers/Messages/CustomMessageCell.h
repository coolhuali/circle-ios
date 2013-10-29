//
//  WCMessageCell.h
//  微信
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIImageView+WebCache.h"
#import "BubbleView.h"
#import "ProgressIndicator.h"
#import "SVProgressHUD.h"
#import "MBaseModel.h"
#import "UIHelper.h"
//头像大小
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f


@protocol CustomMessageDelegate
-(void)viewMessageFullImage:(NSString *)content image:(UIImage *)image;
-(void)viewMessageUserProfile:(NSString *)profileId;
-(void)upLoadMessageImageProgress:(NSData *)content progress:(ProgressIndicator *)progress completed:(ActionCompletedBlock)completedBlock;
-(void)upLoadMessageSoundProgress:(NSString *)filePath progress:(ProgressIndicator *)progress completed:(ActionCompletedBlock)completedBlock;

@end
@interface CustomMessageCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    //UIImageView *_headMask;
    UIImageView *_chatImage;
    UILabel *_messageConent;
    ProgressIndicator *_progress;
    BOOL _isLoading;
    NSString *_sourcePath;
    NSString *_userid;
}
@property(assign,nonatomic)id<CustomMessageDelegate> delegate;
@property (assign, nonatomic) BubbleMessageStyle msgStyle;
@property (nonatomic) int height;
-(void)setMessage:(NSString*)jid content:(NSObject*)content;
-(void)setHeadImage:(UIImage*)headImage;
-(void)setChatImage:(UIImage *)chatImage;
@end
