//
//  ZCResearchViewController.m
//  Circle
//
//  Created by Iijy ZC on 13-11-8.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "ZCResearchViewController.h"
#import "ZCObjects.h"
#import "POPDViewController.h"
#import "HZAreaPickerView.h"
#import "ZCDefine.h"
#import "AMBlurView.h"
#import <QuartzCore/QuartzCore.h>

//@class ZCLabels;
@interface ZCResearchViewController ()<POPDDelegate,HZAreaPickerDelegate>
{
    CGFloat yypaixu;
    CGFloat yyrole;
    CGFloat yysex;
    CGFloat yylocation;
    CGFloat yyquanzi;
        CGFloat yycybq;
        NSMutableArray *arrayCYLC;
            NSMutableArray *arrayCYQZ;
    NSMutableArray *arrayAllCities;
    NSMutableArray *arraylabeltxt;
    NSMutableArray *arraysegmentpaicutxt;
    NSMutableArray *arraysegmentroletxt;
    NSMutableArray *arraysegmentsextxt;
}
@property (strong, nonatomic) UIWindow *window;
@property ZCTextField *textfieldbook;
@property ZCLabels *labelbook;
@property ZCLabelsADD *labeladdbook;
@property ZCSegmentControl *segpaixubook;
@property ZCSegmentControl *segrolebook;
@property ZCSegmentControl *segsexbook;
@property ZCLabels *loclabel;
@property ZCLabels *arealabel;
@property POPDViewController  *locationview;
@property NSString *areaValue, *cityValue;
@property HZAreaPickerView *locatePicker;
@property ZCLabelsCYLC *labelcy1;
@property ZCLabelsCYQZ *labelcy2;
@property (nonatomic,strong) AMBlurView *blurView;
@property (nonatomic,strong) AMBlurView *newblurP;
@property (nonatomic,strong) AMBlurView *newblurT;
@end

@implementation ZCResearchViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height)];
    [self updateTintColor];
    [self.view addSubview:[self blurView]];
    
    [self selflabelsshow];
    [self selftextfieldshow];
    [self selfsegmentsshow];
    [self selflabeladdsshow];
    [self selfresultshow];
    [self selfcybqshow];
}
- (void)updateTintColor {
    [self.blurView setBlurTintColor:[UIColor colorWithRed:0.796875 green:0.793750 blue:0.843750 alpha:0.129688]];
}

- (void)resetTintColor {
    [self.blurView setBlurTintColor:nil];
}
-(void)selflabelsshow{//----------labels------//
    _labelbook=[[ZCLabels alloc]init];
    _labelbook.frame=KRECT_TITLE;
    _labelbook.text=@"我要找";
    _labelbook.tag=1999;
    [self.view addSubview:_labelbook];
    arraylabeltxt=[NSMutableArray arrayWithObjects:@"姓名",@"排序", @"角色",@"性别",@"位置",@"圈子",@"常用标签",nil];
    
    for (int i=0; i<7; i++) {
        _labelbook=[[ZCLabels alloc]init];
        _labelbook.frame=CGRectMake(_labelbook.frame.origin.x, _labelbook.frame.origin.y+KBREAK_LABELS*i, _labelbook.frame.size.width, _labelbook.frame.size.height);
        _labelbook.text=[arraylabeltxt objectAtIndex:i];
        if ([_labelbook.text isEqualToString:@"排序"]) {
            yypaixu=_labelbook.frame.origin.y;
        }
        if ([_labelbook.text isEqualToString:@"角色"]) {
            yyrole=_labelbook.frame.origin.y;
        }
        if ([_labelbook.text isEqualToString:@"性别"]) {
            yysex=_labelbook.frame.origin.y;
        }
        if ([_labelbook.text isEqualToString:@"位置"]) {
            yylocation=_labelbook.frame.origin.y;
        }
        if ([_labelbook.text isEqualToString:@"圈子"]) {
            yyquanzi=_labelbook.frame.origin.y;
        }
        if ([_labelbook.text isEqualToString:@"常用标签"]) {
            _labelbook.font=[UIFont fontWithName:@"Georgia-Bold" size:8];
            yycybq=_labelbook.frame.origin.y+KBREAK_LABELS;
        }
        
        _labelbook.tag=KTAG_LABELS+i;
        [self.view addSubview:_labelbook];
    }}
