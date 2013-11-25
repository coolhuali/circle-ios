//
//  ZCDefine.h
//  Circle
//
//  Created by Iijy ZC on 13-11-13.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KZC_LBFONT1  [UIFont fontWithName:@"ArialRoundedMTBold" size:16]
#define KZC_LBFONT2  [UIFont fontWithName:@"ArialRoundedMTBold" size:12]
#define KZC_LBFONT3  [UIFont fontWithName:@"ArialRoundedMTBold" size:12]
#define kZC_IMRECT   CGRectMake(  5,  5,  80, 80)
#define kZC_LBRECT1  CGRectMake(100,  5, 200, 20)
#define kZC_LBRECT2  CGRectMake(100, 40, 100, 20)
#define kZC_LBRECT3  CGRectMake(100, 60, 200, 20)
#define kZC_TBRECT   CGRectMake(  0,  0, self.view.frame.size.width, self.view.frame.size.height)


#define  kDuration 0.3
#define  KFONT    [UIFont fontWithName:@"Georgia-Bold" size:12]
//字体
#define  KFONTSUB    [UIFont fontWithName:@"Georgia-Bold" size:10]
//location的sub tabelcell字体

#define  KCOLOR_FONT [UIColor blackColor]
//字体颜色
#define  KCOLOR_LABELBACKGROUND [UIColor clearColor]
//labels的背景色
#define  KCOLOR_TABLE [UIColor clearColor]
//location和圈子的背景色
#define  KCOLOR_TEXTFIELDBACKGROUND [UIColor grayColor]
//姓名输入框的背景色
#define  KCOLOR_LABELCYLCBACKGROUND [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:0.4]
//常用标签location 的背景颜色
#define  KCOLOR_LABELCYQZBACKGROUND [UIColor colorWithRed:180.0/255.0 green:200.0/255.0 blue:210.0/255.0 alpha:0.4]
//常用标签圈子的背景颜色
#define  KCOLOR_SEGMENTBACKGROUND [UIColor clearColor]
//segment的背景色
#define CELLSELECTED [UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:0.4]
//被选中的locationtabel的cell背景色

#define KCOLOR_BLUR    [UIColor colorWithRed:0.940625 green:0.993750 blue:0.684375 alpha:0.242188]
#define SEPARATOR [UIColor clearColor]
#define SEPSHADOW [UIColor clearColor]
#define SHADOW [UIColor clearColor]
#define TEXT [UIColor whiteColor]

#define  KITEMWIDTH 24
//segment的item宽度
#define KBREAK_LABELS 40
//每个label标签相隔的y增量，每个常用标签相隔的x增量
#define  KRECT_LABELNEWX 140
//location 和圈子返回结果label的x
#define  KRECT_LABELNEWWIDTH 105
//location 和圈子返回结果label的width
#define  KRECT_LABELNEWHEIGHT 25
//location 和圈子返回结果label的height
#define  KRECT_LABELFRAME      CGRectMake(40,100,50,25)
//标签labels的框架
#define  KRECT_LABELADDFRAME   CGRectMake(100,100,25,25)
//location和quanzi的“＋”标签框架
#define  KRECT_TEXTFIELDFRAME  CGRectMake(100,100,120,25)
//姓名输入框的框架
#define  KRECT_SEGMENTFRAME CGRectMake(100.0, 20.0, 120.0, 25.0)
//segments的框架
#define  KRECT_TITLE  CGRectMake(120,60,100,25)
//页面title的框架
#define  KRECT_LOCATIONVIEW CGRectMake(120, 100, 100, 160)
//locationtabel的框架
#define  KRECT_PICKER CGRectMake(120, 100, 100, 162)
//picker的框架
#define  KALPHA    0.9//透明度

#define KTAG_LABELS 1000//labels的tag基数
#define KTAG_SEGMENT 2000//segment的tag基数
#define KTAG_ADDBOOK 100//location和圈子的“＋”的tag

@interface ZCDefine : NSObject
@end
