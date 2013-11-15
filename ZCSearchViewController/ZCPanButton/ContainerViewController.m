//
//  ContainerViewController.m
//  Lodge
//
//  Created by Heather Snepenger on 9/17/12.
//
//
//**按钮推走主屏**//
#import "ContainerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ACPButton.h"

#define DEFAULT_SHADOW_WIDTH    -3.0       //影宽
#define DEFAULT_SHADOW_HEIGHT   0.5        //影高
#define DEFAULT_SHADOW_OPACITY  0        //影透度
#define MYBUTTON_TITLE          @"标题"     //按钮标题
#define MYBUTTON_ORINGI_X       SCREEM_WIDTH-MYBUTTONANDFVIEWDIC      //按钮初始位置x
#define MYBUTTON_ORINGI_Y       77       //按钮初始位置y
#define MYBUTTON_ORINGI_WIDTH   63         //按钮初始宽度
#define MYBUTTON_ORINGI_HIGHT   25         //按钮初始高度
#define MYBUTTON_ADJUSTX_MIN    SCREEM_WIDTH-MYBUTTON_ORINGI_WIDTH/4       //判断是否能拽出first
#define MYBUTTON_ADJUSTX_ONE    MYBUTTON_ORINGI_X-80
#define SCREEM_WIDTH            320        //屏幕宽度
#define MYBUTTONANDFVIEWDIC     MYBUTTON_ORINGI_WIDTH*3/4
#define FIRSTVIEW_START_X       MYBUTTON_ORINGI_X+MYBUTTONANDFVIEWDIC        //first初始x
#define FIRSTVIEW_FINAL_X       MYBUTTONANDFVIEWDIC
#define BUTTONANDFVIEW_APHLA    0.8f

#define VELOCITY_X_ADJUST  100
static NSInteger height;
static CGRect size;

@interface ContainerViewController (){
    NSMutableArray *privateArray;
    
    UIPanGestureRecognizer *firstGesture;
//    UIPanGestureRecognizer *secondGesture;
    
}
@property ACPButton *mybutton;
@end

@implementation ContainerViewController
@synthesize mainView;
@synthesize firstLayerView;
//@synthesize secondLayerView;

@synthesize secondViewIgnoreView;

@synthesize mainViewController = _mainViewController;
@synthesize firstLayerViewController = _firstLayerViewController;
//@synthesize secondLayerViewController = _secondLayerViewController;



//Custom init for 3 VCs
- (id)initWithBaseViewController:(UIViewController *)bViewController andFirst:(UIViewController *)fViewController //andSecond:(UIViewController *)sViewController
{
    self = [super init];
    if(self){
        [self setMainViewController:bViewController];
        [self setFirstLayerViewController:fViewController];
//        [self setSecondLayerViewController:sViewController];
    }
    return self;
}