-(void)selflabeladdsshow{//----------addlabels------//
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taptheadd:)];
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taptheadd:)];
    _labeladdbook=[[ZCLabelsADD alloc]init];
    _labeladdbook.frame=CGRectMake(_labeladdbook.frame.origin.x,yylocation , _labeladdbook.frame.size.width, _labeladdbook.frame.size.height);
    [_labeladdbook setUserInteractionEnabled:YES];
    _labeladdbook.tag=KTAG_ADDBOOK+1;
    [_labeladdbook addGestureRecognizer:tap];
    [self.view addSubview:_labeladdbook];
    
    
    _labeladdbook=[[ZCLabelsADD alloc]init];
    _labeladdbook.frame=CGRectMake(_labeladdbook.frame.origin.x,yyquanzi , _labeladdbook.frame.size.width, _labeladdbook.frame.size.height);
    [_labeladdbook setUserInteractionEnabled:YES];
    _labeladdbook.tag=KTAG_ADDBOOK+2;
    [self.view addSubview:_labeladdbook];
    [_labeladdbook addGestureRecognizer:tap1];
    
}
-(void)selfsegmentsshow{
    //----------segmentcontrols------//
    arraysegmentpaicutxt=[NSMutableArray arrayWithObjects:@"远近",@"年龄",@"积分",nil];
    arraysegmentroletxt=[NSMutableArray arrayWithObjects:@"全部",@"飞行",@"乘务",nil];
    arraysegmentsextxt=[NSMutableArray arrayWithObjects:@"全部",@"男",@"女",nil];
    _segpaixubook = [[ZCSegmentControl alloc] initWithItems:arraysegmentpaicutxt];
    _segpaixubook.frame=CGRectMake(_segpaixubook.frame.origin.x, yypaixu, _segpaixubook.frame.size.width, _segpaixubook.frame.size.height);
    [_segpaixubook setTag:KTAG_SEGMENT];
    [self.view addSubview:_segpaixubook];
    
    
    _segrolebook = [[ZCSegmentControl alloc] initWithItems:arraysegmentroletxt];
    _segrolebook.frame=CGRectMake(_segrolebook.frame.origin.x, yyrole, _segrolebook.frame.size.width, _segrolebook.frame.size.height);
    [_segrolebook setTag:KTAG_SEGMENT+1];
    [self.view addSubview:_segrolebook];
    
    _segsexbook = [[ZCSegmentControl alloc] initWithItems:arraysegmentsextxt];
    [_segsexbook setTag:KTAG_SEGMENT+2];
    _segsexbook.frame=CGRectMake(_segsexbook.frame.origin.x, yysex, _segsexbook.frame.size.width, _segsexbook.frame.size.height);
    [self.view addSubview:_segsexbook];}
-(void)selftextfieldshow{//----------textfield------//
    _textfieldbook=[[ZCTextField alloc]init];
    _textfieldbook.placeholder=@"请输入姓名";
    [self.view addSubview:_textfieldbook];
}
-(void)selfresultshow{
    //----------addresults------//
    _loclabel=[[ZCLabels alloc]init];
    
    _arealabel=[[ZCLabels alloc]init];
    _arealabel.frame=CGRectMake(KRECT_LABELNEWX,yyquanzi,KRECT_LABELNEWWIDTH,KRECT_LABELNEWHEIGHT);//rect：圈子result自定义
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"chinaarea" ofType:@"plist"];
    
    arrayAllCities=[[NSMutableArray alloc] initWithContentsOfFile:path];
    _locationview=[[POPDViewController alloc]initWithMenuSections:arrayAllCities];
    _locationview.delegate=self;}
