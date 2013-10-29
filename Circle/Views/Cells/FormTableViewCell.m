//
//  ProfileTableViewCell.m
//  OpenFireClient
//
//  Created by admin on 13-9-26.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "FormTableViewCell.h"
//头像大小
#define HEAD_SIZE 50.0f
//间距
#define INSETS 8.0f

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width


@implementation FormTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _title=[[UILabel alloc]initWithFrame:CGRectZero];
        _cellBkg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MessageListCellBkg"]];
        _bageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_badge"]];
        _bageNumber=[[UILabel alloc]initWithFrame:CGRectZero];
        
        [_title setFont:[UIFont boldSystemFontOfSize:15]];
        [_title setBackgroundColor:[UIColor clearColor]];
        
        [_bageNumber setBackgroundColor:[UIColor clearColor]];
        [_bageNumber setTextAlignment:NSTextAlignmentCenter];
        [_bageNumber setTextColor:[UIColor whiteColor]];
        [_bageNumber setFont:[UIFont boldSystemFontOfSize:12]];
        
        [self setBackgroundView:_cellBkg];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_bageView];
        [_bageView addSubview:_bageNumber];
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    [_title setFrame:CGRectMake(2*INSETS,5,100, (CELL_HEIGHT-3*INSETS)/2)];
    [_formview setFrame:CGRectMake(CELL_WIDTH-80, (CELL_HEIGHT-HEAD_SIZE)/2, 80, (CELL_HEIGHT-3*INSETS)/2)];
    [_bageNumber setFrame:CGRectMake(0,0,35, 35)];
    [_bageView setFrame:CGRectMake(INSETS+35, INSETS-10, 35, 35)];
    _cellBkg.frame=self.contentView.frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setFormItem:(OFCSetting *)setting
{
    [_title setText:setting.title];
    if(_formview==nil){
        if ([setting isKindOfClass:[OFCBoolSetting class]]) {
            OFCBoolSetting *boolSetting = (OFCBoolSetting *)setting;
            UISwitch *boolSwitch = [[UISwitch alloc] init];
            [boolSwitch addTarget:boolSetting action:boolSetting.action forControlEvents:UIControlEventValueChanged];
            [boolSwitch setOn:[boolSetting enabled] animated:NO];
            _formview = boolSwitch;
        }else if([setting isKindOfClass:[OFCStringSetting class]]){
            OFCStringSetting *stringSetting = (OFCStringSetting *)setting;
            UITextField *valueTextField = [[UITextField alloc] initWithFrame:CGRectZero];
            valueTextField.backgroundColor = [UIColor clearColor];
            valueTextField.placeholder = stringSetting.placeholder;
            valueTextField.returnKeyType = UIReturnKeyDone;
            valueTextField.delegate = stringSetting;
            valueTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            valueTextField.text = stringSetting.value;
            _formview = valueTextField;
        }else if([setting isKindOfClass:[OFCLabelSetting class]]){
            OFCLabelSetting *stringSetting = (OFCLabelSetting *)setting;
            UILabel *labelTextField  = [[UILabel alloc] initWithFrame:CGRectZero];
            labelTextField.backgroundColor = [UIColor clearColor];
            labelTextField.text = stringSetting.value;
            _formview = labelTextField;
        }else if([setting isKindOfClass:[OFCImageSetting class]]){
            OFCImageSetting *stringSetting = (OFCImageSetting *)setting;
            UIImageView *imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
            if(stringSetting.value && [stringSetting.value isKindOfClass:[NSData class]]){
                [imageView setImage:[UIImage imageWithData:stringSetting.value]];
            }else{
                [imageView setImage:[UIImage imageNamed:@"avatar_default"]];
            }
            _formview = imageView;
        }
    }
}

@end
