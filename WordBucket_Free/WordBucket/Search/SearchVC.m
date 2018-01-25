//
//  SearchVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "SearchVC.h"
//#import "FacebookViewC.h"
#import "WikipediaHelper.h"
#import "Server.h"
#import "Defines.h"
#import "AddTranslationVC.h"
#import "DBHelper.h"
#import "BucketFullViewC.h"
#import "SynchronizationModel.h"
//#import "JSON.h"

@interface SearchVC ()

@end

@implementation SearchVC

bool bannerLoadded;

@synthesize tblMeaningList,arrMeaningList,strSearchWord;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

-(void) playAudio
{
    [[Common sharedInstance] showActivityIndicator:self];
    NSString *urlString = [NSString stringWithFormat:@"%@&text=%@",kSpeechUrl,strSearchWord];
    
    objServer=[Server alloc];
    objServer.delegate=self;
    [objServer callService:urlString];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrMeaningList = [[NSMutableArray alloc] init];
    self.searchWordLbl.text = strSearchWord;
     //[self playAudio];
    
    queue   = [[NSOperationQueue alloc] init];
    NSString *btnTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"ADD YOUR OWN MEANING", nil)];
    [self.addTranslation setTitle:btnTitle forState:UIControlStateNormal];
    [self.addTranslation.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_addTranslation setFrame:CGRectMake(13, 0, 295, 48)];
    [_addTranslation addTarget:self action:@selector(addTranslation:) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    [footerView addSubview:_addTranslation];
    self.tblMeaningList.tableFooterView = footerView;
    footerView=nil;
    
    
    //[self callWebService];
    [[Common sharedInstance] showActivityIndicator:self];
    [self performSelector:@selector(callWikiAPI) withObject:nil afterDelay:0.4];
    
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






- (void)callWikiAPI
{
    
    
    WikipediaHelper *wikiHelper = [[WikipediaHelper alloc] init];
    NSString *baseString = SharedAppDelegate.isNativeSrchLang ? [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode]:[[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode];
    NSString *wikiurlString = [NSString stringWithFormat:@"http://%@.wiktionary.org",baseString];
    NSString *properlywikiEscapedURL = [wikiurlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    wikiHelper.apiUrl = properlywikiEscapedURL;
    
    NSString *searchWordStr = strSearchWord;
    self.navigationItem.title = searchWordStr;
    //NSMutableArray *wikiMeaningArray = [wikiHelper getWikipediaTranslation:[[searchWordStr lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] search:SharedAppDelegate.isNativeSrchLang];
    NSMutableArray *wikiMeaningArray = [wikiHelper getWikipediaTranslation:[searchWordStr stringByReplacingOccurrencesOfString:@" " withString:@""] search:SharedAppDelegate.isNativeSrchLang];
    
    
    
    NSString *searchWord = SharedAppDelegate.isNativeSrchLang ? @"targetWord" : @"nativeWord";
    NSString *meaningWord = SharedAppDelegate.isNativeSrchLang ? @"nativeWord" : @"targetWord";
    NSMutableArray *arrAlreadyExist = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE LOWER(\"%@\") = LOWER(\"%@\") and action !=''",searchWord,strSearchWord] withField:@"COUNT(*)"];
    NSMutableArray *existingArray = [[NSMutableArray alloc] init];
    if([[arrAlreadyExist objectAtIndex:0] intValue]>0)
    {
        NSLog(@"ALREADY EXIST");
        //wordExists = YES;
        self.arrMeaningList = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE LOWER(%@) = LOWER('%@') and action !=''",searchWord,strSearchWord] withField:[NSString stringWithFormat:@"%@ , bucketColor,action,sense,POS",meaningWord]];
        NSMutableArray *meaningArray = [[NSMutableArray alloc] initWithArray:arrMeaningList];
        [self.arrMeaningList removeAllObjects];
        self.arrMeaningList = nil;
        self.arrMeaningList = [[NSMutableArray alloc] init];
        for (int k = 0; k < [meaningArray count]; k++) {
            
            NSArray *arr = [[meaningArray objectAtIndex:k] componentsSeparatedByString:@"/|"];
            NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithObjectsAndKeys:[arr objectAtIndex:0],@"term",[arr objectAtIndex:1],kBucketColor,[arr objectAtIndex:2],kAction,[arr objectAtIndex:3],ksense,[arr objectAtIndex:4],kPOS, nil];
            [self.arrMeaningList addObject:dicValue];
            [existingArray addObject:[arr objectAtIndex:0]];
        }
        meaningArray = nil;
        
    }
    
    
    
    for (int k = 0; k < [wikiMeaningArray count]; k++) {
        
        NSString *meaningStr = [[wikiMeaningArray objectAtIndex:k] objectForKey:@"*"];
        if(meaningStr && (![existingArray containsObject:meaningStr])){
            NSMutableDictionary *finalDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:meaningStr,@"term",@"",@"sense",@"",@"POS", nil];
            [self.arrMeaningList addObject:finalDic];
        }
        
    }
    NSLog(@"meaning list: %@",arrMeaningList);
    [[Common sharedInstance] stopActivityIndicator:self];
    [self.tblMeaningList reloadData];
    
}