- (void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainView = [[UIView alloc] initWithFrame:[self screenSize]];
    self.firstLayerView = [[UIView alloc] initWithFrame:[self screenSize]];

    
    [self.view addSubview:mainView];
    [self.view addSubview:firstLayerView];

    
    [self updateMainView];
    [self updateFirstLayerView];
  
//    firstGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(implementFirstLayerSlide:)];
//    [self.firstLayerView addGestureRecognizer:firstGesture];
    

    
    [self enableFirstPaneSlide:YES];
    
    [self slideToMainView];
    
    //If the firstLayerViewController is nil, hide the view from the screen
    if (!self.firstLayerViewController) {
        [firstLayerView setFrame:CGRectMake(SCREEM_WIDTH, 0, SCREEM_WIDTH, [self screenHeight])];
    }

//--------------------以下是按钮
   
    //获取路径对象
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //获取完整路径
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyButtonLST.plist"];
//    NSLog(@"%@",plistPath);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if(![fileManager fileExistsAtPath:plistPath]) //如果不存在
//    {
//        NSMutableDictionary *dictplist = [[NSMutableDictionary alloc ] init];
//        //设置属性值
//
//        NSString *mox=[NSString  stringWithFormat:@"%d",MYBUTTON_ORINGI_X];
//        NSString *moy=[NSString stringWithFormat:@"%d",MYBUTTON_ORINGI_Y];
//        NSArray *setmycenter=[[NSArray alloc]initWithObjects:mox,moy,nil];
//        [dictplist setObject:setmycenter forKey:@"mycenter"];
//        //写入文件
//        
//        [dictplist writeToFile:plistPath atomically:YES];
//    }
//    NSString *path=plistPath;
//    
//    NSDictionary *dict=[[NSDictionary alloc] initWithContentsOfFile:path];
//    NSArray *mycenter=[dict valueForKey:@"mycenter"];
//    
//    CGFloat xx=[mycenter[0] floatValue];
//    CGFloat yy=[mycenter[1] floatValue];
    CGFloat xx=MYBUTTON_ORINGI_X;
    CGFloat yy=MYBUTTON_ORINGI_Y;
    _mybutton=[[ACPButton alloc]init];
    [_mybutton setTitle:MYBUTTON_TITLE forState:UIControlStateNormal];
    [_mybutton setStyle:[UIColor orangeColor]  andBottomColor:[UIColor redColor]];
    [_mybutton setLabelTextColor:[UIColor orangeColor] highlightedColor:[UIColor redColor] disableColor:nil];
    [_mybutton setAlpha:BUTTONANDFVIEW_APHLA];
    [_mybutton setCornerRadius:20];
    [_mybutton setBorderStyle:nil andInnerColor:nil];
    [_mybutton setFrame:CGRectMake(xx, yy, MYBUTTON_ORINGI_WIDTH,MYBUTTON_ORINGI_HIGHT)];
    
    [self.view addSubview:_mybutton];
    

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(implementFirstLayerSlide:)];

    [self.mybutton addGestureRecognizer:pan];
}
#pragma pan:

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setMainView:nil];
    [self setFirstLayerView:nil];
//    [self setSecondLayerView:nil];
    
    [self setMainViewController:nil];
    [self setFirstLayerViewController:nil];
//    [self setSecondLayerViewController:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//Allow the user to remove the swipe
- (void)removeSwipe{
    [self.firstLayerView removeGestureRecognizer:firstGesture];
//    [self.secondLayerView removeGestureRecognizer:secondGesture];
}

- (void)enableFirstPaneSlide:(BOOL)enable{
    self.firstSlideEnabled = enable;
}

- (void)updateMainView
{
    _mainViewController.view.frame = mainView.frame;
    
    [mainView addSubview:_mainViewController.view];
}

