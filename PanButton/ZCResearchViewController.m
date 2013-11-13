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
#import <QuartzCore/QuartzCore.h>
#define KBREAK_LABELS 40
#define KRECT_TITLE  80,60,100,25
#define KRECT_LOCATIONVIEW 200, 220, 60, 100
#define KTAG_LABELS 1000
#define KTAG_SEGMENT 2000
#define KTAG_ADDBOOK 100
//@class ZCLabels;
@interface ZCResearchViewController ()<POPDDelegate,HZAreaPickerDelegate>
{
    CGFloat yypaixu;
    CGFloat yyrole;
    CGFloat yysex;
    CGFloat yylocation;
    CGFloat yyquanzi;
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
@end

@implementation ZCResearchViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//----------textfield------//
    _textfieldbook=[[ZCTextField alloc]init];
    _textfieldbook.placeholder=@"请输入姓名";
    [self.view addSubview:_textfieldbook];
    
//----------labels------//
    _labelbook=[[ZCLabels alloc]init];
    _labelbook.frame=CGRectMake(KRECT_TITLE);
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
           
        }
        
        _labelbook.tag=KTAG_LABELS+i;
        [self.view addSubview:_labelbook];
    }
//----------addlabels------//
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
    [self.view addSubview:_segsexbook];
    
    
//----------addresults------//
    _loclabel=[[ZCLabels alloc]init];
    _arealabel=[[ZCLabels alloc]init];
    _arealabel.frame=CGRectMake(140,yyquanzi , _arealabel.frame.size.width+20, _arealabel.frame.size.height);
    NSString *path=[[NSBundle mainBundle] pathForResource:@"chinaarea" ofType:@"plist"];
    
    arrayAllCities=[[NSMutableArray alloc] initWithContentsOfFile:path];
    _locationview=[[POPDViewController alloc]initWithMenuSections:arrayAllCities];
    _locationview.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)formain{

    
}
-(void)taptheadd:(UIGestureRecognizer *)gesture{
    NSLog(@"%d",gesture.view.tag);
    if (gesture.view.tag==KTAG_ADDBOOK+1) {
        _locationview=[[POPDViewController alloc]initWithMenuSections:arrayAllCities];
        _locationview.delegate=self;
        _locationview.view.frame=CGRectMake(KRECT_LOCATIONVIEW);
        [self addChildViewController:_locationview];
        [self.view addSubview:_locationview.view];
    }else if (gesture.view.tag==KTAG_ADDBOOK+2) {
    
//        if ([textField isEqual:self.areaText]) {
            [self cancelLocatePicker];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self] ;
            [self.locatePicker showInView:self.view];
//        } else {
//            [self cancelLocatePicker];
//            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self] ;
//            [self.locatePicker showInView:self.view];
//        }

        
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_locationview.view removeFromSuperview];
    [self cancelLocatePicker];
    [_textfieldbook resignFirstResponder];
}//关掉picker
-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath: %d,%d",indexPath.section,indexPath.row);
    NSString *celllabeltxt;
    celllabeltxt=[[_locationview.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSLog(@"celllabeltxt=%@",celllabeltxt);
    [_loclabel removeFromSuperview];
    _loclabel=[[ZCLabels alloc]init];
    _loclabel.text=celllabeltxt;
    _loclabel.frame=CGRectMake(140,yylocation , _loclabel.frame.size.width+20, _loclabel.frame.size.height);
    _loclabel.backgroundColor=[UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:0.4];
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
