 
#import "ChatViewController.h"
#import "ChatSettingViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
 
#pragma mark Accessors
- (void)viewDidLoad
{
    [super viewDidLoad];
    [super showMenuItem];
    //self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(popChatSetting)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
} 

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)popChatSetting{
    
    ChatSettingViewController *control = [[ChatSettingViewController alloc]init];
    
    [self presentViewController:control animated:YES completion:nil];
}
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
@end