/*
- (void)callWebService
{
    //http://api.wordreference.com/91151/json/enes/girl
    
    [[Common sharedInstance] showActivityIndicator:self];
    
    NSString *targetCode = SharedAppDelegate.isNativeSrchLang ? [UserDefaluts objectForKey:kNativeLangCode] : [UserDefaluts objectForKey:kTargetLangCode];
    NSString *nativeCode = SharedAppDelegate.isNativeSrchLang ? [UserDefaluts objectForKey:kTargetLangCode] : [UserDefaluts objectForKey:kNativeLangCode];
    NSString *urlString = [NSString stringWithFormat:@"http://api.wordreference.com/6e7d8/json/%@%@/%@",nativeCode,targetCode,strSearchWord];
    NSString *properlyEscapedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    objServer=[Server alloc];
    objServer.delegate=self;
    [objServer callService:properlyEscapedURL];
    
    
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Search Screen";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBanner:) name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerError:) name:@"bannerError" object:nil];
    [self addBannerView];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    //[[SharedAppDelegate sharedAd] removeFromSuperview];
    [[Common sharedInstance] synconCloud];
    [queue setSuspended:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bannerError" object:nil];
    
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
   
}

#pragma WebService Delegate
-(void)webserviceCallFinished:(NSMutableArray *)responseData
{
    [[Common sharedInstance] stopActivityIndicator:self];
    //NSLog(@"resonse data is %d %@",responseData.count,responseData);
    
    
    NSString *searchWord = SharedAppDelegate.isNativeSrchLang ? @"targetWord" : @"nativeWord";
    NSString *meaningWord = SharedAppDelegate.isNativeSrchLang ? @"nativeWord" : @"targetWord";
    NSMutableArray *arrAlreadyExist = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE LOWER(\"%@\") = LOWER(\"%@\") and action !=''",searchWord,strSearchWord] withField:@"COUNT(*)"];
    NSMutableArray *existingArray = [[NSMutableArray alloc] init];
    if([[arrAlreadyExist objectAtIndex:0] intValue]>0)
    {
        NSLog(@"ALREADY EXIST");
        //wordExists = YES;
        self.arrMeaningList = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE LOWER(%@) = LOWER('%@') and action !=''",searchWord,strSearchWord] withField:[NSString stringWithFormat:@"%@ , bucketColor,action,sense,POS",meaningWord]];
        NSMutableArray *meaningArray = [[NSMutableArray alloc] initWithArray:arrMeaningList];
        [self.arrMeaningList removeAllObjects];
        self.arrMeaningList = nil;
        self.arrMeaningList = [[NSMutableArray alloc] init];
        for (int k = 0; k < [meaningArray count]; k++) {
            
            NSArray *arr = [[meaningArray objectAtIndex:k] componentsSeparatedByString:@"/|"];
            NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithObjectsAndKeys:[arr objectAtIndex:0],@"term",[arr objectAtIndex:1],kBucketColor,[arr objectAtIndex:2],kAction,[arr objectAtIndex:3],ksense,[arr objectAtIndex:4],kPOS, nil];
            [self.arrMeaningList addObject:dicValue];
            [existingArray addObject:[arr objectAtIndex:0]];
        }
        meaningArray = nil;
        
    }

    
    if (responseData.count>0) {
        
        NSMutableDictionary *meaningArray = nil;
        if([[responseData objectAtIndex:0] objectForKey:@"term0"])
         meaningArray = [[responseData objectAtIndex:0] objectForKey:@"term0"];
        else if ([[responseData objectAtIndex:0] objectForKey:@"term1"])
            meaningArray = [[responseData objectAtIndex:0] objectForKey:@"term1"];
        //NSLog(@"meaning array is %@",meaningArray);
        NSMutableDictionary *prncplTrans = [meaningArray objectForKey:@"PrincipalTranslations"];
        NSMutableDictionary *addPrncplTrans = [meaningArray objectForKey:@"AdditionalTranslations"];
        NSLog(@"PrincipalTranslations array is %@",prncplTrans);
        NSLog(@"AdditionalTranslations array is %@",addPrncplTrans);
        for (int k = 0; k < [prncplTrans count]; k++) {
            
            NSString *key = [NSString stringWithFormat:@"%d",k];
            NSMutableDictionary *firstTdic = [prncplTrans objectForKey:key];
            NSMutableDictionary *finalDic = [firstTdic objectForKey:@"FirstTranslation"];
            NSMutableDictionary *originalTerm = [firstTdic objectForKey:@"OriginalTerm"];
            
            if(finalDic && (![existingArray containsObject:[finalDic objectForKey:@"term"]])){
                [finalDic setObject:[originalTerm objectForKey:@"sense"]?[originalTerm objectForKey:@"sense"]:@"" forKey:@"sense"];
            [self.arrMeaningList addObject:[firstTdic objectForKey:@"FirstTranslation"]];
            }
        }
        
        for (int k = 0; k < [addPrncplTrans count]; k++) {
            NSString *key = [NSString stringWithFormat:@"%d",k];
            NSMutableDictionary *firstTdic = [addPrncplTrans objectForKey:key];
            NSMutableDictionary *finalDic = [firstTdic objectForKey:@"FirstTranslation"];
            NSMutableDictionary *originalTerm = [firstTdic objectForKey:@"OriginalTerm"];
            
            if(finalDic && (![existingArray containsObject:[finalDic objectForKey:@"term"]])){
                [finalDic setObject:[originalTerm objectForKey:@"sense"]?[originalTerm objectForKey:@"sense"]:@"" forKey:@"sense"];
                [self.arrMeaningList addObject:[firstTdic objectForKey:@"FirstTranslation"]];
            }
            
        }
        [self.arrMeaningList removeDublicateObjects];
        [self.tblMeaningList reloadData];
        
        NSInteger searchedWord = [[UserDefaluts objectForKey:kTotalSearchWord] intValue]+1;
        [UserDefaluts setInteger:searchedWord forKey:kTotalSearchWord];
    }
    
    

    /*
    NSError *error = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:objServer.responseData error:&error];
    [audioPlayer prepareToPlay];
    audioPlayer.delegate = self;
    if (audioPlayer == nil)
        NSLog(@"error%@",[error localizedDescription]);
    else
        [audioPlayer play];
    
    //[NSString stringWithFormat:@"tbl_Dictionary WHERE LOWER(%@) = LOWER('%@') and action !=''",searchWord,strSearchWord]
    NSString *searchWord = SharedAppDelegate.isNativeSrchLang ? @"targetWord" : @"nativeWord";
    NSString *meaningWord = SharedAppDelegate.isNativeSrchLang ? @"nativeWord" : @"targetWord";
    NSMutableArray *arrAlreadyExist = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE LOWER(%@) = LOWER('%@')",searchWord,strSearchWord] withField:@"COUNT(*)"];
    NSString *existingWord = @"";
    NSMutableArray *existingArray = [[NSMutableArray alloc] init];
    if([[arrAlreadyExist objectAtIndex:0] intValue]>0)
    {
        NSLog(@"ALREADY EXIST");
        //wordExists = YES;
        arrMeaningList = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE LOWER(%@) = LOWER('%@')",searchWord,strSearchWord] withField:[NSString stringWithFormat:@"%@ , bucketColor,action",meaningWord]];
        NSMutableArray *meaningArray = [[NSMutableArray alloc] initWithArray:arrMeaningList];
        [arrMeaningList removeAllObjects];
        arrMeaningList = nil;
        arrMeaningList = [[NSMutableArray alloc] init];
        
        for (int k = 0; k < [meaningArray count]; k++) {
            
             NSArray *arr = [[meaningArray objectAtIndex:k] componentsSeparatedByString:@"/|"];
            NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithObjectsAndKeys:[arr objectAtIndex:0],@"*",[arr objectAtIndex:1],kBucketColor,[arr objectAtIndex:2],kAction, nil];
            [arrMeaningList addObject:dicValue];
            [existingArray addObject:[arr objectAtIndex:0]];
        }
        meaningArray = nil;
        existingWord = [Common getCombineStringFromArray:arrMeaningList withKey:@"*"];
        
        NSInteger searchedWord = [[UserDefaluts objectForKey:kTotalSearchWord] intValue]+1;
        [UserDefaluts setInteger:searchedWord forKey:kTotalSearchWord];
        
    }
        //[tblMeaningList reloadData];
        
        //[[Common sharedInstance] stopActivityIndicator:self];
        
   // } else {
        
        NSLog(@"FROM SERVER");
        backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
        
        dispatch_async(backgroundQueue, ^{
            
            
            WikipediaHelper *wikiHelper = [[WikipediaHelper alloc] init];
            wikiHelper.apiUrl = [NSString stringWithFormat:@"http://%@.wiktionary.org",SharedAppDelegate.isNativeSrchLang ? [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode]:[[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode]];
            
            NSString *searchWord = strSearchWord;
            self.navigationItem.title = searchWord;
            NSMutableArray *wikiMeaningArray = [wikiHelper getWikipediaTranslation:[[searchWord lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""]];
            for (int k = 0; k < [wikiMeaningArray count]; k++) {
                
                NSString *meaningStr = [[wikiMeaningArray objectAtIndex:k] objectForKey:@"*"];
                //if ([existingWord rangeOfString:meaningStr].location == NSNotFound) {
                if (![existingArray containsObject:meaningStr]) {
                    
                    NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[wikiMeaningArray objectAtIndex:k] objectForKey:@"*"],@"*", nil];
                    [arrMeaningList addObject:dicValue];
                }
                
                
            }
            NSLog(@"meaning list: %@",arrMeaningList);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if([arrMeaningList count] == 0)
                {
                    tblMeaningList.hidden = YES;
                    [_addTranslation setFrame:CGRectMake(13, 60, 295, 48)];
                    [self.view addSubview:_addTranslation];
                }
                else
                {
                    [tblMeaningList reloadData];
                    [[Common sharedInstance] stopActivityIndicator:self];
                }
                [[Common sharedInstance] stopActivityIndicator:self];
                
            });
        });
    //}*/

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
    return [arrMeaningList count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"CustomInventoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

UIImageView *itemImage = (UIImageView*)[cell.contentView viewWithTag:101];
itemImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"vendorImage3" ofType:@"png"]];
// Item Name
UILabel *itemNameL = (UILabel*)[cell.contentView viewWithTag:102];
itemNameL.text = [[inventoryArray objectAtIndex:indexPath.row] objectForKey:@"itemName"];

