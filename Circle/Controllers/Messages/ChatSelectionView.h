//
//  WCChatSelectionView.h
//  微信
//
//  Created by Reese on 13-8-22.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CHAT_BUTTON_SIZE 70
#define INSETS 10

@protocol ShareMoreDelegate <NSObject>

@optional
-(void)pickPhoto;
-(void)cameraPhoto;
-(UIImage *)imageDidFinishPicking;
-(UIImage *)cameraDidFinishPicking;
//-(CLLocation *)locationDidFinishPicking;

@end


@interface ChatSelectionView : UIView


@property (nonatomic,assign) id<ShareMoreDelegate> delegate;
@property (nonatomic,retain) UIButton *photoButton;
@property (nonatomic,retain) UIButton *cameraButton;
@property (nonatomic,retain) UIButton *locationButton;
@property (nonatomic,retain) UIButton *vcardButton;
@property (nonatomic,retain) UIButton *voipChatButton;
@property (nonatomic,retain) UIButton *videoChatButton;
@property (nonatomic,retain) UIButton *voidInputButton;
@property (nonatomic,retain) UIButton *moreButton;




@end



