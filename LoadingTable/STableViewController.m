//
// STableViewController.m
//
// @author Shiki
//

#import "STableViewController.h"

#define DEFAULT_HEIGHT_OFFSET 52.0f

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation STableViewController

@synthesize tableView;
@synthesize headerView;
@synthesize footerView;

@synthesize isDragging;
@synthesize isRefreshing;
@synthesize isLoadingMore;

@synthesize loadMoreEnabled;

@synthesize pullToRefreshEnabled;

@synthesize clearsSelectionOnViewWillAppear;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) initialize
{
  pullToRefreshEnabled = YES;
  
  loadMoreEnabled = YES;
  
  clearsSelectionOnViewWillAppear = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init
{
  if ((self = [super init]))
    [self initialize];  
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
    [self initialize];
  return self;
}
- (void) setupHeader{
    // set the custom view for "pull to refresh". See DemoTableHeaderView.xib.
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DemoTableHeaderView" owner:self options:nil];
    self.headerView = (DemoTableHeaderView *)[nib objectAtIndex:0];
}
- (void) setupFooter{ 
    // set the custom view for "load more". See DemoTableFooterView.xib.
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DemoTableFooterView" owner:self options:nil];
    self.footerView = (DemoTableFooterView *)[nib objectAtIndex:0]; 
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad
{
  [super viewDidLoad];
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableView.dataSource = self;
  tableView.delegate = self;
  
  [self.view addSubview:tableView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (clearsSelectionOnViewWillAppear) {
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected)
      [self.tableView deselectRowAtIndexPath:selected animated:animated];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Pull to Refresh

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setHeaderView:(UIView *)aView
{
  if (!tableView)
    return;
    if (headerView && [headerView isDescendantOfView:tableView]){
        [headerView removeFromSuperview];
        headerView = nil;
    }
    if (aView) {
        headerView = aView;
        CGRect f = headerView.frame;
        headerView.frame = CGRectMake(f.origin.x, 0 - f.size.height, f.size.width, f.size.height);
        headerViewFrame = headerView.frame;
        [tableView addSubview:headerView];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) headerRefreshHeight
{
  if (!CGRectIsEmpty(headerViewFrame))
    return headerViewFrame.size.height;
  else
    return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinHeaderView
{
  [UIView animateWithDuration:0.3 animations:^(void) {
    self.tableView.contentInset = UIEdgeInsetsMake([self headerRefreshHeight], 0, 0, 0);
  }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinHeaderView
{
  [UIView animateWithDuration:0.8 animations:^(void) {
    self.tableView.contentInset = UIEdgeInsetsZero;
  }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginRefresh
{ 
  if (pullToRefreshEnabled)
    [self pinHeaderView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willShowHeaderView:(UIScrollView *)scrollView
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) refresh
{
  if (isRefreshing)
    return NO;
  
  [self willBeginRefresh];
  isRefreshing = YES;
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) refreshCompleted
{
  isRefreshing = NO;
  
  if (pullToRefreshEnabled)
    [self unpinHeaderView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterView:(UIView *)aView
{
  if (!tableView)
    return;
    if (footerView && [footerView isDescendantOfView:tableView]){
        [footerView removeFromSuperview];
        footerView = nil;
    }
    if (aView) {
        footerView = aView;
        CGRect f = footerView.frame;
        footerView.frame = CGRectMake(f.origin.x,CGFLOAT_MAX, f.size.width, f.size.height);
        footerViewFrame = footerView.frame;
        [tableView addSubview:footerView];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinFooterView
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.tableView.contentInset = UIEdgeInsetsMake([self footerLoadMoreHeight], 0, 0, 0);
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinFooterView
{
    [UIView animateWithDuration:0.8 animations:^(void) {
        self.tableView.contentInset = UIEdgeInsetsZero;
        CGRect f = footerView.frame;
        footerView.frame = CGRectMake(f.origin.x,CGFLOAT_MAX, f.size.width, f.size.height);
    }];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginLoadingMore
{ 
    if (loadMoreEnabled){
        [self pinFooterView];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadMoreCompleted
{
    isLoadingMore = NO;
    if (loadMoreEnabled){
        [self unpinFooterView];
    }
}
- (void) footerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (isLoadingMore)
    return NO;
  
  [self willBeginLoadingMore];
  isLoadingMore = YES;  
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
/*
- (CGFloat) footerLoadMoreHeight
{
  if (footerView)
    return footerView.frame.size.height;
  else
    return DEFAULT_HEIGHT_OFFSET;
}
*/
- (CGFloat) footerLoadMoreHeight
{
    if (!CGRectIsEmpty(footerViewFrame))
        return footerViewFrame.size.height;
    else
        return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) allLoadingCompleted
{
  if (isRefreshing)
    [self refreshCompleted];
  if (isLoadingMore)
    [self loadMoreCompleted];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if (isRefreshing || isLoadingMore)
    return;
  isDragging = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (!isRefreshing && isDragging && scrollView.contentOffset.y < 0) {
    [self headerViewDidScroll:scrollView.contentOffset.y < 0 - [self headerRefreshHeight]
                   scrollView:scrollView];
      //return;
  }
    float ch =scrollView.contentSize.height;
    float fh =scrollView.frame.size.height;
    float cy =scrollView.contentOffset.y;
    float pos = ch - fh - cy;
    if (!isLoadingMore && isDragging && ch>fh && pos<0) {
      footerView.frame = CGRectMake(0,ch,320, 50);
      [self footerViewDidScroll:pos < 0 - [self footerLoadMoreHeight]
                     scrollView:scrollView];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if (isRefreshing || isLoadingMore)
    return;
  isDragging = NO;
  if (pullToRefreshEnabled &&  scrollView.contentOffset.y <= 0 - [self headerRefreshHeight]) {
      [self refresh];
  }
  else if (loadMoreEnabled && scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y < 0 -[self footerLoadMoreHeight]) {
        [self loadMore];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
//这个方法根据参数editingStyle是UITableViewCellEditingStyleDelete
//还是UITableViewCellEditingStyleDelete执行删除或者插入
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)
sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}
- (void) setTableEditing:(BOOL)editing{
    [self.tableView setEditing:editing];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) releaseViewComponents
{

}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidUnload
{
  [self releaseViewComponents];
  [super viewDidUnload];
}

@end
