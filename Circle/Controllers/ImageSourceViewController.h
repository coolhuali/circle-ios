//
//  ImageSourceViewController.h
//  Circle
//
//  Created by admin on 13-10-21.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface ImageSourceViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, SDWebImageManagerDelegate,UIActionSheetDelegate>

//图片urls
- (id)initWithbigImageUrls:(NSArray *)urlArr smallImageUrls:(NSArray *)surlArr;
//图片rul 缩略图
- (id)initWithUrls:(NSArray *)urlArr thumbsImgs:(NSArray *)imgArr;
////图片rul 缩略图url
//- (id)initWithUrls:(NSArray *)urlArr thumbsUrls:(NSArray *)thumbUrlArr;
//设置图片index
- (void)setImageIndex:(NSInteger)imageIndex;



@end