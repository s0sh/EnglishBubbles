//
//  HistoryVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 12/24/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "HistoryVC.h"
#import "Common.h"

@interface HistoryVC ()

@end

@implementation HistoryVC
@synthesize arrHistory,arrHistoryValues,arrBucketColor,arrBucketValue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSInteger) getAverageWords:(NSString *)action
{
    NSMutableArray *arrUntestedWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = '%@' AND dateOfTest != ''",action] withField:@"dateOfTest"];
    NSInteger days = 0;
    if([arrUntestedWords count]>0)
    {
        for(int i=0;i<[arrUntestedWords count];i++)
        {
            days += [[Common sharedInstance] getDateDifference:[[Common sharedInstance] dateFormDateString:[[arrUntestedWords objectAtIndex:i] substringWithRange:NSMakeRange(0, 19)] format:@"yyyy-MM-dd HH:mm:ss"] endDate:[NSDate date]];
        }
    }   
    else
        return 0;
    return days/[arrUntestedWords count];
}

- (void)setLocalizedString
{
    
    [_bucketHistoryLbl setText:NSLocalizedString(@"Your Word Bucket History", nil)];
    [_wordSavedLabl setText:NSLocalizedString(@"Words saved to Bucket", nil)];
    [_totalTestLeftLbl setText:NSLocalizedString(@"Total tests", nil)];
    [_avgdaysLeftLbl setText:NSLocalizedString(@"Average time in Buckets (days)", nil)];
    [_wordLefttotestLeftLbl setText:NSLocalizedString(@"Word left to test", nil)];
    [_totalWordSearchLbl setText:NSLocalizedString(@"Total words searched", nil)];
    [_yourpassLeftLbl setText:NSLocalizedString(@"Your pass %", nil)];
    [_wordLefttotestLeftLbl setFont:[Common AdjustLabelFont:_wordLefttotestLeftLbl]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLocalizedString];
    arrHistory = [NSArray arrayWithObjects:@"Word left to test",@"Words searched",@"Words saved",@"Total tests",@"Pass percentage",@"Average times(days)", nil];
    arrBucketColor = [NSArray arrayWithObjects:@"Grey",@"Orange",@"Green",@"Red", nil];
    NSMutableArray *arrUntestedWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Dictionary WHERE action = 'Saved'" withField:@"dateOfTest"];
    NSString *strUntestedWords = @"0";
    if([arrUntestedWords count]>0)
        strUntestedWords = [NSString stringWithFormat:@"%d",[arrUntestedWords count]];
     
    NSMutableArray *arrTotalWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Dictionary" withField:@"COUNT(DISTINCT targetWord)"];
    NSString *strTotalWords = @"0";
    if([arrTotalWords count]>0)
        strTotalWords = [arrTotalWords objectAtIndex:0];
    
    NSMutableArray *arrTotalTest = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Dictionary WHERE action != 'Saved' AND action != '' AND action != 'Removed'" withField:@"COUNT(*)"];
    NSString *strTotalTest = @"0";
    if([arrTotalTest count]>0)
        strTotalTest = [arrTotalTest objectAtIndex:0];
    
    NSMutableArray *arrCorrect = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Dictionary WHERE action != 'Saved' AND bucketColor != 'Red'" withField:@"COUNT(*)"];
    float correct = 0;
    if([arrTotalTest count]>0)
        correct = [[arrCorrect objectAtIndex:0] floatValue];
    
    NSMutableArray *arrIncorrect = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Dictionary WHERE action != 'Saved' AND bucketColor = 'Red'" withField:@"COUNT(*)"];
    float incorrect = 0;
    if([arrIncorrect count]>0)
        incorrect = [[arrIncorrect objectAtIndex:0] floatValue];
    
    float passPer = (correct/(correct+incorrect)) * 100;
    
     
    arrBucketValue = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",[self getAverageWords:@"White"]],[NSString stringWithFormat:@"%d",[self getAverageWords:@"Orange"]],[NSString stringWithFormat:@"%d",[self getAverageWords:@"Green"]],[NSString stringWithFormat:@"%d",[self getAverageWords:@"Red"]], nil];
   
    arrHistoryValues = [NSArray arrayWithObjects:strUntestedWords,strTotalWords,strUntestedWords,strTotalTest,[NSString stringWithFormat:@"%.0f%%",passPer],@"", nil];
    
    [self calculateAverageDays];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"History Screen";
}