- (void)setMainViewController:(UIViewController *)mainViewController
{
    _mainViewController = mainViewController;
    
    // handle view controller hierarchy
    if(_mainViewController){
        [self addChildViewController:_mainViewController];
        [_mainViewController didMoveToParentViewController:self];
        
        if ([self isViewLoaded]) {
            [self updateMainView];
        }
    }else{
        [[mainView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}

- (void)updateFirstLayerView
{
    _firstLayerViewController.view.frame = CGRectMake(0, 0, SCREEM_WIDTH, [self screenHeight]);//firstLayerView.frame;
    
    [self addDropShadow:self.firstLayerView];
    
    [firstLayerView addSubview:_firstLayerViewController.view];
    [firstLayerView bringSubviewToFront:_firstLayerViewController.view];
    
}

- (void)setFirstLayerViewController:(UIViewController *)firstLayerViewController
{
    _firstLayerViewController = firstLayerViewController;
    
    // handle view controller hierarchy
    if(_firstLayerViewController){
        [self addChildViewController:_firstLayerViewController];
        [_firstLayerViewController didMoveToParentViewController:self];
        
        if ([self isViewLoaded]) {
            [self updateFirstLayerView];
        }
    }else{
        [[firstLayerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//-------------------------------------------------------------以下是拖动按钮的手势
- (void) implementFirstLayerSlide:(UIPanGestureRecognizer *)sender
{

   
    if(([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) && self.firstSlideEnabled){
        CGPoint location = [sender locationInView:self.view];
       
        if (location.x>290) {
            if (location.y>MYBUTTON_ORINGI_Y) {
                [self.mybutton setCenter:CGPointMake(self.mybutton.center.x, location.y)];
                if(location.y>[self screenHeight]-MYBUTTON_ORINGI_HIGHT/2){
                    [self.mybutton setCenter:CGPointMake(self.mybutton.center.x, [self screenHeight]-MYBUTTON_ORINGI_HIGHT/2)];
                }
            }else
                [self.mybutton setCenter:CGPointMake(self.mybutton.center.x, MYBUTTON_ORINGI_Y)];

        }
        else
        {
            [self.mybutton setCenter:CGPointMake(location.x, self.mybutton.center.y)];
            [self.firstLayerView setFrame:CGRectMake(self.mybutton.frame.origin.x+MYBUTTONANDFVIEWDIC,0,SCREEM_WIDTH,[self screenHeight])];
 //**按钮推走主屏**//           [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
        }


    }
    else if(([sender state] == UIGestureRecognizerStateEnded) && self.firstSlideEnabled){
        CGPoint velocity = [sender velocityInView:self.view];
        if(self.mybutton.frame.origin.x < MYBUTTON_ADJUSTX_ONE)//撒手的时候按钮拖过了临界点
        {
            if(velocity.x > VELOCITY_X_ADJUST)//水平速度大于adjust则关闭视图
            {
                if(self.mybutton.frame.origin.x < MYBUTTON_ORINGI_X) //似乎这一组if else条件没啥用
                {
           
                    float distance = abs(self.firstLayerView.frame.origin.x - 290);
                    float time = MIN(distance / velocity.x, 0.3);
                    [UIView animateWithDuration:time
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         self.firstLayerView.frame = CGRectMake(290, 0, SCREEM_WIDTH, [self screenHeight]);
//**按钮推走主屏**//                                         [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
                                         self.mybutton.frame=CGRectMake(290-MYBUTTONANDFVIEWDIC, self.mybutton.frame.origin.y, MYBUTTON_ORINGI_WIDTH, MYBUTTON_ORINGI_HIGHT);
                                     }
                                     completion:^(BOOL finished){
                                         
                                         [UIView animateWithDuration:0.15
                                                          animations:^{
                                                              self.firstLayerView.frame = CGRectMake(FIRSTVIEW_START_X, 0, SCREEM_WIDTH, [self screenHeight]);
    //**按钮推走主屏**//                                                          [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
                                                              self.mybutton.frame=CGRectMake(MYBUTTON_ORINGI_X, self.mybutton.frame.origin.y, MYBUTTON_ORINGI_WIDTH, MYBUTTON_ORINGI_HIGHT);
                                                          }
                                                          completion:^(BOOL finished){
                                                          }];
                                         
                                     }];
                }
                else // 似乎没有用的代码
                {
                    
                    float distance = abs(self.firstLayerView.frame.origin.x - FIRSTVIEW_START_X);
                    float time = MIN(distance / velocity.x, 0.3);
                    
                    [UIView animateWithDuration:time
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         self.firstLayerView.frame = CGRectMake(FIRSTVIEW_START_X, 0, SCREEM_WIDTH, [self screenHeight]);
          //**按钮推走主屏**//                               [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
                                     }
                                     completion:^(BOOL finished){
                                     }];
                }
            }
            else
            {
               
                float distance = abs(self.firstLayerView.frame.origin.x);
                float time = MIN(distance / velocity.x, 0.3);
                
                [UIView animateWithDuration:time
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.firstLayerView.frame = CGRectMake(FIRSTVIEW_FINAL_X, 0, SCREEM_WIDTH, [self screenHeight]);
                 //**按钮推走主屏**//                    [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
                                     self.mybutton.frame=CGRectMake(0, self.mybutton.frame.origin.y, MYBUTTON_ORINGI_WIDTH, MYBUTTON_ORINGI_HIGHT);

                                 }
                                 completion:^(BOOL finished) {
                                 }
                 ];
            }
            
        }
        else //撒手的时候没过临界点
        {
            
            if(self.mybutton.frame.origin.x <MYBUTTON_ORINGI_X) //撒手点不到原始位置
            {
             
                float distance = abs(self.firstLayerView.frame.origin.x - 290);
                float time = MIN(distance / velocity.x, 0.3);
                
                [UIView animateWithDuration:time
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{

                                     self.firstLayerView.frame = CGRectMake(290, 0, SCREEM_WIDTH, [self screenHeight]);
                          //**按钮推走主屏**//           [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
                                     self.mybutton.frame=CGRectMake(290-MYBUTTONANDFVIEWDIC, self.mybutton.frame.origin.y, MYBUTTON_ORINGI_WIDTH, MYBUTTON_ORINGI_HIGHT);
                                 }
                                 completion:^(BOOL finished){
                                     
                                     [UIView animateWithDuration:0.15
                                                           delay:0
                                                         options:UIViewAnimationOptionCurveEaseOut
                                                      animations:^{
                                                          self.firstLayerView.frame = CGRectMake(FIRSTVIEW_START_X, 0, SCREEM_WIDTH, [self screenHeight]);
                   //**按钮推走主屏**//                                       [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
                                                          self.mybutton.frame=CGRectMake(MYBUTTON_ORINGI_X, self.mybutton.frame.origin.y, MYBUTTON_ORINGI_WIDTH, MYBUTTON_ORINGI_HIGHT);
                                                      }
                                                      completion:^(BOOL finished){
                                                      }];
                                     
                                 }];
            }
            else  //撒手点在原始位置以外
            {
                
                float distance = abs(self.firstLayerView.frame.origin.x - FIRSTVIEW_START_X);
                float time = MIN(distance / velocity.x, 0.3);
                
                [UIView animateWithDuration:time
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{

                                     self.firstLayerView.frame = CGRectMake(FIRSTVIEW_START_X, 0, SCREEM_WIDTH, [self screenHeight]);
                  //**按钮推走主屏**//                   [self.mainView setFrame:CGRectMake(self.firstLayerView.frame.origin.x-SCREEM_WIDTH, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
                                     self.mybutton.frame=CGRectMake(MYBUTTON_ORINGI_X, self.mybutton.frame.origin.y, MYBUTTON_ORINGI_WIDTH, MYBUTTON_ORINGI_HIGHT);
                                 }
                                 completion:^(BOOL finished){
                                 }];
            }
            
        }
    }
}

- (void)slideInMainView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.firstLayerView.frame = CGRectMake(FIRSTVIEW_START_X, 0, SCREEM_WIDTH, [self screenHeight]);
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
    [self.delegate sayHello:self];
}

- (void)slideToMainView
{
    if(self.firstLayerView.frame.origin.x < 5){
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.firstLayerView.frame = CGRectMake(FIRSTVIEW_START_X, 0, SCREEM_WIDTH, [self screenHeight]);
                         }
                         completion:^(BOOL finished){
                         }];
    }else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.firstLayerView.frame = CGRectMake(0, 0, SCREEM_WIDTH, [self screenHeight]);
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
}

//Make the first layer view the visible one
- (void)slideInFirstLayerView
{
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.firstLayerView.frame = CGRectMake(0, 0, SCREEM_WIDTH, [self screenHeight]);
                     }
                     completion:^(BOOL finished){
                         self.firstLayerViewController.view.userInteractionEnabled = YES;
                     }];
}

