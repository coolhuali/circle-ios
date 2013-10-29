//
//  WCMessageCell.m
//  微信
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "CustomMessageCell.h"
#import "ASIHTTPRequest.h"
#import "GGFullscreenImageViewController.h"
#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width


@implementation CustomMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _bubbleBg =[[UIImageView alloc]initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc]initWithFrame:CGRectZero];
        //_headMask =[[UIImageView alloc]initWithFrame:CGRectZero];
        _chatImage =[[UIImageView alloc]initWithFrame:CGRectZero];
        [_userHead.layer setCornerRadius:IMAGE_RADIUS];
        [_userHead.layer setMasksToBounds:YES];
        [_userHead setUserInteractionEnabled:YES];
        [_chatImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *userHeadSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadHandleSingleTap:)];
        [_userHead addGestureRecognizer:userHeadSingleTap];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sourceHandleSingleTap:)];
        [_chatImage addGestureRecognizer:singleTap];
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setNumberOfLines:9999];
        _progress = [[ProgressIndicator alloc] initWithFrame:CGRectZero];
        [_progress setHidden:YES];
        _isLoading = NO;
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        //[self.contentView addSubview:_headMask];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_chatImage];
        [self.contentView addSubview:_progress];
        [_chatImage setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //[_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    }
    return self;
}


-(void)layoutSubviews
{
    
    [super layoutSubviews];

    NSString *orgin = _messageConent.text;
    CGSize textSize = [orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];

    switch (_msgStyle) {
        case BubbleMessageStyleTime:
        {
            [_userHead setHidden:YES];
            //[_headMask setHidden:YES];
            [_bubbleBg setHidden:YES];
            [_progress setHidden:YES];
            [_messageConent setHidden:NO];
             _messageConent.backgroundColor = [UIColor grayColor];
            _messageConent.layer.cornerRadius = 3;
            [_messageConent setFrame:CGRectMake((CELL_WIDTH-textSize.width)/2,0, textSize.width, textSize.height)];
           
        }
        case BubbleMessageStyleOutgoing:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
             [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-12, _messageConent.frame.origin.y-10, textSize.width+30, textSize.height+30);
        }
            break;
        case BubbleMessageStyleOutgoingImage:
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-100)/2, 100, 100)];
            [_progress setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115,10, 100, 10)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-12, _chatImage.frame.origin.y-10, 100+30, 100+30);
        }
            break;
        case BubbleMessageStyleOutgoingSound:
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-40)/2, 25, 25)];
            [_progress setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-40)/2, 100, 10)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            [_chatImage setImage:[UIImage imageNamed:@"tabbar_badge"]];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"VOIPSenderVoiceNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-12, _chatImage.frame.origin.y-8,100+30, 20+30);
        }
            break;
        case BubbleMessageStyleIncoming:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-17, _messageConent.frame.origin.y-10, textSize.width+30, textSize.height+30);
        }
            break;
            case BubbleMessageStyleIncomingImage:
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-100)/2,100,100)];
            [_progress setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15,10, 100, 10)];
             [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];

            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-17, _chatImage.frame.origin.y-10, 100+30, 100+30);

        }
            break;
        case BubbleMessageStyleIncomingSound:
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-40)/2,25,25)];
            [_progress setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15,10,100,10)];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_chatImage setImage:[UIImage imageNamed:@"tabbar_badge"]];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"VOIPReceiverVoiceNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-17, _chatImage.frame.origin.y-8,100+30,20+30);
            
        }
            break;
        default:
            break;
    }
    
    
    //_headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)sourceHandleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(!_progress.isHidden)return;
    if(_sourcePath!=nil && (_msgStyle == BubbleMessageStyleOutgoingSound||_msgStyle == BubbleMessageStyleIncomingSound)){
        [self playSound];
    }else if(_msgStyle == BubbleMessageStyleOutgoingImage||_msgStyle == BubbleMessageStyleIncomingImage){
        if(self.delegate!=nil)[self.delegate viewMessageFullImage:_messageConent.text image:_chatImage.image];
    }
}

- (void)userHeadHandleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(_userid==nil)return;
    if(self.delegate!=nil)
        [self.delegate viewMessageUserProfile:_userid];
}

