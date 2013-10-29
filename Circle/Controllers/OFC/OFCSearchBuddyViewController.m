//
//  OFCSearchBuddyViewController.m
//  OpenFireClient
//
//  Created by CTI AD on 14/1/13.
//  Copyright (c) 2013 com.cti. All rights reserved.
//

#import "OFCSearchBuddyViewController.h"
 
@implementation OFCSearchBuddyViewController
@synthesize resultsTableView;
@synthesize search; 
@synthesize results;
- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"find.title", nil);
        self.search.backgroundColor=[UIColor clearColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(resetSearch)];  
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshResults:) name:kOFCSearchResultNotification object:nil];
    }
    return self;
} 
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //按软键盘右下角的搜索按钮时触发
    NSString *searchTerm=[searchBar text];
    //读取被输入的关键字
    [self handleSearchForTerm:searchTerm];
    //根据关键字，进行处理
    [search resignFirstResponder];
    //隐藏软键盘
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //搜索条输入文字修改时触发
    if([searchText length]==0)
    {//如果无文字输入
        [self resetSearch]; 
        return;
    } 
    [self handleSearchForTerm:searchText];
    //有文字输入就把关键字传给handleSearchForTerm处理
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //取消按钮被按下时触发
    [self resetSearch];
    //重置
    searchBar.text=@"";
    //输入框清空
    [search resignFirstResponder];
    //重新载入数据，隐藏软键盘
    
}
//重置搜索
-(void)resetSearch
{
    isSearching = NO;
  
}
-(void)handleSearchForTerm:(NSString *)searchTerm
{
    if (!isSearching && searchTerm && searchTerm.length > 0) {
        [[OFCXMPPManager sharedManager] sendSearchRequest:searchTerm];
        isSearching = YES;
    }
}

- (void)refreshResults:(NSNotification *)notification
{
    self.results = [[notification userInfo] objectForKey:@"items"];
    [self.resultsTableView reloadData];
    isSearching = NO;
}
- (void)setEditing:(BOOL)editing{
    [super setEditing:editing];
    [resultsTableView setEditing:editing animated:YES];
    if(editing){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target: self action:@selector(doneEditItems)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)doneEditItems
{
    [self setEditing:false];
}

#pragma mark -
#pragma mark UITableView Datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=[self.results count];
    if (count==0) {
        NSLog(@"this triggers, but doesn't stop editing..");
        [resultsTableView setEditing:NO animated:YES];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultcell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"resultcell"];
    }
    NSDictionary *item = [results objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [item objectForKey:@"Name"];
    cell.detailTextLabel.text = [item objectForKey:@"Email"];
     
    UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showAddItems:)];
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSDictionary *item = [results objectAtIndex:indexPath.row]; 
        [[OFCXMPPManager sharedManager].xmppRoster subscribePresenceToUser:[XMPPJID jidWithString:[item objectForKey:@"jid"]]]; 
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert;
}
- (void) showAddItems:(UIGestureRecognizer *)recognizer{
    [self setEditing:true];
}
@end
