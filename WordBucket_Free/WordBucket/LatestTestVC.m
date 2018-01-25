//
//  LatestTestVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 12/26/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "LatestTestVC.h"
#import "Common.h"
@interface LatestTestVC ()

@end

@implementation LatestTestVC

@synthesize tbTest,arrLatest;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Share your tests";
    //    tbTest.frame= CGRectMake(4, tbTest.frame.origin.y+60, tbTest.frame.size.width, tbTest.frame.size.height);
//    arrTest = [NSMutableArray arrayWithObjects:@"Test 1",@"Test 2",@"Test 3",@"Test 4", nil];
//    arrTestBucketImg = [NSMutableArray arrayWithObjects:@"bucketGreen.png",@"bucketWhite.png",@"bucketOrange.png",@"bucketRed.png", nil];
//    arrTestValue = [NSMutableArray arrayWithObjects:@"09/09",@"09/09",@"17/08",@"25/07", nil];
    
    arrLatest = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Result ORDER BY dateOfTest DESC" withField:@"testColor, dateOfTest, score, noOfWords"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableview datasource methods
//table data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrLatest count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i%i",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *arrValues = [[arrLatest objectAtIndex:indexPath.section] componentsSeparatedByString:@"/|"];
    
    UILabel *lblvalue = [[UILabel alloc] initWithFrame:CGRectMake(10, 05, 50, 40)];
    UILabel *lblSetting = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 200, 25)];
    lblvalue.textAlignment = UITextAlignmentCenter;
    [lblvalue setText:[NSString stringWithFormat:@"%@",[[Common sharedInstance] stringDateFromString:[arrValues  objectAtIndex:1]]]];
    
    NSString *imgName = [NSString stringWithFormat:@"bucket%@.png",[[Common sharedInstance] getBucketColor:[arrValues objectAtIndex:0]]];
    UIImageView *imgBucket = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    imgBucket.frame=CGRectMake(70, 05, 30, 35);
    [lblSetting setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    lblSetting.textAlignment = UITextAlignmentCenter;
    [lblSetting setText:[NSString stringWithFormat:@"Test %@",[arrValues objectAtIndex:2]]];
    
    [lblSetting setBackgroundColor:[UIColor clearColor]];
    
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(220, 05, 50, 40)];
    [btnShare setTitle:@"Share" forState:UIControlStateNormal];
    [btnShare setBackgroundColor:[UIColor whiteColor]];
    [btnShare setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cell.contentView addSubview:btnShare];
    [cell.contentView addSubview:lblvalue];
    [cell.contentView addSubview:imgBucket];
    [cell.contentView addSubview:lblSetting];
    lblSetting = nil;
    
    return cell;
}

@end
