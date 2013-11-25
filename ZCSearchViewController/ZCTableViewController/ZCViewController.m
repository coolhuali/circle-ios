//
//  ZCViewController.m
//  ZCTableview
//
//  Created by Iijy ZC on 13-11-25.
//  Copyright (c) 2013年 Iijy ZC. All rights reserved.
//

#import "ZCViewController.h"
#import "ZCTableCell.h"

@interface ZCViewController ()<
UITableViewDataSource,
UITableViewDelegate>{
    NSArray *sections;
    NSArray *rows;
    NSArray *signs;
    NSArray *counts;
}

@end

@implementation ZCViewController

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
    // Do any additional setup after loading the view from its nib.
    sections = @[@"",@"A", @"D", @"F", @"M", @"N", @"O", @"Z"];
    
    rows = @[@[@"from here you can tell customs everything"],
             @[@"adam", @"alfred", @"ain", @"abdul", @"anastazja", @"angelica"],
             @[@"dennis" , @"deamon", @"destiny", @"dragon", @"dry", @"debug", @"drums"],
             @[@"Fredric", @"France", @"friends", @"family", @"fatish", @"funeral"],
             @[@"Mark", @"Madeline"],
             @[@"Nemesis", @"nemo", @"name"],
             @[@"Obama", @"Oprah", @"Omen", @"OMG OMG OMG", @"O-Zone", @"Ontario"],
             @[@"Zeus", @"Zebra", @"zed"]];
    signs = @[@[@""],
             @[@"adam", @"alfred", @"ain", @"abdul", @"anastazja", @"angelica"],
             @[@"dennis" , @"deamon", @"destiny", @"dragon", @"dry", @"debug", @"drums"],
             @[@"Fredric", @"France", @"friends", @"family", @"fatish", @"funeral"],
             @[@"Mark", @"Madeline"],
             @[@"Nemesis", @"nemo", @"name"],
             @[@"Obama", @"Oprah", @"Omen", @"OMG OMG OMG", @"O-Zone", @"Ontario"],
             @[@"Zeus", @"Zebra", @"ze"]];
    counts = @[@[@""],
              @[@"10/20", @"10/20", @"10/20", @"10/20", @"10/20", @"10/20"],
              @[@"10/20" , @"10/20", @"10/20", @"10/20", @"10/20", @"10/20", @"10/20"],
              @[@"10/20", @"10/20", @"10/20", @"10/20", @"10/20", @"10/20"],
              @[@"10/20", @"10/20"],
              @[@"10/20", @"10/20", @"10/20"],
              @[@"10/20", @"10/20", @"10/20", @"10/20", @"10/20", @"10/20"],
              @[@"10/20", @"10/20", @"10/20"]];
    
    _mytabel=[[UITableView alloc]init];
    _mytabel.frame=self.view.frame;//kZC_TBRECT;
    _mytabel.delegate=self;
    _mytabel.dataSource=self;
    [self.view addSubview:_mytabel];
    //CGRectMake(kZC_TBRECT.origin.x, kZC_TBRECT.origin.y,self.view.frame.size.width, self.view.frame.size.height);
    //    indexBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    [indexBar setIndexes:sections]; // to always have exact number of sections in table and indexBar
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [rows[section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return sections[section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellId = @"ZCCellId";
    
    if (indexPath.section>0) {
        ZCTableCell *cell ;
        if (cell == nil){
            cell = [[ZCTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        UIImageView *cellimage=cell.myimage;
        [cellimage setImage:[UIImage imageNamed:@"test.jpg"]];
        cell.lbTitle.text=rows[indexPath.section][indexPath.row];
        cell.lbCount.text=counts[indexPath.section][indexPath.row];
        cell.lbSign.text=signs[indexPath.section][indexPath.row];
        return cell;
    }
    else
    {
        ZCTableCellOne *cell1=[[ZCTableCellOne alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil];
        cell1.lbTitle.text=rows[indexPath.section][indexPath.row];
        return cell1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {

    return 90;
}
@end
