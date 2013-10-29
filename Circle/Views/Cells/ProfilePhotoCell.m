//
//  ProfilePhotoCell.m
//  Circle
//
//  Created by admin on 13-10-23.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "ProfilePhotoCell.h"

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width


@implementation ProfilePhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _user1 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _user2 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _user3 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _user4 =[[UIImageView alloc]initWithFrame:CGRectZero];
        [_user1 setUserInteractionEnabled:YES];
        [_user2 setUserInteractionEnabled:YES];
        [_user3 setUserInteractionEnabled:YES];
        [_user4 setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *_user1SingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(user1HandleSingleTap:)];
        [_user1 addGestureRecognizer:_user1SingleTap];
        
        
        UITapGestureRecognizer *_user2SingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(user2HandleSingleTap:)];
        [_user2 addGestureRecognizer:_user2SingleTap];
        
        
        UITapGestureRecognizer *_user3SingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(user3HandleSingleTap:)];
        [_user3 addGestureRecognizer:_user3SingleTap];
        
        
        UITapGestureRecognizer *_user4SingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(user4HandleSingleTap:)];
        [_user4 addGestureRecognizer:_user4SingleTap];
        
        [_user1.layer setCornerRadius:IMAGE_RADIUS];
        [_user2.layer setCornerRadius:IMAGE_RADIUS];
        [_user3.layer setCornerRadius:IMAGE_RADIUS];
        [_user4.layer setCornerRadius:IMAGE_RADIUS];
        
        [_user1.layer setMasksToBounds:YES];
        [_user2.layer setMasksToBounds:YES];
        [_user3.layer setMasksToBounds:YES];
        [_user4.layer setMasksToBounds:YES];
        
        _label1=[[UILabel alloc]initWithFrame:CGRectZero];
        _label2=[[UILabel alloc]initWithFrame:CGRectZero];
        _label3=[[UILabel alloc]initWithFrame:CGRectZero];
        _label4=[[UILabel alloc]initWithFrame:CGRectZero];
        
        [_label1 setFont:[UIFont systemFontOfSize:15]];
        [_label1 setTextColor:[UIColor grayColor]];
        [_label1 setBackgroundColor:[UIColor clearColor]];
        [_label1 setTextAlignment:UITextAlignmentCenter];
        
        [_label2 setFont:[UIFont systemFontOfSize:15]];
        [_label2 setTextColor:[UIColor grayColor]];
        [_label2 setBackgroundColor:[UIColor clearColor]];
        [_label2 setTextAlignment:UITextAlignmentCenter];
        
        [_label3 setFont:[UIFont systemFontOfSize:15]];
        [_label3 setTextColor:[UIColor grayColor]];
        [_label3 setBackgroundColor:[UIColor clearColor]];
        [_label3 setTextAlignment:UITextAlignmentCenter];
        
        [_label4 setFont:[UIFont systemFontOfSize:15]];
        [_label4 setTextColor:[UIColor grayColor]];
        [_label4 setBackgroundColor:[UIColor clearColor]];
        [_label4 setTextAlignment:UITextAlignmentCenter];
        
        [self.contentView addSubview:_user1];
        [self.contentView addSubview:_user2];
        [self.contentView addSubview:_user3];
        [self.contentView addSubview:_user4];
        [self.contentView addSubview:_label1];
        [self.contentView addSubview:_label2];
        [self.contentView addSubview:_label3];
        [self.contentView addSubview:_label4];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    float ch =  INSETS;//(CELL_HEIGHT-HEAD_SIZE)/2;
    [_user1 setFrame:CGRectMake(INSETS,ch,HEAD_SIZE , HEAD_SIZE)];
    [_user2 setFrame:CGRectMake(2*INSETS+HEAD_SIZE,ch,HEAD_SIZE , HEAD_SIZE)];
    [_user3 setFrame:CGRectMake(3*INSETS+2*HEAD_SIZE,ch,HEAD_SIZE , HEAD_SIZE)];
    [_user4 setFrame:CGRectMake(4*INSETS+3*HEAD_SIZE,ch,HEAD_SIZE , HEAD_SIZE)];
    
    [_label1 setFrame:CGRectMake(INSETS,ch+HEAD_SIZE/2+INSETS+2,HEAD_SIZE , HEAD_SIZE)];
    [_label2 setFrame:CGRectMake(2*INSETS+HEAD_SIZE,ch+HEAD_SIZE/2+INSETS+2,HEAD_SIZE , HEAD_SIZE)];
    [_label3 setFrame:CGRectMake(3*INSETS+2*HEAD_SIZE,ch+HEAD_SIZE/2+INSETS+2,HEAD_SIZE , HEAD_SIZE)];
    [_label4 setFrame:CGRectMake(4*INSETS+3*HEAD_SIZE,ch+HEAD_SIZE/2+INSETS+2,HEAD_SIZE , HEAD_SIZE)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setUnionObject:(NSArray*)aUnionObj
{
    _source = aUnionObj;
    int count = aUnionObj.count;
    
    if(count>0){
        [_label1 setText:[aUnionObj[0] objectForKey:@"name"]];
        [_user1 setImageWithURL:[MBaseModel getAvatarUrlCache:[aUnionObj[0] objectForKey:@"userid"]]];
    }
    if(count>1){
        [_label2 setText:[aUnionObj[1] objectForKey:@"name"]];
        [_user2 setImageWithURL:[MBaseModel getAvatarUrlCache:[aUnionObj[1] objectForKey:@"userid"]]];
    }
    if(count>2){
        [_label3 setText:[aUnionObj[2] objectForKey:@"name"]];
        [_user3 setImageWithURL:[MBaseModel getAvatarUrlCache:[aUnionObj[2] objectForKey:@"userid"]]];
    }
    if(count>3){
        [_label4 setText:[aUnionObj[3] objectForKey:@"name"]];
        [_user4 setImageWithURL:[MBaseModel getAvatarUrlCache:[aUnionObj[3] objectForKey:@"userid"]]];
    }
}


- (void)user1HandleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(_source.count>0){
        if(self.delegate!=nil)
            [self.delegate viewFullProile:_source[0]];
    }
}

- (void)user2HandleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(_source.count>1){
        if(self.delegate!=nil)
            [self.delegate viewFullProile:_source[1]];
    }
}

- (void)user3HandleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(_source.count>2){
        if(self.delegate!=nil)
            [self.delegate viewFullProile:_source[2]];
    }
}

- (void)user4HandleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(_source.count>3){
        if(self.delegate!=nil)
            [self.delegate viewFullProile:_source[3]];
    }
}
@end
