//
//  ResultsVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 12/20/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "ResultsVC.h"
#import "PreGreenTestVC.h"
//#import "WhiteTestViewController.h"

#import "Common.h"
@interface ResultsVC ()

@end

@implementation ResultsVC

bool bannerLoadded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //UIView *view = [[UIView alloc] init];
        //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        //view = nil;
        // Custom initialization
        //self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)setLocalizedString
{
    [_scoreTexLbl setText:NSLocalizedString(@"Score:", nil)];
    [_btnTestAgain setTitle:NSLocalizedString(@"TEST AGAIN", nil) forState:UIControlStateNormal];
    [_btnTestAgain.titleLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)viewDidLoad
{
    
    [self setLocalizedString];
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    NSLog(@"result id array is %@",_resultIdArray);
    // Do any additional setup after loading the view from its nib.
    NSString *strTest = @"(action ='WhiteTest1' OR action = 'WhiteTest2')";
    if([self.lblColor isEqualToString:@"Orange"])
        strTest = @"(action ='OrangeTest1' OR action = 'OrangeTest2')";
    else if([self.lblColor isEqualToString:@"Red"])
        strTest = @"'1'";
    else if([self.lblColor isEqualToString:@"Green"])
        strTest = @"(action ='GreenTest' OR action ='InDanger')";
    else if([self.lblColor isEqualToString:@"All"])
        strTest = @"";
    
    
    
    /*
    NSMutableArray *countRight = nil;
    if ([strTest isEqualToString:@""]){
        self.arrTestWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE dateOfTest = '%@'",[UserDefaluts objectForKey:@"CurrentTestDate"]] withField:@"DISTINCT targetWord, bucketColor,action"];
        countRight = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE dateOfTest = '%@' AND bucketColor != 'Red'",[UserDefaluts objectForKey:@"CurrentTestDate"]] withField:@"Count(*)"];
        
    } else {
        
        self.arrTestWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE %@ AND dateOfTest = '%@'",strTest,[UserDefaluts objectForKey:@"CurrentTestDate"]] withField:@"DISTINCT targetWord, bucketColor,action"];
       countRight = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE %@ AND dateOfTest = '%@' AND bucketColor != 'Red'",strTest,[UserDefaluts objectForKey:@"CurrentTestDate"]] withField:@"Count(*)"];
    }*/
    
    
    NSString *idString = [Common getStringValueSeperatedByCommaWithArray:_resultIdArray];
    NSString *correctWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT count(*) FROM tbl_Dictionary where bucketColor != 'Red' AND action != 'InDanger' and id  IN(%@)",idString]];
    
    self.arrTestWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE id IN (%@)",idString] withField:@"targetWord, bucketColor,action"];
    
    self.lblScore.text = [NSString stringWithFormat:@"%@/%d",correctWord,_resultIdArray.count];
    
    
    if ([self.lblColor isEqualToString:@"White"]) {
        
        _bucketImage = GetImage(@"bucketWhite2");
        
    } else if ([self.lblColor isEqualToString:@"Orange"]) {
        
        _bucketImage = GetImage(@"bucketOrange2");
        
    } else if ([self.lblColor isEqualToString:@"Green"]) {
        
        _bucketImage = GetImage(@"bucketGreen2");
        
    } else if ([self.lblColor isEqualToString:@"InDanger"]) {
        
        _bucketImage = GetImage(@"iconDangerBucket");
        
    } else {
        
        _bucketImage = GetImage(@"bucketRed2");
    }
    
    _greenbucketImage = GetImage(@"bucketGreen2");
    _redbucketImage = GetImage(@"bucketRed2");
    
    UIButton *testAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testAgainButton setFrame:CGRectMake(0, 0, 295, 48)];
    [testAgainButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"btnTestAgain" ofType:@"png"]] forState:UIControlStateNormal];
    [testAgainButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"btnTestAgainPressed" ofType:@"png"]] forState:UIControlStateHighlighted];
    [testAgainButton addTarget:self action:@selector(testAgain:) forControlEvents:UIControlEventTouchUpInside];
    //self.tblResult.tableFooterView = testAgainButton;
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Test Result Screen";
    
    [SharedAppDelegate.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Test_Result" action:@"Test_Finish" label:@"WordBucket-Free" value:nil] build]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBanner:) name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerError:) name:@"bannerError" object:nil];
    [self addBannerView];
    [[Common sharedInstance] synconCloud];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bannerError" object:nil];
    //[[SharedAppDelegate sharedAd] removeFromSuperview];
}