return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    //UILabel *searchWordLabel = (UILabel*)[cell.contentView viewWithTag:101];
    //searchWordLabel.text = [NSString stringWithFormat:@"%@,",self.strSearchWord];//self.strSearchWord;
    
    UILabel *meaingLabel = (UILabel*)[cell.contentView viewWithTag:102];
    meaingLabel.text = [[[arrMeaningList objectAtIndex:indexPath.row] valueForKey:@"term"] stringByTrimmingLeadingWhitespaceAndNewline];
    //meaingLabel.text = [[arrMeaningList objectAtIndex:indexPath.row] valueForKey:@"*"];
    
    
    //UITextField *meaingfield = (UITextField*)[cell.contentView viewWithTag:110];
    //[meaingfield setText:meaingLabel.text];
            
    UIButton *btnShare = (UIButton*)[cell.contentView viewWithTag:100];
    btnShare.tag = indexPath.row;
    [btnShare setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    [btnShare.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [btnShare.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btnShare setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 2)];
    [btnShare addTarget:self action:@selector(shareWord:event:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *play = (UIButton*)[cell.contentView viewWithTag:106];
//    play.tag = indexPath.row;
//    [play addTarget:self action:@selector(playButtonAcion:event:) forControlEvents:UIControlEventTouchUpInside];
    
    
        UIButton *btnBucket = (UIButton*)[cell.contentView viewWithTag:103];
        btnBucket.tag = indexPath.row;
    if(![[[arrMeaningList objectAtIndex:indexPath.row] valueForKey:kAction] isEqualToString:@""] && [[arrMeaningList objectAtIndex:indexPath.row] valueForKey:kAction])
    {
        NSString *bucketColor = [[arrMeaningList objectAtIndex:indexPath.row] valueForKey:kBucketColor];
        if([bucketColor isEqualToString:@"White"] || [bucketColor isEqualToString:@"Saved"])
            [btnBucket setImage:GetImage(@"bucketWhite2") forState:UIControlStateNormal];
        else if([bucketColor isEqualToString:@"Orange"])
            [btnBucket setImage:GetImage(@"bucketOrange2") forState:UIControlStateNormal];
        else if([bucketColor isEqualToString:@"Red"])
            [btnBucket setImage:GetImage(@"bucketRed2") forState:UIControlStateNormal];
        else
            [btnBucket setImage:GetImage(@"bucketGreen2") forState:UIControlStateNormal];
        
    } else {
        
        [btnBucket setImage:GetImage(@"addIcon") forState:UIControlStateNormal];
        [btnBucket addTarget:self action:@selector(addToBucket:event:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    UILabel *posLabel = (UILabel*)[cell.contentView viewWithTag:104];
    NSString *postString = [NSString stringWithFormat:@"%@",[[arrMeaningList objectAtIndex:indexPath.row] valueForKey:@"POS"]];
    posLabel.text = postString;
    
    UILabel *senseLabel = (UILabel*)[cell.contentView viewWithTag:105];
    NSString *sensetString = [NSString stringWithFormat:@"%@",[[arrMeaningList objectAtIndex:indexPath.row] valueForKey:@"sense"]];
    senseLabel.text = sensetString;
    
    return cell;
}

- (void)addTranslation:(id)sender
{
    NSInteger savedWord = [[UserDefaluts objectForKey:kTotalSavedWord] intValue];
    NSLog(@"words saved is %d",savedWord);
    
    if (savedWord < 25) {
        
        NSString *nib = SharedAppDelegate.isPhone5 ? @"AddTranslationVC" : @"AddTranslationVCiPhone4";
        AddTranslationVC *addTranslation = [[AddTranslationVC alloc] initWithNibName:nib bundle:nil];
        addTranslation.strSearchedWord = strSearchWord;
        [self.navigationController pushViewController:addTranslation animated:YES];
        
    } else {
        
        NSString *nib = SharedAppDelegate.isPhone5 ? @"BucketFullViewC" : @"BucketFullViewCiPhone4";
        BucketFullViewC *upgradeObj = [[BucketFullViewC alloc] initWithNibName:nib bundle:nil];
        [self.navigationController pushViewController:upgradeObj animated:YES];
        
    }
}

-(void) addToBucket:(id)sender event:(id)event
{
    
    NSInteger savedWord = [[UserDefaluts objectForKey:kTotalSavedWord] intValue];
    NSLog(@"words saved is %d",savedWord);
    
    if (savedWord < 25) {
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tblMeaningList];
    NSIndexPath *indexPath = [self.tblMeaningList indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"index path in button tapped is %d %d",indexPath.section,indexPath.row);
    UITableViewCell *cell = [self.tblMeaningList cellForRowAtIndexPath:indexPath];
    
    UILabel *lblMeaning = (UILabel*)[cell.contentView viewWithTag:102];
    NSString *targetLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode];
    NSString *nativeLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode];
    
    NSString *nativeWordStr = SharedAppDelegate.isNativeSrchLang ? lblMeaning.text : self.strSearchWord;
    NSString *targetWordStr = SharedAppDelegate.isNativeSrchLang ? self.strSearchWord : lblMeaning.text;
   NSMutableDictionary *dic = [arrMeaningList objectAtIndex:indexPath.row];
    
    NSString *alreadySaved = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"select COUNT(*) from tbl_Dictionary where targetWord = \"%@\" AND nativeword = \"%@\"",targetWordStr,nativeWordStr]];
    if ([alreadySaved integerValue]>0) {
        
        [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET action = 'Saved' WHERE targetWord = \"%@\" AND nativeword = \"%@\"",targetWordStr,nativeWordStr]];
        
    } else {
        
        [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest,sense,POS" fieldValue:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"",targetWordStr,nativeWordStr,@"White",nativeLanCode,targetLanCode,@"Saved",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLevel"],[NSDate date],[dic objectForKey:@"sense"],[dic objectForKey:@"POS"]]];
    }
        [[SynchronizationModel currentObject] prepareJsonWithNewWord:
         [NSDictionary dictionaryWithObjectsAndKeys:nativeWordStr,kNativeWord,
                                                    targetWordStr,kTargetWord,
                                                    @"White",
                                                    @"BucketColor",
                                                    nil]];
        
    /*
    if ([[dic objectForKey:kAction] isEqualToString:@""]) {
        
        [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET action = 'Saved' WHERE targetWord = '%@' AND nativeword = '%@'",targetWordStr,nativeWordStr]];
    } else {
        [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest" fieldValue:[NSString stringWithFormat:@"'%@','%@','%@','%@','%@','%@','%@','%@'",targetWordStr,nativeWordStr,@"White",nativeLanCode,targetLanCode,@"Saved",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLevel"],[NSDate date]]];
    }*/
    
    [dic setObject:@"White" forKey:kBucketColor];
    [dic setObject:@"Saved" forKey:kAction];
    [self.tblMeaningList reloadData];
    
    
    [UserDefaluts setInteger:(savedWord+1) forKey:kTotalSavedWord];
    [UserDefaluts synchronize];
    
    
    for(int i=0;i<[arrMeaningList count];i++)
    {
        
        if (![[arrMeaningList objectAtIndex:i] objectForKey:kAction]) {
            
            NSString *nativeWordValue = SharedAppDelegate.isNativeSrchLang ? [[arrMeaningList objectAtIndex:i] valueForKey:@"term"] : strSearchWord;
            NSString *targetWordValue = SharedAppDelegate.isNativeSrchLang ? strSearchWord : [[arrMeaningList objectAtIndex:i] valueForKey:@"term"];
            
            NSString *alreadySaved = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"select COUNT(*) from tbl_Dictionary where targetWord = \"%@\" AND nativeword = \"%@\"",targetWordValue,nativeWordValue]];
            
            if ([alreadySaved integerValue]==0) {
            
            [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest,sense,POS" fieldValue:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"",targetWordValue,nativeWordValue,@"White",nativeLanCode,targetLanCode,@"",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLevel"],[NSDate date],[[arrMeaningList objectAtIndex:i] valueForKey:@"sense"],[[arrMeaningList objectAtIndex:i] valueForKey:@"POS"]]];
            }
        }
    }
    
    /*
    if(wordExists)
    {
        [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET action = 'Saved' WHERE targetWord = '%@' AND nativeword = '%@'",targetWordStr,nativeWordStr]];
    }
    else
    {
        [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest" fieldValue:[NSString stringWithFormat:@"'%@','%@','%@','%@','%@','%@','%@','%@'",targetWordStr,nativeWordStr,@"White",nativeLanCode,targetLanCode,@"Saved",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLevel"],[NSDate date]]];
        
        for(int i=0;i<[arrMeaningList count];i++)
        {
            if(i != [sender tag])
            {
                NSString *nativeWordValue = SharedAppDelegate.isNativeSrchLang ? [[arrMeaningList objectAtIndex:i] valueForKey:@"*"] : strSearchWord;
                NSString *targetWordValue = SharedAppDelegate.isNativeSrchLang ? strSearchWord : [[arrMeaningList objectAtIndex:i] valueForKey:@"*"];
                [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest" fieldValue:[NSString stringWithFormat:@"'%@','%@','%@','%@','%@','%@','%@','%@'",targetWordValue,nativeWordValue,@"White",nativeLanCode,targetLanCode,@"",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLevel"],[NSDate date]]];
            }
        }
    }*/
    
    
    //show alert after adding new word to bucket
    if(![lblMeaning.text isEqualToString:@"Not found"])
    {
        wordExists = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:NSLocalizedString(@"%@ added to your Word Bucket", nil),lblMeaning.text] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
        if (!SharedAppDelegate.isNativeSrchLang) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                //[self saveOtherMeaningOfTargetWord:lblMeaning.text];
                [self saveOtherMeaningWithWikiAPI:lblMeaning.text];
                //dispatch_async(dispatch_get_main_queue(), ^{
                // perform action in main thread
                //});
            });
            
            
        }
        
        
    }
        
    } else {
        
        NSString *nib = SharedAppDelegate.isPhone5 ? @"BucketFullViewC" : @"BucketFullViewCiPhone4";
        BucketFullViewC *upgradeObj = [[BucketFullViewC alloc] initWithNibName:nib bundle:nil];
        [self.navigationController pushViewController:upgradeObj animated:YES];
    }
    

}