-(void)selfcybqshow{
    
    arrayCYLC=[NSMutableArray arrayWithObjects:@"北京",@"天津", @"上海",nil];
    
    for (int i=0; i<3; i++) {
        _labelcy1=[[ZCLabelsCYLC alloc]init];
        _labelcy1.frame=CGRectMake(_labelcy1.frame.origin.x+KBREAK_LABELS*i,yycybq , _labelcy1.frame.size.width, _labelcy1.frame.size.height);
        _labelcy1.text=[arrayCYLC objectAtIndex:i];
        _labelcy1.tag=500+i;
        [self.view addSubview:_labelcy1];
    }
    arrayCYQZ=[NSMutableArray arrayWithObjects:@"飞机",@"航天", @"型号",nil];
    
    for (int i=0; i<3; i++) {
        _labelcy2=[[ZCLabelsCYQZ alloc]init];
        _labelcy2.frame=CGRectMake(_labelcy2.frame.origin.x+KBREAK_LABELS*i, yycybq+KBREAK_LABELS, _labelcy2.frame.size.width, _labelcy2.frame.size.height);
        _labelcy2.text=[arrayCYQZ objectAtIndex:i];
        _labelcy2.tag=600+i;
        [self.view addSubview:_labelcy2];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)taptheadd:(UIGestureRecognizer *)gesture{
//    NSLog(@"%d",gesture.view.tag);
    if (gesture.view.tag==KTAG_ADDBOOK+1) {
        _newblurT=[AMBlurView new];
        _newblurT.frame=CGRectMake(KRECT_LOCATIONVIEW.origin.x,yylocation+KRECT_LABELADDFRAME.size.height,KRECT_LOCATIONVIEW.size.width,KRECT_LOCATIONVIEW.size.height);
        [_newblurT setBlurTintColor:[UIColor colorWithRed:0.976562 green:0.553125 blue:0.964063 alpha:0.457812]];
        [self.view addSubview: _newblurT];
        _locationview=[[POPDViewController alloc]initWithMenuSections:arrayAllCities];
        _locationview.delegate=self;
        _locationview.view.frame=CGRectMake(KRECT_LOCATIONVIEW.origin.x,yylocation+KRECT_LABELADDFRAME.size.height,KRECT_LOCATIONVIEW.size.width,KRECT_LOCATIONVIEW.size.height);
        
        [self addChildViewController:_locationview];
        [self.view addSubview:_locationview.view];
    }else if (gesture.view.tag==KTAG_ADDBOOK+2) {
    
//        if ([textField isEqual:self.areaText]) {
            [self cancelLocatePicker];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self] ;
            [self showInView:self.view];
        
//        } else {
//            [self cancelLocatePicker];
//            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self] ;
//            [self.locatePicker showInView:self.view];
//        }

        
    }
    
}
- (void)showInView:(UIView *) view
{

    self.locatePicker.frame = CGRectMake(KRECT_PICKER.origin.x, view.frame.size.height, self.locatePicker.frame.size.width, KRECT_PICKER.size.height);
    _newblurP=[AMBlurView new];
    _newblurP.frame=CGRectMake(KRECT_PICKER.origin.x, view.frame.size.height, self.locatePicker.frame.size.width, KRECT_PICKER.size.height);
    [_newblurP setBlurTintColor:[UIColor colorWithRed:0.976562 green:0.553125 blue:0.964063 alpha:0.457812]];
    [self.view addSubview: _newblurP];
    [view addSubview:self.locatePicker];
    [UIView animateWithDuration:0.3 animations:^{

        self.locatePicker.frame = CGRectMake(KRECT_PICKER.origin.x, yyquanzi+KRECT_LABELADDFRAME.size.height, self.locatePicker.frame.size.width, KRECT_PICKER.size.height);
        _newblurP.frame=CGRectMake(KRECT_PICKER.origin.x, yyquanzi+KRECT_LABELADDFRAME.size.height, self.locatePicker.frame.size.width, KRECT_PICKER.size.height);
    }];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_locationview.view removeFromSuperview];
    [_newblurT removeFromSuperview];
    [self cancelLocatePicker];
    [_newblurP removeFromSuperview];
    [_textfieldbook resignFirstResponder];
//    ZCLabelsCYLC *label1;
//    ZCLabelsCYQZ *label2;
//    for (int i=0; i<3; i++) {
//        label1=(ZCLabelsCYLC *)[self.view viewWithTag:500+i];
//        label2=(ZCLabelsCYQZ *)[self.view viewWithTag:600+i];
//        label1.hidden=NO;
//        label2.hidden=NO;
//    }

}//关掉picker,tabel等
-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"didSelectRowAtIndexPath: %d,%d",indexPath.section,indexPath.row);
    NSString *celllabeltxt;
    celllabeltxt=[[_locationview.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    NSLog(@"celllabeltxt=%@",celllabeltxt);
    [_loclabel removeFromSuperview];
    _loclabel=[[ZCLabels alloc]init];
    _loclabel.frame=CGRectMake(KRECT_LABELNEWX,yylocation,KRECT_LABELNEWWIDTH,KRECT_LABELNEWHEIGHT);
    _loclabel.text=celllabeltxt;
//    _loclabel.backgroundColor=[UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:0.4];
    [self.view addSubview:_loclabel];
    [_locationview.view removeFromSuperview];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    [self.view addSubview:_arealabel];
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        _arealabel.text = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    } else{
        _arealabel.text = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

@end
