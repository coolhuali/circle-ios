//
//  ZCObjects.m
//  Circle
//
//  Created by Iijy ZC on 13-11-8.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "ZCObjects.h"

#define  KRECT_LABELFRAME      40,100,30,25
#define  KRECT_LABELADDFRAME   100,100,25,25
#define  KRECT_TEXTFIELDFRAME  100,100,120,25
#define  KRECT_SEGMENTFRAME 100.0, 20.0, 120.0, 25.0

#define  KALPHA    0.8
#define  KFONT    [UIFont fontWithName:@"Georgia-Bold" size:12]
#define  KCOLOR_LABELFONT [UIColor whiteColor]
#define  KCOLOR_TEXTFIELDBACKGROUND [UIColor grayColor]
#define  KCOLOR_LABELBACKGROUND [UIColor clearColor]
#define KCOLOR_SEGMENTBACKGROUND [UIColor clearColor]

@implementation ZCLabels
-(id)init{

    self=[super init];
    if(self) {
        /*--------------------------------------------------------------------------
         This type of button is created by default.
         --------------------------------------------------------------------------*/
        [self setFrame:CGRectMake(KRECT_LABELFRAME)];
        [self setFont:KFONT];
        [self setAlpha:KALPHA];
        [self setBackgroundColor:KCOLOR_LABELBACKGROUND];
        [self setTextColor:KCOLOR_LABELFONT];
        [self setTextAlignment:NSTextAlignmentCenter];
        
    }
    return self;
}
@end
@implementation ZCTextField
-(id)init{
    
    self=[super init];
    if(self) {
        /*--------------------------------------------------------------------------
         This type of button is created by default.
         --------------------------------------------------------------------------*/
        [self setFrame:CGRectMake(KRECT_TEXTFIELDFRAME)];
        [self setBorderStyle:UITextBorderStyleRoundedRect];
        [self setFont:KFONT];
        [self setAlpha:KALPHA];
        [self setBackgroundColor:KCOLOR_TEXTFIELDBACKGROUND];
        [self setTextColor:KCOLOR_LABELFONT];
        
        
    }
    return self;
}
@end
@implementation ZCSegmentControl
-(id)initWithItems:(NSArray *)items{
    
    self=[super initWithItems:items];
    if(self) {
        self.backgroundColor = KCOLOR_SEGMENTBACKGROUND;

        self.alpha=KALPHA;
        self.frame = CGRectMake(KRECT_SEGMENTFRAME);
        
        //设置背景图片，或者设置颜色，或者使用默认白色外观
//        self.backgroundImage = [UIImage imageNamed:@"segment_bg.png"];
   
        //阴影部分图片，不设置使用默认椭圆外观的stain
        UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stain.png"]];
        imageview.alpha=KALPHA;
        self.selectedStainView = imageview;
        
        self.selectedSegmentTextColor = [UIColor yellowColor];
        self.segmentTextColor = [UIColor whiteColor];
      
        
        
    }
    return self;
}
@end

@implementation ZCLabelsADD
-(id)init{
    
    self=[super init];
    if(self) {
        /*--------------------------------------------------------------------------
         This type of button is created by default.
         --------------------------------------------------------------------------*/
        [self setFrame:CGRectMake(KRECT_LABELADDFRAME)];
        [self setFont:KFONT];
        [self setAlpha:KALPHA];
//        [self setBackgroundColor:KCOLOR_LABELBACKGROUND];
        [self setTextColor:KCOLOR_LABELFONT];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"ADD.png"]]];

    }
    return self;
}


@end

@implementation ZCObjects

@end
