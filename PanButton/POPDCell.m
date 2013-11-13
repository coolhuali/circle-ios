//
//  POPDCell.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "POPDCell.h"
#define  KFONT    [UIFont fontWithName:@"Georgia-Bold" size:12]
#define  KFONTSUB    [UIFont fontWithName:@"Georgia-Bold" size:8]
@interface POPDCell ()


@end
@implementation POPDCell

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor  clearColor];
        _label=[[UILabel alloc]init];
        _label.font=KFONT;
        _label.frame=CGRectMake(self.frame.origin.x+12, self.frame.origin.y-13, self.frame.size.width-12, self.frame.size.height-3) ;

        [self addSubview:_label];

        _button=[[UIButton alloc]init];

        _button.titleLabel.font=KFONT;
//        _button.backgroundColor=[UIColor redColor];
        _button.alpha=0.8;
        _button.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-13, 10, self.frame.size.height-3) ;
        [self addSubview:_button];
        // Initialization code
    }
    return self;
}
@end
@implementation POPDCellSub

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor  clearColor];
        _labelsub=[[UILabel alloc]init];
        _labelsub.font=KFONTSUB;
        _labelsub.frame=CGRectMake(self.frame.origin.x+15, self.frame.origin.y-13, self.frame.size.width-15, self.frame.size.height-3) ;
        [self addSubview:_labelsub];
        // Initialization code
    }
    return self;
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