- (void)calculateAverageDays
{
    NSMutableArray *averageArray = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Average_Time"] withField:@"BucketColor,Time,Counter"];
    NSLog(@"average array is %@",averageArray);
    
    
    NSMutableArray *whiteColorTime = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary where bucketColor = \"White\""] withField:@"dateOfTest"];
    NSLog(@"average array is %@",whiteColorTime);
    
    NSMutableArray *orageColorTime = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary where bucketColor = \"White\""] withField:@"dateOfTest"];
    NSLog(@"average array is %@",orageColorTime);
    
    NSMutableArray *greenColorTime = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary where bucketColor = \"White\""] withField:@"dateOfTest"];
    NSLog(@"average array is %@",greenColorTime);
    
    NSMutableArray *redColorTime = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary where bucketColor = \"White\""] withField:@"dateOfTest"];
    NSLog(@"average array is %@",redColorTime);
    
    NSInteger whiteBucketMin = 0;
    NSInteger orangeBucketMin = 0;
    NSInteger greenBucketMin = 0;
    NSInteger redBucketMin = 0;
    NSDate *currentDate = [NSDate date];
    
    for (int k = 0; k < [whiteColorTime count]; k++) {
        NSDate *olderDate = [Common dateFromString:[whiteColorTime objectAtIndex:k]];
        if (olderDate){
            NSInteger timediff = [currentDate timeIntervalSinceDate:olderDate];
            whiteBucketMin = whiteBucketMin + timediff/60;
        }
        
    }
    
    if (whiteColorTime.count>0)
        whiteBucketMin = whiteBucketMin/whiteColorTime.count;

    
    for (int k = 0; k < [orageColorTime count]; k++) {
        NSDate *olderDate = [Common dateFromString:[orageColorTime objectAtIndex:k]];
        if (olderDate){
            NSInteger timediff = [currentDate timeIntervalSinceDate:olderDate];
            orangeBucketMin = orangeBucketMin + timediff/60;
        }
        
    }
    
    if (orageColorTime.count>0)
        orangeBucketMin = orangeBucketMin/orageColorTime.count;
    
    for (int k = 0; k < [greenColorTime count]; k++) {
        NSDate *olderDate = [Common dateFromString:[greenColorTime objectAtIndex:k]];
        if (olderDate){
            NSInteger timediff = [currentDate timeIntervalSinceDate:olderDate];
            greenBucketMin = greenBucketMin + timediff/60;
        }
        
    }
    
    if (greenColorTime.count>0)
        greenBucketMin = greenBucketMin/greenColorTime.count;
    
    
    for (int k = 0; k < [redColorTime count]; k++) {
        NSDate *olderDate = [Common dateFromString:[redColorTime objectAtIndex:k]];
        if (olderDate){
            NSInteger timediff = [currentDate timeIntervalSinceDate:olderDate];
            redBucketMin = redBucketMin + timediff/60;
        }
        
    }
    
    if (redColorTime.count>0)
        redBucketMin = redBucketMin/redColorTime.count;
     
    NSArray *splitArray = [[averageArray objectAtIndex:0] componentsSeparatedByString:@"/|"];
    if([splitArray count]>2 && ([[splitArray objectAtIndex:2] intValue] !=0))
    whiteBucketMin = whiteBucketMin + [[splitArray objectAtIndex:1] intValue]/[[splitArray objectAtIndex:2] intValue];
    
    splitArray=nil;
    splitArray = [[averageArray objectAtIndex:1] componentsSeparatedByString:@"/|"];
    if([splitArray count]>2 && ([[splitArray objectAtIndex:2] intValue] !=0))
    orangeBucketMin = orangeBucketMin + [[splitArray objectAtIndex:1] intValue]/[[splitArray objectAtIndex:2] intValue];
    
    splitArray=nil;
    splitArray = [[averageArray objectAtIndex:2] componentsSeparatedByString:@"/|"];
    if([splitArray count]>2 && ([[splitArray objectAtIndex:2] intValue] !=0))
    greenBucketMin = greenBucketMin + [[splitArray objectAtIndex:1] intValue]/[[splitArray objectAtIndex:2] intValue];
    
    splitArray=nil;
    splitArray = [[averageArray objectAtIndex:3] componentsSeparatedByString:@"/|"];
    if([splitArray count]>2 && ([[splitArray objectAtIndex:2] intValue] !=0))
    redBucketMin = redBucketMin + [[splitArray objectAtIndex:1] intValue]/[[splitArray objectAtIndex:2] intValue];
    
    
    [_whiteBcktAvgTimeTxt setText:[NSString stringWithFormat:@"%d",(whiteBucketMin/(60*60))]];
    [_orangeBcktAvgTimeTxt setText:[NSString stringWithFormat:@"%d",(orangeBucketMin/(60*60))]];
    [_greenBcktAvgTimeTxt setText:[NSString stringWithFormat:@"%d",(greenBucketMin/(60*60))]];
    [_redBcktAvgTimeTxt setText:[NSString stringWithFormat:@"%d",(redBucketMin/(60*60))]];

    
