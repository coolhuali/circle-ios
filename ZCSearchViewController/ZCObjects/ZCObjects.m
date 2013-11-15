//
//  ZCObjects.m
//  Circle
//
//  Created by Iijy ZC on 13-11-8.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "ZCObjects.h"
#import "ZCDefine.h"





@implementation ZCLabels
-(id)init{

    self=[super init];
    if(self) {
        /*--------------------------------------------------------------------------
         This type of button is created by default.
         --------------------------------------------------------------------------*/
        [self setFrame:KRECT_LABELFRAME];
        [self setFont:KFONT];
        [self setAlpha:KALPHA];
        [self setBackgroundColor:KCOLOR_LABELBACKGROUND];
        [self setTextColor:KCOLOR_FONT];
        [self setTextAlignment:NSTextAlignmentLeft];
        
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
        [self setFrame:KRECT_TEXTFIELDFRAME];
        [self setBorderStyle:UITextBorderStyleRoundedRect];
        [self setFont:KFONT];
        [self setAlpha:KALPHA];
        [self setBackgroundColor:KCOLOR_TEXTFIELDBACKGROUND];
        [self setTextColor:KCOLOR_FONT];
        
        
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
        self.frame = KRECT_SEGMENTFRAME;
        
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
        [self setFrame:KRECT_LABELADDFRAME];
        [self setFont:KFONT];
        [self setAlpha:KALPHA];
//        [self setBackgroundColor:KCOLOR_LABELBACKGROUND];
        [self setTextColor:KCOLOR_FONT];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"ADD.png"]]];

    }
    return self;
}


@end
@implementation ZCLabelsCYLC
-(id)init{
    
    self=[super init];
    if(self) {
        /*--------------------------------------------------------------------------
         This type of button is created by default.
         --------------------------------------------------------------------------*/
        [self setFrame:KRECT_LABELADDFRAME];
        [self setFont:KFONT];
        [self setAlpha:KALPHA];
        //        [self setBackgroundColor:KCOLOR_LABELBACKGROUND];
        [self setTextColor:KCOLOR_FONT];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor: KCOLOR_LABELCYLCBACKGROUND];
        
    }
    return self;
}
@end
@implementation ZCLabelsCYQZ
-(id)init{
    
    self=[super init];
    if(self) {
        /*--------------------------------------------------------------------------
         This type of button is created by default.
         --------------------------------------------------------------------------*/
        [self setFrame:KRECT_LABELADDFRAME];
        [self setFont:KFONT];
        [self setAlpha:KALPHA];
        //        [self setBackgroundColor:KCOLOR_LABELBACKGROUND];
        [self setTextColor:KCOLOR_FONT];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor: KCOLOR_LABELCYQZBACKGROUND];
        
    }
    return self;
}


@end

@implementation ZCObjects

@end
