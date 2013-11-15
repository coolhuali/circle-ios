//
//  POPDCell.h
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POPDCell : UITableViewCell
@property (strong,nonatomic)UILabel *label;
@property (strong,nonatomic)UIButton *button;
@end

@interface POPDCellSub : UITableViewCell
@property (strong,nonatomic)UILabel *labelsub;

@end