- (void)saveOtherMeaningWithWikiAPI:(NSString*)targetWord
{
    WikipediaHelper *wikiHelper = [[WikipediaHelper alloc] init];
    
    
    NSString *wikiurlString = [NSString stringWithFormat:@"http://%@.wiktionary.org",[[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode]];
    NSString *properlywikiEscapedURL = [wikiurlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    wikiHelper.apiUrl = properlywikiEscapedURL;
    
    NSString *searchWordStr = targetWord;
    NSMutableArray *wikiMeaningArray = [wikiHelper getWikipediaTranslation:[[searchWordStr lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] search:(!SharedAppDelegate.isNativeSrchLang)];
    NSLog(@"wiki array is %@",wikiMeaningArray);
    
    NSString *targetLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode];
    NSString *nativeLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode];
    for (int k = 0; k < [wikiMeaningArray count]; k++) {
        
        NSString *alreadySaved = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"select COUNT(*) from tbl_Dictionary where targetWord = \"%@\" AND nativeword = \"%@\"",targetWord,[[wikiMeaningArray objectAtIndex:k] objectForKey:@"*"]]];
        if ([alreadySaved integerValue]==0) {
            
            [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest,sense,POS" fieldValue:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"",targetWord,[[wikiMeaningArray objectAtIndex:k] objectForKey:@"*"],@"White",nativeLanCode,targetLanCode,@"",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLevel"],[NSDate date],@"",@""]];
        }
    }
    
}

