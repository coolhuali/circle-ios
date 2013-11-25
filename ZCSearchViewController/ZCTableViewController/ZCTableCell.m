//
//  ZCTableCell.m
//  ZCTableview
//
//  Created by Iijy ZC on 13-11-25.
//  Copyright (c) 2013年 Iijy ZC. All rights reserved.
//

#import "ZCTableCell.h"

@implementation ZCTableCellLabelTitle

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.font=KZC_LBFONT1;
    self.textColor=[UIColor blackColor];
    return self;
}

@end
@implementation ZCTableCellLabelSign

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.font=KZC_LBFONT2;
    self.textColor=[UIColor grayColor];
    return self;
}

@end
@implementation ZCTableCellLabelCount
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.font=KZC_LBFONT3;
    self.textColor=[UIColor grayColor];
    return self;
}

@end

@implementation ZCTableCell
@synthesize lbSign,lbTitle,lbCount,myimage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        myimage=[[UIImageView alloc] initWithFrame:kZC_IMRECT];
        [self addSubview:myimage];
        lbTitle=[[ZCTableCellLabelTitle alloc]initWithFrame:kZC_LBRECT1];
        lbTitle.tag=100;
        [self addSubview:lbTitle];
        lbCount=[[ZCTableCellLabelCount alloc]initWithFrame:kZC_LBRECT2];
        lbCount.tag=101;
        [self addSubview:lbCount];


        lbSign=[[ZCTableCellLabelSign alloc]initWithFrame:kZC_LBRECT3];
        lbSign.tag=102;
        [self addSubview:lbSign];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
@implementation ZCTableCellOne
@synthesize lbSign,lbTitle,lbCount,myimage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        lbTitle=[[ZCTableCellLabelTitle alloc]initWithFrame:CGRectMake(40, 10, 240, 20)];
        lbTitle.tag=100;
        [self addSubview:lbTitle];
        lbCount=[[ZCTableCellLabelCount alloc]initWithFrame:CGRectMake(40, 40, 240, 20)];
        lbCount.tag=101;
        [self addSubview:lbCount];
        lbSign=[[ZCTableCellLabelSign alloc]initWithFrame:CGRectMake(40, 60, 240, 20)];
        lbSign.tag=102;
        [self addSubview:lbSign];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