-(void)setMessage:(NSString*)jid content:(NSObject*)content
{
    if(jid!=nil){
        _userid = jid;
        [_userHead setImageWithURL:[MBaseModel getAvatarUrlCache:jid]];
    }
    if([content isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = (NSDictionary*)content;
        if([[dict objectForKey:@"type"] isEqualToString:@"image"]){
            [self uploadMessageImage:(NSData *)[dict objectForKey:@"content"] completed:^(NSObject *result, BOOL hasError) {
                [_messageConent setText:(NSString*)result];
                [dict setValue:(NSString*)result forKey:@"img"];
            }];
        }
        else{
            [self uploadMessageSound:(NSString*)[dict objectForKey:@"content"] completed:^(NSObject *result, BOOL hasError) {
                [_messageConent setText:(NSString*)result];
                [dict setValue:(NSString*)result forKey:@"img"];
            }];
        }
    }
    else if(_msgStyle==BubbleMessageStyleOutgoingImage||_msgStyle == BubbleMessageStyleIncomingImage){
        [_messageConent setText:(NSString*)content];
        [self downloadImage:(NSString*)content];
    }
    else if(_msgStyle==BubbleMessageStyleOutgoingSound||_msgStyle == BubbleMessageStyleIncomingSound){
        [_messageConent setText:(NSString*)content];
        [self downloadSound:(NSString*)content];
    }else{
        [_messageConent setText:(NSString*)content];
    }
   
}
-(void)setHeadImage:(UIImage*)headImage
{
    [_userHead setImage:headImage];
}
-(void)setChatImage:(UIImage *)chatImage
{
    [_chatImage setImage:chatImage];
}

- (void)uploadMessageImage:(NSData *)data completed:(ActionCompletedBlock)completedBlock
{
    if(_isLoading || data==nil)return;
    _isLoading = YES;
    [_chatImage setImage:[self imageWithImageSimple:[UIImage imageWithData:data]]];
    [_progress setProgress:0.0 animated:NO];
    [_progress setHidden:NO];
    
    if(self.delegate!=nil)[self.delegate upLoadMessageImageProgress:data progress:_progress completed:^(NSObject *result, BOOL hasError) {
        if(hasError)return;
        [_messageConent setText:(NSString*)result];
        //_isLoading = NO;
        [_progress setHidden:YES];
        if(completedBlock)completedBlock(result,hasError);
    }];
}

- (void)uploadMessageSound:(NSString *)content completed:(ActionCompletedBlock)completedBlock
{
    if(_isLoading || content==nil)return;
    _isLoading = YES;
    _sourcePath = content;
    [_progress setProgress:0.0 animated:NO];
    [_progress setHidden:NO];
    
    if(self.delegate!=nil)[self.delegate upLoadMessageSoundProgress:content progress:_progress completed:^(NSObject *result, BOOL hasError) {
        if(hasError)return;
        [_messageConent setText:(NSString*)result];
        //_isLoading = NO;
        [_progress setHidden:YES];
        if(completedBlock)completedBlock(result,hasError);
    }];
}
- (void)downloadImage:(NSString *)urlStr
{
    if(_isLoading || urlStr==nil)return;
    _isLoading = YES;
    [_progress setProgress:0.0 animated:NO];
    [_progress setHidden:NO];
    [_chatImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_DOWN_IMAGE_URL,[NSString stringWithFormat:@"small/%@",urlStr]]] placeholderImage:nil options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        [_progress setTotalSize:expectedSize];
        [_progress setProgress:(receivedSize * 1.0 / expectedSize) animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        //_isLoading = NO;
        [_progress setHidden:YES];
    }];
}

-(UIImage*)imageWithImageSimple:(UIImage*)image
{
    return [UIHelper imageWithImageSimple:image width:100 height:100];
}

-(void)downloadSound:(NSString *)targetUrl
{
    if(_isLoading || targetUrl==nil)return;
    _sourcePath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),[targetUrl lastPathComponent]];
    if([[NSFileManager defaultManager] fileExistsAtPath:_sourcePath]){
        return;
    }
    _isLoading = YES;
    [_progress setProgress:0.0 animated:NO];
    [_progress setHidden:NO];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_DOWN_IMAGE_URL,targetUrl]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.showAccurateProgress=YES;
    [request setDownloadProgressDelegate:_progress];
    [request setCompletionBlock :^{
        //_isLoading = NO;
        [_progress setHidden:YES];
        // 当以文本形式读取返回内容时用这个方法
        NSData *responseData = [request responseData];
        if(responseData.length>0){
            [responseData writeToFile:_sourcePath atomically:YES];
        }
    }];
    [request setFailedBlock :^{
        //_isLoading = NO;
        NSLog(@"response error");
    }];
    [request startAsynchronous ];
}
- (void)playSound
{
    if([[NSFileManager defaultManager] fileExistsAtPath:_sourcePath]) {
        NSURL *url = [NSURL fileURLWithPath:_sourcePath];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else {
        NSLog(@"**** Sound Error: file not found: %@", _sourcePath);
    }
}
@end