//    [_whiteBcktAvgTimeTxt setText:[NSString stringWithFormat:@"%d",(whiteBucketMin/1)]];
//    [_orangeBcktAvgTimeTxt setText:[NSString stringWithFormat:@"%d",(orangeBucketMin/1)]];
//    [_greenBcktAvgTimeTxt setText:[NSString stringWithFormat:@"%d",(greenBucketMin/1)]];
//    [_redBcktAvgTimeTxt setText:[NSString stringWithFormat:@"%d",(redBucketMin/1)]];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_scrollView setContentSize:CGSizeMake(320, 555)];
    
    [_whiteTestTxt setText:[NSString stringWithFormat:@"%d",[[UserDefaluts objectForKey:kWhiteTestCount] integerValue]]];
    [_redTestTxt setText:[NSString stringWithFormat:@"%d",[[UserDefaluts objectForKey:kRedTestCount] integerValue]]];
    [_orangeTestTxt setText:[NSString stringWithFormat:@"%d",[[UserDefaluts objectForKey:kOrangeTestCount] integerValue]]];
    [_greenTestTxt setText:[NSString stringWithFormat:@"%d",[[UserDefaluts objectForKey:kGreenTestCount] integerValue]]];
    NSLog(@"%d",[[UserDefaluts objectForKey:kWhiteTestCount] integerValue]);
    NSLog(@"%@",[UserDefaluts objectForKey:kRedTestCount]);
    
    NSInteger totalWord = ([[UserDefaluts objectForKey:kWhiteTestCount] integerValue]+[[UserDefaluts objectForKey:kRedTestCount] integerValue]+[[UserDefaluts objectForKey:kGreenTestCount] integerValue]+[[UserDefaluts objectForKey:kOrangeTestCount] integerValue]);
    
    [_totalTestLbl setText:[NSString stringWithFormat:@"%d",totalWord]];
    NSInteger correctWord = [[UserDefaluts objectForKey:kCorrectCounter] integerValue];
    
    CGFloat passPercent = ((CGFloat)correctWord/totalWord)*100;
    NSLog(@"%f",passPercent);
    passPercent =  isnan(passPercent) ? 0.0:passPercent;
    [_passLabel setText:[NSString stringWithFormat:@"%0.2f",passPercent]];
    
    [_totalSearchWordLbl setText:[NSString stringWithFormat:@"%d",[[UserDefaluts objectForKey:kTotalSearchWord] intValue]]];
    
    [_savedWordLbl setText:[NSString stringWithFormat:@"%d",[[UserDefaluts objectForKey:kTotalSavedWord] intValue]]];
    
    // Word left to test
    NSString *totalSaveWrod = [[DBHelper sharedDbInstance] getSingleStringWithQuery:@"select COUNT(*) from tbl_Dictionary WHERE action = 'Saved'"];
    [_wordLefttoTestLabel setText:totalSaveWrod];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma UITableview datasource methods
//table data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) 
        return 119;
    return 84;
}

//-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10.0;
//}
//

//-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1.0;
//}
//
//-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
//}