- (void)addBannerView
{
    [SharedAdBannerView removeFromSuperview];
    [self.view addSubview:SharedAdBannerView];
    
    if (SharedAdBannerView.bannerLoaded==true) {
        SharedAdBannerView.hidden=false;
        bannerLoadded=true;
        
    } else {
        bannerLoadded=false;
    }
}
-(void)loadBanner:(NSNotification *)notifcation{
    
    if (bannerLoadded==false) {
        SharedAdBannerView.hidden = false;
        bannerLoadded = true;
        
        [UIView beginAnimations:@"fixupViews" context:nil];
        CGRect adBannerViewFrame = [SharedAdBannerView frame];
        adBannerViewFrame.origin.x = 0;
        adBannerViewFrame.origin.y = SharedAppDelegate.isPhone5 ? 449 : 361;//self.view.frame.size.height-50;
        [SharedAdBannerView setFrame:adBannerViewFrame];
        [UIView commitAnimations];
    }
}
-(void)bannerError:(NSNotification *)notifcation{
    
    [UIView beginAnimations:@"fixupViews" context:nil];
    CGRect adBannerViewFrame = [SharedAdBannerView frame];
    adBannerViewFrame.origin.x = 0;
    adBannerViewFrame.origin.y = self.view.frame.size.height;
    [SharedAdBannerView setFrame:adBannerViewFrame];
    [UIView commitAnimations];
    
    SharedAdBannerView.hidden = false;
    bannerLoadded = false;
    
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrTestWords count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"ResultVCCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    NSArray *splitArray = [[self.arrTestWords objectAtIndex:indexPath.row] componentsSeparatedByString:@"/|"];
    NSString *targetWord = @"";
    NSString *bucketColor = @"";
    NSString *actionString = @"";
    
    if (splitArray.count>2) {
        
        targetWord = [splitArray objectAtIndex:0];
        bucketColor = [splitArray objectAtIndex:1];
        actionString = [splitArray objectAtIndex:2];
    }
    
     UIImageView *tickImage = (UIImageView*)[cell.contentView viewWithTag:101];
    
     UIImageView *firstBucket = (UIImageView*)[cell.contentView viewWithTag:103];
    [firstBucket setImage:_bucketImage];
     UIImageView *secondBucket = (UIImageView*)[cell.contentView viewWithTag:104];
    
    
    if([self.lblColor isEqualToString:@"All"]) {
        
         if ([actionString rangeOfString:@"OrangeTest"].location != NSNotFound) {
            
            [firstBucket setImage:GetImage(@"bucketOrange2")];
            
        } else if ([actionString rangeOfString:@"GreenTest"].location != NSNotFound) {
            
            [firstBucket setImage:GetImage(@"bucketGreen2")];
            
        } else {
            
            [firstBucket setImage:GetImage(@"bucketWhite2")];
        }
        
    }
    
    if([bucketColor isEqualToString:@"Red"] || [actionString isEqualToString:@"InDanger"]) {
        tickImage.image = GetImage(@"iconWrong");
        
        if([bucketColor isEqualToString:@"Red"])
            [secondBucket setImage:_redbucketImage];
        else
            [secondBucket setImage:GetImage(@"iconDangerBucket")];
            
    } else {
        
        tickImage.image = GetImage(@"iconTick");
        
            if ([bucketColor isEqualToString:@"White"]) {
                
                [secondBucket setImage:GetImage(@"bucketWhite2")];
                
            } else if ([bucketColor isEqualToString:@"Orange"]) {
                
                [secondBucket setImage:GetImage(@"bucketOrange2")];
                
            } else if ([bucketColor isEqualToString:@"Green"] && [actionString isEqualToString:@"InDanger"]) {
                
                [secondBucket setImage:GetImage(@"iconDangerBucket")];
                //[secondBucket setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bucketGreen2" ofType:@"png"]]];
            } else {
                [secondBucket setImage:GetImage(@"bucketGreen2")];
            }
        }
    
    // Item Name
    UILabel *targetWordLabel = (UILabel*)[cell.contentView viewWithTag:102];
    [targetWordLabel setText:targetWord];
    
    return cell;
}


