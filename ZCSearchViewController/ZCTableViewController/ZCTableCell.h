//
//  ZCTableCell.h
//  ZCTableview
//
//  Created by Iijy ZC on 13-11-25.
//  Copyright (c) 2013年 Iijy ZC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCDefine.h"

@interface ZCTableCellLabelTitle : UILabel

@end
@interface ZCTableCellLabelSign : UILabel

@end
@interface ZCTableCellLabelCount : UILabel
@end
@interface ZCTableCell : UITableViewCell
@property ZCTableCellLabelCount *lbCount;
@property ZCTableCellLabelTitle *lbTitle;
@property ZCTableCellLabelSign *lbSign;
@property UIImageView *myimage;
@end
@interface ZCTableCellOne: UITableViewCell
@property ZCTableCellLabelCount *lbCount;
@property ZCTableCellLabelTitle *lbTitle;
@property ZCTableCellLabelSign *lbSign;
@property UIImageView *myimage;
@end