- (void) handleSlideFirstView{
    if (self.firstLayerView.frame.origin.x == 0) {
        [self slideToMainView];
    }else{
        [self slideInFirstLayerView];
    }
}



- (void) addDropShadow:(UIView *)mView
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:mView.bounds];
    mView.layer.masksToBounds = NO;
//    mView.layer.shadowColor = [UIColor grayColor].CGColor;
    if(self.shadowOffset.width == 0 && self.shadowOffset.height == 0)
        mView.layer.shadowOffset = CGSizeMake(DEFAULT_SHADOW_WIDTH, DEFAULT_SHADOW_HEIGHT);
    else mView.layer.shadowOffset = self.shadowOffset;
    if (self.shadowOpacity == 0)
        mView.layer.shadowOpacity = DEFAULT_SHADOW_OPACITY;
    else mView.layer.shadowOpacity = self.shadowOpacity;
    
    mView.layer.shadowPath = shadowPath.CGPath;
}

#pragma mark -
#pragma mark Replacement Methods
- (void)replaceFirstLayerViewControllerWithViewController:(UIViewController *)newViewController{
    [self setFirstLayerViewController:newViewController];
//    self.shadowOpacity = 0.2;
    
}




#pragma mark -
#pragma mark Screen Util
- (NSInteger) screenHeight
{
    if (!height) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        height = (int)screenHeight;
    }
    return height;
}

- (CGRect) screenSize
{
    if(size.size.width == 0)
        size = [[UIScreen mainScreen] bounds];
    return size;
}
@end