- (void)showAlert
{
    NSString *msgString = nil;
    if ([self.lblColor isEqualToString:@"White"]) {
        msgString = [NSString stringWithFormat:NSLocalizedString(@"Sorry! You need at least %d words in your White Bucket to do a test. Search and save more new words!", nil),SharedAppDelegate.totolQustCount];
    } else if ([self.lblColor isEqualToString:@"Orange"]) {
        
        msgString = [NSString stringWithFormat:NSLocalizedString(@"Sorry! You need at least %d Orange Words to do a test. Do more White Bucket tests!", nil),SharedAppDelegate.totolQustCount];
    } else if ([self.lblColor isEqualToString:@"Red"]) {
        
        msgString = [NSString stringWithFormat:NSLocalizedString(@"Good work! You don't have enough words (%d) in your Red Bucket to do a test. Only words that you get wrong in the other colours go here.", nil),SharedAppDelegate.totolQustCount];
    } else if ([self.lblColor isEqualToString:@"Green"]) {
        msgString = [NSString stringWithFormat:NSLocalizedString(@"Sorry! You need at least 12 words in your Green Bucket to do a test. Do more Orange Bucket tests!", nil)];
    } else {
        
        msgString = [NSString stringWithFormat:NSLocalizedString(@"Good work! You don't have enough words (12) in danger to play. Only words you get wrong in the Green Game go here", nil)];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msgString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
}

- (IBAction)testAgain:(id)sender
{
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.lblColor forKey:kBucketColor];
    if ([self.lblColor isEqualToString:@"White"]) {
        
        if ([[Common sharedInstance] getWordCount:@"White"] >= SharedAppDelegate.totolQustCount) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetakeTestNotification object:nil userInfo:userInfo];
            
        } else
            [self showAlert];   
    
        
    } else if ([self.lblColor isEqualToString:@"Orange"]) {
        
        if ([[Common sharedInstance] getWordCount:@"Orange"] >= SharedAppDelegate.totolQustCount) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetakeTestNotification object:nil userInfo:userInfo];
            
        } else
            [self showAlert];
        
    } else if ([self.lblColor isEqualToString:@"Green"]) {
        
        NSString *greenWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT count(*) FROM tbl_Dictionary where bucketColor = 'Green' and action != 'InDanger'"]];
        if ([greenWord integerValue] >= 12) {
            //[self.navigationController popToRootViewControllerAnimated:NO];
            [self popToPreGreenTest];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetakeGreenTestNotification object:nil userInfo:userInfo];
            
        } else
            [self showAlert];
        
    } else if ([self.lblColor isEqualToString:@"InDanger"]) {
        
        NSString *greenWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT count(*) FROM tbl_Dictionary where bucketColor = 'Green' and action = 'InDanger'"]];
        if ([greenWord integerValue] >= 12) {
            
            [self popToPreGreenTest];
            //[self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetakeGreenTestNotification object:nil userInfo:userInfo];
            
        } else
            [self showAlert];
        
    } else if ([self.lblColor isEqualToString:@"Red"]) {
        
        
        if ([[Common sharedInstance] getWordCount:@"Red"] >= SharedAppDelegate.totolQustCount) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetakeTestNotification object:nil userInfo:userInfo];
            
        } else
            [self showAlert];
        
    } else {
        
        if ([[Common sharedInstance] getAllWordExceptGreen] >= SharedAppDelegate.totolQustCount) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetakeTestNotification object:nil userInfo:userInfo];
            
        } else
            [self showAlert];
    }
    
    /*
    WhiteTestViewController *whiteTest = [[WhiteTestViewController alloc] initWithNibName:@"WhiteTestViewController" bundle:nil];
    whiteTest.strTestColor = self.lblColor;
    [self.navigationController pushViewController:whiteTest animated:YES];
     */
}

- (void)popToPreGreenTest
{
    NSArray *arr = [self.navigationController viewControllers];
    PreGreenTestVC *Obj;
    for (int i = 0; i< arr.count ; i++)
    {
        UIViewController *aviewCont = [arr objectAtIndex:i];
        if ([aviewCont isKindOfClass:[PreGreenTestVC class]])
        {
            Obj = [arr objectAtIndex:i];
            break;
        }
    }
    [self.navigationController popToViewController:Obj animated:NO];
    
    

}

- (void)viewDidUnload
{
    [self setResultIdArray:nil];
    [self setTblResult:nil];
    [self setArrTestWords:nil];
    [self setLblColor:nil];
    [self setLblScore:nil];
    [self setBtnHome:nil];
    [self setScoreTexLbl:nil];
    [self setBtnTestAgain:nil];
    [super viewDidUnload];
}

@end