/*
-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i%i",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UILabel *lblHistory = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 180, 25)];
    [lblHistory setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [lblHistory setText:[NSString stringWithFormat:@"%@",[arrHistory  objectAtIndex:indexPath.section]]];
    [cell.contentView addSubview:lblHistory];
    lblHistory = nil;
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShare setTitle:@"Share" forState:UIControlStateNormal];
    btnShare.frame = CGRectMake(170, 12, 40, 30 );
    
    UILabel *lblValue = [[UILabel alloc] initWithFrame:CGRectMake(190, 12, 100, 25)];
    [lblValue setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    lblValue.textAlignment = UITextAlignmentRight;
    [lblValue setText:[NSString stringWithFormat:@"%@",[arrHistoryValues objectAtIndex:indexPath.section]]];
    [cell.contentView addSubview:lblValue];
    lblValue = nil;
    
    if(indexPath.section == 5)
    {
        for(int j=0;j<[arrBucketColor count];j++)
        {
            UIButton *btnBucket = [[UIButton alloc] initWithFrame:CGRectMake(j*80+10, 45, 30, 32)];
            [btnBucket setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bucket%@.png",[arrBucketColor objectAtIndex:j]]] forState:UIControlStateNormal];
            [btnBucket setTitle:[arrBucketValue objectAtIndex:j] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnBucket];
//            btnBucket = nil;
        }
    }
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    //[cell.textLabel setText:@"Row titile"];
    
    if (indexPath.row == 0 || indexPath.row == 1 ||indexPath.row == 3 ) {
    
    UILabel *titleLbl = [Common createNewLabelWithTag:indexPath.row WithFrame:CGRectMake(26, 11, 178, 28) text:@"" noOfLines:1 color:[UIColor blackColor] withFont:titleFont];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(26, 47, 66, 20)];
    [shareButton setImage:GetImage(@"btnShare") forState:UIControlStateNormal];
    [shareButton setImage:GetImage(@"btnSharePressed") forState:UIControlStateNormal];
    [shareButton setTag:indexPath.row];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *detailLabel = [Common createNewLabelWithTag:indexPath.row WithFrame:CGRectMake(193, 8, 107, 67) text:@"" noOfLines:1 color:[UIColor blueColor] withFont:[UIFont fontWithName:@"Helvetica-Light" size:40]];
        
        switch (indexPath.row) {
            case 0:
            {
                [titleLbl setText:@"Total words searched"];
                [detailLabel setText:@"215"];
            }
                break;
            case 1:
            {
                [titleLbl setText:@"Words saved to Bucket"];
                [detailLabel setText:@"98"];
            }
                break;
            case 3:
            {
                [titleLbl setText:@"Your pass %"];
                [detailLabel setText:@"63%"];
            }
                break;
                
            default:
                break;
        }
        
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 295, 84)];
        [bgImageView setImage:GetImage(@"historywhiteContainerSmall")];
        [cell.contentView addSubview:bgImageView];
        
        [cell.contentView addSubview:titleLbl];
        [cell.contentView addSubview:shareButton];
        [cell.contentView addSubview:detailLabel];
        
    } else if (indexPath.row == 2) {
        
        UILabel *titleLbl = [Common createNewLabelWithTag:indexPath.row WithFrame:CGRectMake(26, 0, 171, 28) text:@"Total Word Searched" noOfLines:1 color:[UIColor blackColor] withFont:titleFont];
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(26, 30, 66, 20)];
        [shareButton setImage:GetImage(@"btnShare") forState:UIControlStateNormal];
        [shareButton setImage:GetImage(@"btnSharePressed") forState:UIControlStateNormal];
        [shareButton setTag:indexPath.row];
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *detailLabel = [Common createNewLabelWithTag:indexPath.row WithFrame:CGRectMake(193, 80, 107, 55) text:@"1476" noOfLines:1 color:[UIColor blueColor] withFont:[UIFont fontWithName:@"Helvetica-Light" size:40]];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 295, 119)];
        [bgImageView setImage:GetImage(@"historywhiteContainerSmall")];
        [cell.contentView addSubview:bgImageView];
        
        
    } else {
        
        
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
*/


- (void)viewDidUnload {
    [self setHistoryTable:nil];
    [self setTotalSearchWordLbl:nil];
    [self setSavedWordLbl:nil];
    [self setTotalTestLbl:nil];
    [self setPassLabel:nil];
    [self setWhiteTestTxt:nil];
    [self setRedTestTxt:nil];
    [self setOrangeTestTxt:nil];
    [self setGreenTestTxt:nil];
    [self setWhiteBcktAvgTimeTxt:nil];
    [self setRedBcktAvgTimeTxt:nil];
    [self setOrangeBcktAvgTimeTxt:nil];
    [self setGreenBcktAvgTimeTxt:nil];
    [self setScrollView:nil];
    [self setWordLefttoTestLabel:nil];
    [self setBucketHistoryLbl:nil];
    [self setTotalWordSearchLbl:nil];
    [self setWordSavedLabl:nil];
    [self setTotalTestLbl:nil];
    [self setTotalTestLeftLbl:nil];
    [self setYourpassLeftLbl:nil];
    [self setAvgdaysLeftLbl:nil];
    [self setWordLefttotestLeftLbl:nil];
    [super viewDidUnload];
}
- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    /*for(UIView *view in self.tabBarController.tabBar.subviews) {
     if([view isKindOfClass:[UIImageView class]]) {
     [view removeFromSuperview];
     }
     }
     [self.tabBarController setSelectedIndex:1];
     UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"learnsel.png"]];
     [self.tabBarController.tabBar insertSubview:imgView atIndex:0];
     [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];*/
}


@end
