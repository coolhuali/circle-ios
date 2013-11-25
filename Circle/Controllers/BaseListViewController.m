//
//  BaseListViewController.m
//  Circle
//
//  Created by admin on 13-9-29.
//  Copyright (c) 2013年 icss. All rights reserved.
//

#import "BaseListViewController.h"

@interface BaseListViewController ()

@end

@implementation BaseListViewController
@synthesize items;

-(void)showMenuItem{
    if(self.navigationController.navigationBar.backItem == nil){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"menu", nil)
             style:UIBarButtonItemStylePlain
            target:(DEMONavigationController *)self.navigationController
            action:@selector(showMenu)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor=[UIColor clearColor];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version>=7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    items = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}
#pragma mark - Pull to Refresh

- (void) pinHeaderView
{
    [super pinHeaderView];
    // do custom handling for the header view
    DemoTableHeaderView *hv = (DemoTableHeaderView *)self.headerView;
    [hv.activityIndicator startAnimating];
    hv.title.text = NSLocalizedString(@"tip.loading", nil);
}
 
- (void) unpinHeaderView
{
    [super unpinHeaderView];
    
    // do custom handling for the header view
    [[(DemoTableHeaderView *)self.headerView activityIndicator] stopAnimating];
}
 
//
// Update the header text while the user is dragging
//
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    DemoTableHeaderView *hv = (DemoTableHeaderView *)self.headerView;
    if (willRefreshOnRelease)
        hv.title.text = NSLocalizedString(@"tip.release.refresh", nil);
    else
        hv.title.text = NSLocalizedString(@"tip.pull.refresh", nil);
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
}
#pragma mark - Load More
 
- (void) pinFooterView
{
    [super pinFooterView];
    // do custom handling for the header view
    DemoTableFooterView *hv = (DemoTableFooterView *)self.footerView;
    [hv.activityIndicator startAnimating];
    hv.infoLabel.text = NSLocalizedString(@"tip.loading", nil);
}
- (void) unpinFooterView
{
    [super unpinFooterView];
    
    // do custom handling for the header view
    [[(DemoTableFooterView *)self.footerView activityIndicator] stopAnimating];
}
- (void) footerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    DemoTableFooterView *hv = (DemoTableFooterView *)self.footerView;
    if (willRefreshOnRelease)
        hv.infoLabel.text = NSLocalizedString(@"tip.release.loadmore", nil);
    else
        hv.infoLabel.text = NSLocalizedString(@"tip.pull.loadmore", nil);
}
@end
