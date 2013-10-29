//
//  UIHelper.h
//  OpenFireClient
//
//  Created by admin on 13-9-25.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject

+ (UIImage *) roundCorners: (UIImage*) img;
+ (UIImage*)imageWithImageSimple:(UIImage*)image width:(float)kTargetWidth height:(float)kTargetHeight;
+(void)alert:(NSString *)title content:(NSString *)content;
+(void)alert:(NSString *)title content:(NSString *)content usingLocalized:(BOOL)usingLocalized;
@end
