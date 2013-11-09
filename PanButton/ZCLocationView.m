//
//  ZCLocationView.m
//  Circle
//
//  Created by Iijy ZC on 13-11-9.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "ZCLocationView.h"

@implementation ZCLocationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor greenColor];
        float time = 0.3;
        [UIView animateWithDuration:time
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x-160, self.frame.origin.y, self.frame.size.width , self.frame.size.height);
                             //**按钮推走主屏**//                    [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
                             
                         }
                         completion:^(BOOL finished) {
                         }
         ];
        

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
