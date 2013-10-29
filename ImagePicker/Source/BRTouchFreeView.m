//
//  BRTouchFreeView.m
//  ImagePicker
//
//  Created by Alexander on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRTouchFreeView.h"

@implementation BRTouchFreeView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    return hitView;
}

@end
