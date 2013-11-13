//
//  POPDViewController.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "POPDViewController.h"
#import "POPDCell.h"
#import "ZCObjects.h"
#import <QuartzCore/QuartzCore.h>
#define TABLECOLOR [UIColor colorWithRed:62.0/255.0 green:76.0/255.0 blue:87.0/255.0 alpha:0.4]
#define CELLSELECTED [UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:0.4]
#define SEPARATOR [UIColor clearColor]
#define SEPSHADOW [UIColor clearColor]
#define SHADOW [UIColor clearColor]
#define TEXT [UIColor whiteColor]

//#define SHADOW [UIColor colorWithRed:69.0/255.0 green:84.0/255.0 blue:95.0/255.0 alpha:0.8]
//#define SEPARATOR [UIColor colorWithRed:31.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:0.8]
//#define SEPSHADOW [UIColor colorWithRed:80.0/255.0 green:97.0/255.0 blue:110.0/255.0 alpha:0.8]
//#define TEXT [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:213.0/255.0 alpha:0.8]
static NSString *kheader = @"State";
static NSString *ksubSection = @"Cities";
static NSString *ksubtxt =@"city";
@interface POPDViewController (){
    BOOL buttonmark;//判断location的button是“＋”还是“－”
}

@end


@implementation POPDViewController
@synthesize delegate;

- (id)initWithMenuSections:(NSArray *) menuSections
{
    self = [super init];
    if (self) {
        self.sections = menuSections;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    buttonmark=NO;
    self.tableView.backgroundColor = TABLECOLOR;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.frame = self.view.frame;
    self.sectionsArray = [NSMutableArray new];
    self.showingArray = [NSMutableArray new];
    self.SecOrSubArray= [NSMutableArray new];
   [self setMenuSections:self.sections];
    
}

- (void)setMenuSections:(NSArray *)menuSections{
    int i=0;
    for (NSDictionary *sec in menuSections) {
        
        NSString *header = [sec objectForKey:kheader];
        NSArray *subSection = [sec objectForKey:ksubSection];

        NSMutableArray *section = [NSMutableArray new];
        NSMutableArray *secorsub = [NSMutableArray new];
        [section addObject:header];
        [secorsub addObject:[NSNumber numberWithBool:YES]];
        for (NSDictionary *sub in subSection) {
            [section addObject:[sub objectForKey:ksubtxt]];
            [secorsub addObject:[NSNumber numberWithBool:NO]];
        }
        [self.sectionsArray addObject:section];
        [self.SecOrSubArray addObject:secorsub];
        [self.showingArray addObject:[NSNumber numberWithBool:NO]];
        
//        NSLog(@"%@",[[self.SecOrSubArray objectAtIndex:i]objectAtIndex:0]);
        i++;
    }
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    if (![[self.showingArray objectAtIndex:section]boolValue]) {
        return 1;
    }
    else{
//        NSLog(@"%d", [[self.sectionsArray objectAtIndex:section]count]);
        return [[self.sectionsArray objectAtIndex:section]count];;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row ==0){
    if([[self.showingArray objectAtIndex:indexPath.section]boolValue]){
        [cell setBackgroundColor:[UIColor colorWithRed:62.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.4 ]];
    }else{
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.SecOrSubArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue]) {
          POPDCell *cell = [[POPDCell alloc]init];
        if (cell == nil) {
            cell = [[POPDCell alloc]init];
        }
        
        cell.label.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.label.textColor = TEXT;
        if (buttonmark==NO) {
            [cell.button setTitle:@"+" forState:UIControlStateNormal];

        }else   [cell.button  setTitle:@"-" forState:UIControlStateNormal];
        cell.button.tag=indexPath.section+1000;
        UITapGestureRecognizer *tapbutton=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickbutton:)];
        [cell.button addGestureRecognizer:tapbutton];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else {
            POPDCellSub *cell = [[POPDCellSub alloc]init];
            if (cell == nil) {
                cell = [[POPDCellSub alloc]init];
            }
            
            cell.labelsub.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.labelsub.textColor = TEXT;
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
    }
}
-(void)clickbutton:(UIGestureRecognizer *)ges{
    NSInteger indexPathsec=ges.view.tag-1000;
//    NSLog(@"%d",indexPathsec);
    [self tabbutton:self.tableView :indexPathsec];
}
-(void)tabbutton:(UITableView *)tableView :(NSInteger )indexPathsec{
        NSLog(@"%d",indexPathsec);

    if([[self.showingArray objectAtIndex:indexPathsec]boolValue]){
        [self.showingArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPathsec];
        buttonmark=NO;
        UIButton *but=(UIButton *)[self.view viewWithTag:indexPathsec+1000];
        [but setTitle:@"+" forState:UIControlStateNormal];
    }else{
        [self.showingArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPathsec];
        UIButton *but=(UIButton *)[self.view viewWithTag:indexPathsec+1000];
        [but setTitle:@"-" forState:UIControlStateNormal];
        buttonmark=YES;
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPathsec] withRowAnimation:UITableViewRowAnimationFade];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.delegate didSelectRowAtIndexPath:indexPath];
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.SecOrSubArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue]) {
        return 17;
    }else {
        return 14;
    }//cell高度
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