/*
- (void)saveOtherMeaningOfTargetWord:(NSString *)targetWord
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.wordreference.com/6e7d8/json/%@%@/%@",[UserDefaluts objectForKey:kTargetLangCode],[UserDefaluts objectForKey:kNativeLangCode],targetWord];
    NSString *properlyEscapedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue // created at class init
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               // do something with data or handle error
                               //NSLog(@"resopne and data is %@  \n %@ %@",response,data,error);
                               if(!error){
                                   
                                   NSString *stringData = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                   NSDictionary *jsonArray = [stringData JSONFragmentValue];
                                   if (jsonArray.count>0) {
                                       
                                       NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
                                       NSMutableDictionary *meaningArray = nil;
                                       if([jsonArray objectForKey:@"term0"])
                                           meaningArray = [jsonArray objectForKey:@"term0"];
                                       else if ([jsonArray objectForKey:@"term1"])
                                           meaningArray = [jsonArray objectForKey:@"term1"];
                                       //NSLog(@"meaning array is %@",meaningArray);
                                       NSMutableDictionary *prncplTrans = [meaningArray objectForKey:@"PrincipalTranslations"];
                                       NSMutableDictionary *addPrncplTrans = [meaningArray objectForKey:@"AdditionalTranslations"];
                                       NSLog(@"PrincipalTranslations array is %@",prncplTrans);
                                       NSLog(@"AdditionalTranslations array is %@",addPrncplTrans);
                                       for (int k = 0; k < [prncplTrans count]; k++) {
                                           
                                           NSString *key = [NSString stringWithFormat:@"%d",k];
                                           NSMutableDictionary *firstTdic = [prncplTrans objectForKey:key];
                                           NSMutableDictionary *finalDic = [firstTdic objectForKey:@"FirstTranslation"];
                                           NSMutableDictionary *originalTerm = [firstTdic objectForKey:@"OriginalTerm"];
                                           
                                           if(finalDic){
                                               [finalDic setObject:[originalTerm objectForKey:@"sense"]?[originalTerm objectForKey:@"sense"]:@"" forKey:@"sense"];
                                               [parsedArray addObject:[firstTdic objectForKey:@"FirstTranslation"]];
                                           }
                                           
                                       }
                                       
                                       for (int k = 0; k < [addPrncplTrans count]; k++) {
                                           NSString *key = [NSString stringWithFormat:@"%d",k];
                                           NSMutableDictionary *firstTdic = [addPrncplTrans objectForKey:key];
                                           NSMutableDictionary *finalDic = [firstTdic objectForKey:@"FirstTranslation"];
                                           NSMutableDictionary *originalTerm = [firstTdic objectForKey:@"OriginalTerm"];
                                           
                                           if(finalDic){
                                               [finalDic setObject:[originalTerm objectForKey:@"sense"]?[originalTerm objectForKey:@"sense"]:@"" forKey:@"sense"];
                                               [parsedArray addObject:[firstTdic objectForKey:@"FirstTranslation"]];
                                           }
                                           
                                       }
                                       
                                       NSLog(@"final Meaning array is %@",parsedArray);
                                       
                                       NSString *targetLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode];
                                       NSString *nativeLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode];
                                       for (int k = 0; k < [parsedArray count]; k++) {
                                           
                                           NSString *alreadySaved = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"select COUNT(*) from tbl_Dictionary where targetWord = \"%@\" AND nativeword = \"%@\"",targetWord,[[parsedArray objectAtIndex:k] objectForKey:@"term"]]];
                                           if ([alreadySaved integerValue]==0) {
                                               
                                               [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest,sense,POS" fieldValue:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"",targetWord,[[parsedArray objectAtIndex:k] objectForKey:@"term"],@"White",nativeLanCode,targetLanCode,@"",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLevel"],[NSDate date],[[parsedArray objectAtIndex:k] valueForKey:@"sense"],[[parsedArray objectAtIndex:k] valueForKey:@"POS"]]];
                                           }
                                       }
                                       
                                   }
                               }
                           }];
}
 
*/

-(void) shareWord:(id)sender event:(id)event
{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tblMeaningList];
    NSIndexPath *indexPath = [self.tblMeaningList indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"index path in button tapped is %d %d",indexPath.section,indexPath.row);
    UITableViewCell *cell = [self.tblMeaningList cellForRowAtIndexPath:indexPath];
    UILabel *lblMeaning = (UILabel*)[cell.contentView viewWithTag:102];
    _shareWord = SharedAppDelegate.isNativeSrchLang ? self.strSearchWord : lblMeaning.text;
    NSLog(@"search word is %@",_shareWord);
    //[[Common sharedInstance] popUpActionSheet:self.view buttonTitle:[NSArray arrayWithObjects:@"Share on Facebook",@"Share on Twitter",@"Email",@"Cancel", nil] desctructiveButtonIndex:-1];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share on Facebook", nil),NSLocalizedString(@"Share on Twitter", nil),NSLocalizedString(@"Email", nil),NSLocalizedString(@"Cancel", nil), nil];
    [actionSheet setTag:10];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [Common sharedInstance].delegate = self;
   
}


/*
-(void) playButtonAcion:(id)sender event:(id)event
{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tblMeaningList];
    NSIndexPath *indexPath = [self.tblMeaningList indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"index path in button tapped is %d %d",indexPath.section,indexPath.row);
    UITableViewCell *cell = [self.tblMeaningList cellForRowAtIndexPath:indexPath];
    UILabel *lblMeaning = (UILabel*)[cell.contentView viewWithTag:102];
    
    
    //kSpeechUrl
    //NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSString *speechString = [NSString stringWithFormat:@"http://api.ispeech.org/api/rest?apikey=developerdemokeydeveloperdemokey&action=convert&voice=%@&format=mp3 &frequency=44100&bitrate=128&speed=1&startpadding=1&endpadding=1&pitch=110&filename=audiofile&text=%@",[Common audioLanguagesWithCode:lblMeaning.text],strSearchWord];
    //NSString *urlString1 = [NSString stringWithFormat:@"%@&text=%@",kSpeechUrl,strSearchWord];
    NSString *properlyEscapedURL = [speechString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue // created at class init
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               // do something with data or handle error
                               NSLog(@"resopne and data is ");
                               if(!error){
                                   NSError *error1 = nil;
                                   audioPlayer=nil;
                                   audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error1];
                                   [audioPlayer prepareToPlay];
                                   audioPlayer.delegate = self;
                                   if (audioPlayer == nil)
                                       NSLog(@"error%@",[error localizedDescription]);
                                   else
                                       [audioPlayer play];
                               }
                           }];
    
}

*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma ActionSheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        // Facebook
        NSMutableString *message =[NSString stringWithFormat:NSLocalizedString(@"Do you know this %@ word? \"%@\" I just found it in Word Bucket. FREE to download for iOS and Android.", nil),_shareWord];
        [[Common sharedInstance] postStatusUpdateClick:self message:message withUrl:[NSURL URLWithString:@"http://www.wordbucket.com"]];
        
    }
    else if(buttonIndex == 1)
    {
        // Twitter
        NSString *message =[NSString stringWithFormat:NSLocalizedString(@"Just found the word \"%@\" in @Wordbucket. Great app to find and learn new words.", nil),_shareWord];
        [[Common sharedInstance] sendEasyTweet:self text:message withUrl:[NSURL URLWithString:@"http://wordbucket.com"]];
    }
    else if(buttonIndex == 2)
    {
        // Email
        //NSString *firstpartStr = [NSString stringWithFormat:NSLocalizedString(@"Do you know this %@ word? \"%@\" I just found it in", nil),[Common getTargetLanguage],_shareWord];
        //NSString *secondpartStr = [NSString stringWithFormat:NSLocalizedString(@"Great app to find and learn new words & FREE to download for iOS and Android.", nil)];
        //NSMutableString *message =[NSMutableString stringWithFormat:@"<html><body>%@ <a href=\"http://www.wordbucket.com\">Word Bucket</a>. %@</body></html>",firstpartStr,secondpartStr];
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Email Do you know this %@ word? \"%@\" I just found it in Word Bucket. FREE to download for iOS and Android.", nil),_shareWord];
        [[Common sharedInstance] showMailPicker:self subject:NSLocalizedString(@"Word Bucket - find and learn new words", nil) emailBody:message];
    }
}
#pragma mark alertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   if(buttonIndex==1){
       // tblMeaningList.hidden = YES;
        self.strSearchWord = @"";
        //[self.navigationController popViewControllerAnimated:YES];
        //[searchBar becomeFirstResponder];
    }
}



- (void)viewDidUnload {
    
    queue = nil;
    audioPlayer = nil;
    [self setSearchWordLbl:nil];
    [self setShareWord:nil];
    [self setStrSearchWord:nil];
    [self setArrMeaningList:nil];
    [self setTblMeaningList:nil];
    [super viewDidUnload];
}

@end
