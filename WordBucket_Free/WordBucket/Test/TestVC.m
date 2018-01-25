//
//  TestVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "TestVC.h"
#import "ResultsVC.h"
#import "WhiteTestViewController.h"
#import "Common.h"
#import "OrangeTestViewController.h"
#import "WordListVC.h"
#import "SearchVC.h"
#import "PreGreenTestVC.h"
#import "AllTestViewC.h"
#import "InfoViewC.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "DBHelper.h"
@interface TestVC ()

@end



@implementation TestVC

bool bannerLoadded;

@synthesize btnWhite,btnOrange,btnGreen,btnRed;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = NSLocalizedString(@"Test", @"Test");
        //self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    SharedAppDelegate.totolQustCount = [UserDefaluts objectForKey:kTotalWords] ? [[UserDefaluts objectForKey:kTotalWords] integerValue] : 10;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordListBucketViewMakeHidden:) name:kWordListViewNotification object:nil];
    [self.navigationController setNavigationBarHidden:YES];
    [btnWhite setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"White"]] forState:UIControlStateNormal];
    [btnOrange setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Orange"]] forState:UIControlStateNormal];
    [btnGreen setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Green"]] forState:UIControlStateNormal];
    [btnRed setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Red"]] forState:UIControlStateNormal];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self updateAllValuesOnWordListView];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBanner:) name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerError:) name:@"bannerError" object:nil];
    [self addBannerView];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[SharedAppDelegate sharedAd] removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bannerError" object:nil];
}



- (void)setLocalizesString
{
    [self.txtSearch setPlaceholder:NSLocalizedString(@"Search Word", nil)];
    [_thenewLaebl setText:NSLocalizedString(@"New", nil)];
    [_learnedLabel setText:NSLocalizedString(@"Learned", nil)];
    [_learningLabel setText:NSLocalizedString(@"Learning", nil)];
    [_mistakesLabel setText:NSLocalizedString(@"Mistakes", nil)];
    NSString *allbckStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"ALL BUCKETS", nil)];
    [self.btnAllBucket setTitle:allbckStr forState:UIControlStateNormal];
    [_chooseyrTestLabel setText:NSLocalizedString(@"Choose Your Test", nil)];
    [self.btnAllBucket.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_barbuttonDone setTitle:NSLocalizedString(@"Done", nil)];
    
    [_whitePlayLbl setText:_thenewLaebl.text];
    [_greenPlayLbl setText:_learnedLabel.text];
    [_orangePlayLbl setText:_learningLabel.text];
    [_redPlayLbl setText:_mistakesLabel.text];
    
}


- (void)viewDidLoad
{
    NSLog(@"view frame is %f",self.view.frame.size.height);
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self setLocalizesString];
        
    // Do any additional setup after loading the view from its nib.
    //[self.view addSubview:_wordListView];
    
   
    
    _tabBarImageView = [[UIImageView alloc] initWithImage:GetImage(@"learn")];
    NSDictionary *dicValue = [NSDictionary dictionaryWithObject:@"NO" forKey:kNote];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordListBucketViewMakeHidden:) name:kWordListViewNotification object:nil];
    NSNotification *nofication = [NSNotification notificationWithName:kWordListViewNotification object:nil userInfo:dicValue];
    [self wordListBucketViewMakeHidden:nofication];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:kRetakeTestNotification object:nil];
    
    _profilePic.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _profilePic.transform = CGAffineTransformMakeRotation(degreesToRadians(-15));
    _profilepicBgImgVew.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _profilepicBgImgVew.transform = CGAffineTransformMakeRotation(degreesToRadians(-15));
    
    
    
    [self setConditionOverLanguagesSearch];
    [self checkInfoButtonVisibilty];
    
    
    // Sync iCloud when app launch
    // Configure iCloud
    [[Common sharedInstance] setUpiCloud];
    [[Common sharedInstance] synconCloud];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Home Screen";
}


// Only English to X search except some cases
- (void)setConditionOverLanguagesSearch
{
    
    NSString *nativeLngCode = [UserDefaluts objectForKey:kNativeLangCode];
    NSString *targetLngCode = [UserDefaluts objectForKey:kTargetLangCode];
    [_nativeLangLabel setText:[nativeLngCode uppercaseString]];
    [_targetLangLabel setText:[targetLngCode uppercaseString]];
    
    if ([self setVisibiltyOfSearchBtn]) {
        SharedAppDelegate.isNativeSrchLang = NO; // If YES then result comes in native languages
        [self.btnLanguage setEnabled:YES];
        [_nativeLangLabel setTextColor:[UIColor blueColor]];
        [_targetLangLabel setTextColor:[UIColor whiteColor]];
        [self.btnLanguage setEnabled:YES];
        
    } else {
        
        [self.btnLanguage setEnabled:NO];
        if ([nativeLngCode isEqualToString:@"en"]) {
            [_nativeLangLabel setTextColor:[UIColor blueColor]];
            [_targetLangLabel setTextColor:[UIColor whiteColor]];
            SharedAppDelegate.isNativeSrchLang = NO;
            
        } else {
            
            [_nativeLangLabel setTextColor:[UIColor whiteColor]];
            [_targetLangLabel setTextColor:[UIColor blueColor]];
            SharedAppDelegate.isNativeSrchLang = YES;
        }
        
    }
    
    
    
}

- (BOOL)setVisibiltyOfSearchBtn
{
    NSString *nativeLngCode = [UserDefaluts objectForKey:kNativeLangCode];
    NSString *targetLngCode = [UserDefaluts objectForKey:kTargetLangCode];
    
    if ([nativeLngCode isEqualToString:@"es"] || [nativeLngCode isEqualToString:@"fr"] || [nativeLngCode isEqualToString:@"de"])
    {
        
        return YES;
        
    } else if ([targetLngCode isEqualToString:@"es"] || [targetLngCode isEqualToString:@"fr"] || [targetLngCode isEqualToString:@"de"])
    {
        return YES;
        
    } else
    {
        return NO;
    }    
    
}


- (void)addBannerView
{
    [SharedAdBannerView removeFromSuperview];
    [self.view addSubview:SharedAdBannerView];
    [self.view bringSubviewToFront:SharedAdBannerView];
    
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


/*
#pragma mark ADBannerViewDelegame method
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.isBannerVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectMake(0 self.view.frame.size.height-50, 320, 50);
        [UIView commitAnimations];
        self.isBannerVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.isBannerVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectMake(0, self.view.frame.size.height-50, 320, 50);
        [UIView commitAnimations];
        self.isBannerVisible = NO;
    }
}
*/

// Make Info button visible
- (void)checkInfoButtonVisibilty
{
    NSInteger lauchCount = [[UserDefaluts objectForKey:kLaunchCount] intValue]+1;
    [UserDefaluts setInteger:lauchCount forKey:kLaunchCount];
    
    NSDate *previousLaunchDate = [UserDefaluts objectForKey:kLanchDate];
    
    if (lauchCount < 4)
        [_infoButton setHidden:NO];
    
    [UserDefaluts setObject:[NSDate date] forKey:kLanchDate];
    
    if (previousLaunchDate && _infoButton.hidden) {
        
        if([Common differencefromtodayDay:previousLaunchDate] >= 15)
            [_infoButton setHidden:NO];
        
    }
    
}



- (IBAction)homeButtonClicked:(id)sender {
    
    NSDictionary *dicValue = [NSDictionary dictionaryWithObject:@"NO" forKey:kNote];
    NSNotification *nofication = [NSNotification notificationWithName:kWordListViewNotification object:nil userInfo:dicValue];
    [self wordListBucketViewMakeHidden:nofication];

}

- (void)receiveTestNotification:(NSNotification *)notification{

    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"userInfo %@",userInfo);
    
    if ([[userInfo objectForKey:kBucketColor] isEqualToString:@"White"]) {
        
        [self whiteTest:(id)btnWhite];
        
    } else if ([[userInfo objectForKey:kBucketColor] isEqualToString:@"Orange"]) {
        
        [self orangeTest:(id)btnOrange];
        
    } else if ([[userInfo objectForKey:kBucketColor] isEqualToString:@"Green"]) {
        
        [self greenTest:(id)btnGreen];
        
    } else if ([[userInfo objectForKey:kBucketColor] isEqualToString:@"Red"]) {
        
        [self redTest:(id)btnRed];
        
    } else
        [self allBucketTest:(id)_btnAllBucket];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//white test

- (void)showAlert
{
     NSString *msgString = [NSString stringWithFormat:NSLocalizedString(@"You need at least %d words in your Word Bucket to test. Search and save new words!", nil),SharedAppDelegate.totolQustCount];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msgString delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    [alert show];
}

-(IBAction)whiteTest:(id)sender
{

    NSLog(@"Here I am");

    if([btnWhite.titleLabel.text intValue] >= SharedAppDelegate.totolQustCount)
    {
    
        NSString *nib = SharedAppDelegate.isPhone5 ? @"WhiteTestViewController" : @"WhiteTestViewControlleriPhone4";
        WhiteTestViewController *whiteTest = [[WhiteTestViewController alloc] initWithNibName:nib bundle:nil];
        whiteTest.strTestColor = @"WhiteTest";
        [self.navigationController pushViewController:whiteTest animated:YES];
        
    }
    else
    {
        //[self showAlert];
        NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"Sorry! You need at least %d words in your White Bucket to do a test. Search and save more new words!", nil),SharedAppDelegate.totolQustCount];
        [Common showAlertView:nil message:messageString delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    }

}

-(IBAction)redTest:(id)sender
{
        if([btnRed.titleLabel.text intValue] >= SharedAppDelegate.totolQustCount)
        {
            NSString *nib = SharedAppDelegate.isPhone5 ? @"WhiteTestViewController" : @"WhiteTestViewControlleriPhone4";
            WhiteTestViewController *whiteTest = [[WhiteTestViewController alloc] initWithNibName:nib bundle:nil];
            whiteTest.strTestColor = @"RedTest";
            [self.navigationController pushViewController:whiteTest animated:YES];
        }
        else
        {
            NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"Good work! You don't have enough words (%d) in your Red Bucket to do a test. Only words that you get wrong in the other colours go here.", nil),SharedAppDelegate.totolQustCount];
            [Common showAlertView:nil message:messageString delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        }
    
}
-(IBAction) orangeTest:(id)sender
{
    if([btnOrange.titleLabel.text intValue]>= SharedAppDelegate.totolQustCount)
    {
        
        NSInteger lauchCount = [[UserDefaluts objectForKey:kFirstLaunchOrangeTest] intValue]+1;
        [UserDefaluts setInteger:lauchCount forKey:kFirstLaunchOrangeTest];
        
        if (lauchCount==1 && (![self isTargetLanguageKeyboardInstalled])) {
            
            NSString *msgString = [NSString stringWithFormat:NSLocalizedString(@"To practise your Orange words you need to activate your %@ keyboard. Don't worry, it's easy to do in settings and you only have to do it once.\n Just go to General and find Keyboard, then Keyboards and finally Add New Keyboard.", nil),[Common getTargetLanguage]];
            
            [Common showAlertViewWithTag:100 title:NSLocalizedString(@"Woah there!", nil) message:msgString delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            
        } else {
            NSString *nib = SharedAppDelegate.isPhone5 ? @"OrangeTestViewController": @"OrangeTestViewControlleriPhone4";
            OrangeTestViewController *orangeTest = [[OrangeTestViewController alloc] initWithNibName:nib bundle:[NSBundle mainBundle]];
           [self.navigationController pushViewController:orangeTest animated:YES];
        }
    }
    else
    {
        NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"Sorry! You need at least %d Orange Words to do a test. Do more White Bucket tests!", nil),SharedAppDelegate.totolQustCount];
        [Common showAlertView:nil message:messageString delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    }
    
}

- (BOOL)isTargetLanguageKeyboardInstalled
{
    
    BOOL isInstalled = NO;
    NSString *targetLangCode = [UserDefaluts objectForKey:kTargetLangCode];
    NSLog(@"%@",[[UserDefaluts dictionaryRepresentation] objectForKey:@"AppleKeyboards"]);
    NSArray *installedKeyboard = [[UserDefaluts dictionaryRepresentation] objectForKey:@"AppleKeyboards"];
    for (int k = 0; k < [installedKeyboard count] ; k++) {
        
        NSString *keyLang = [[installedKeyboard objectAtIndex:k] substringToIndex:2];
        if ([[keyLang lowercaseString] isEqualToString:[targetLangCode lowercaseString]]) {
            isInstalled = YES;
            break;
        }
        
    }
    
    return isInstalled;
}

-(IBAction) allBucketTest:(id)sender
{
    if([[Common sharedInstance] getAllWordExceptGreen] >= SharedAppDelegate.totolQustCount)
    {
        NSInteger lauchCount = [[UserDefaluts objectForKey:kFirstLaunchAllTest] intValue]+1;
        [UserDefaluts setInteger:lauchCount forKey:kFirstLaunchAllTest];
        
        
        if (lauchCount==1 && (![self isTargetLanguageKeyboardInstalled])) {
            
            NSString *msgString = [NSString stringWithFormat:NSLocalizedString(@"To practise your Orange words you need to activate your %@ keyboard. Don't worry, it's easy to do in settings and you only have to do it once.\n Just go to General and find Keyboard, then Keyboards and finally Add New Keyboard.", nil),[Common getTargetLanguage]];
            
            [Common showAlertViewWithTag:100 title:NSLocalizedString(@"Woah there!", nil) message:msgString delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            
        } else {
            NSString *nib = SharedAppDelegate.isPhone5 ? @"AllTestViewC" : @"AllTestViewCiPhone4";
            AllTestViewC *allTestObj = [[AllTestViewC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:allTestObj animated:YES];
        }
    }
    else
    {
        
        [self showAlert];
    }
    
}


-(IBAction) greenTest:(id)sender
{
    
    NSString *nib = SharedAppDelegate.isPhone5 ? @"PreGreenTestVC" : @"PreGreenTestVCiPhone4";
    PreGreenTestVC *preGTest = [[PreGreenTestVC alloc] initWithNibName:nib bundle:nil];
    [self.navigationController pushViewController:preGTest animated:YES];
    
    /*
    if ([[Common sharedInstance] getWordCount:@"Green"] >= 12) {
    NSString *nib = SharedAppDelegate.isPhone5 ? @"GreenTestVCViewController" : @"GreenTestVCViewControlleriPhone4";
    GreenTestVCViewController *allBucketTest = [[GreenTestVCViewController alloc] initWithNibName:nib bundle:nil];
    [self.navigationController pushViewController:allBucketTest animated:YES];
    } else {
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"" message:@"Sorry! To play the Green game you need at least 12 words in your Green Bucket. Move words here by testing your Orange words" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }*/
}


- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWordListViewNotification object:nil];
    
    [self setBtnWhite:nil];
    [self setBtnWhiteWordList:nil];
    [self setBtnRedWordList:nil];
    [self setBtnOrgangeWordList:nil];
    [self setBtnGreenWordList:nil];
    [self setUserName:nil];
    [self setProfilePic:nil];
    [self setTxtSearch:nil];
    [self setBtnSearch:nil];
    [self setWordListView:nil];
    [self setBtnAllBucket:nil];
    [self setBthHome:nil];
    [self setBtnLanguage:nil];
    [self setInfoButton:nil];
    [self setProfilepicBgImgVew:nil];
    [self setImgView:nil];
    [self setNativeLangLabel:nil];
    [self setTargetLangLabel:nil];
    [self setToolBar:nil];
    [self setChooseyrTestLabel:nil];
    [self setBarbuttonDone:nil];
    [self setThenewLaebl:nil];
    [self setLearnedLabel:nil];
    [self setMistakesLabel:nil];
    [self setLearningLabel:nil];
    [self setWhitePlayLbl:nil];
    [self setOrangePlayLbl:nil];
    [self setGreenPlayLbl:nil];
    [self setRedPlayLbl:nil];
    [super viewDidUnload];
}



- (void)wordListBucketViewMakeHidden:(NSNotification*)notification
{
    
    if ([[notification.userInfo objectForKey:kNote] isEqualToString:@"YES"])
        [_wordListView setHidden:YES];
    
    else {
        
        //UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"learn.png"]];
        NSLog(@"%@",_tabBarImageView);
        [_wordListView setHidden:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self updateAllValuesOnWordListView];
        
        for(UIView *view in self.tabBarController.tabBar.subviews) {
            if([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        [self.tabBarController.tabBar insertSubview:_tabBarImageView atIndex:0];
        [[self.tabBarController.tabBar.items objectAtIndex:1] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0], UITextAttributeTextColor,[UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], UITextAttributeFont,nil]
                                                                            forState:UIControlStateSelected];
    }
    
}


- (void)updateAllValuesOnWordListView
{
    UIImage *imgProfile = [[Common sharedInstance] getImageWithName:@"avatar.png"];
    if(imgProfile){
        _profilePic.image = imgProfile;
        [_imgView setHidden:NO];
        [_userName setFrame:CGRectMake(117, SharedAppDelegate.isPhone5 ? 74 : 52, 199, 66)];
        [_userName setTextAlignment:NSTextAlignmentLeft];
    } else {
        
        [_imgView setHidden:YES];
        [_userName setFrame:CGRectMake(15, SharedAppDelegate.isPhone5 ? 74 : 52, 295, 66)];
        [_userName setTextAlignment:NSTextAlignmentCenter];
    }

    
    _txtSearch.text = @"";
    [self.navigationController.navigationBar setHidden:YES];
    [_btnWhiteWordList setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"White"]] forState:UIControlStateNormal];
    [_btnGreenWordList setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Green"]] forState:UIControlStateNormal];
    [_btnOrgangeWordList setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Orange"]] forState:UIControlStateNormal];
    [_btnRedWordList setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Red"]] forState:UIControlStateNormal];
    
    
    
    NSString *userNameString = [UserDefaluts objectForKey:@"UserName"];
    
    NSLog(@"userName is %@ %@ ",userNameString,UserDefaluts);
    if([UserDefaluts objectForKey:@"UserName"] && userNameString.length>0)
    {
        _userName.text = [NSString stringWithFormat:NSLocalizedString(@"%@'s Word Bucket", nil),[UserDefaluts objectForKey:@"UserName"]]; 
    } else
        _userName.text = @"Word Bucket";
    
}

-(void) bucketAccess:(NSString *) bucketColor
{
    WordListVC *wordListVC = [[WordListVC alloc] initWithNibName:@"WordListVC" bundle:[NSBundle mainBundle]];
    wordListVC.bucketColor = bucketColor;
    [self.navigationController pushViewController:wordListVC animated:YES];
}

- (IBAction)wordListButtonClicked:(id)sender
{
    UIButton *wordButton = (UIButton*)sender;
    if ([wordButton.titleLabel.text integerValue] > 0) {
        
        switch ([sender tag]) {
            case 51:
                [self bucketAccess:@"White"];
                break;
            case 52:
                [self bucketAccess:@"Red"];
                break;
            case 53:
                [self bucketAccess:@"Orange"];
                break;
            case 54:
                [self bucketAccess:@"Green"];
                break;
                
            default:
                break;
        }
        
    } else {
        
        NSString *title = nil;
        NSString *message = nil;
        switch ([sender tag]) {
            case 51:
                title = @"Oops!";
                message = NSLocalizedString(@"You have no words in your White Bucket. Search and save more new words!", nil);
                break;
            case 52:
                title = @"Good work!";
                message = NSLocalizedString(@"Good work! You have no words in your Red Bucket. Only words that you get wrong in the other colours go here.", nil);
                break;
            case 53:
                title = @"Sorry!";
                message = [NSString stringWithFormat:NSLocalizedString(@"You have no words in your Orange Bucket. To add words to Orange you must do the White Bucket tests.", nil)];
                break;
            case 54:
                title = @"Sorry!";
                message = [NSString stringWithFormat:NSLocalizedString(@"You have no words in your Green Bucket. To add words to Green you must do the Orange Bucket tests.", nil)];
                break;
                
            default:
                break;
        }
        
        title=nil;
        [Common showAlertView:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    }
}

- (IBAction)languageButtonClicked:(id)sender {
    
    SharedAppDelegate.isNativeSrchLang = !SharedAppDelegate.isNativeSrchLang;
    if(SharedAppDelegate.isNativeSrchLang) {
        [_nativeLangLabel setTextColor:[UIColor whiteColor]];
        [_targetLangLabel setTextColor:[UIColor blueColor]];
    } else {
        [_nativeLangLabel setTextColor:[UIColor blueColor]];
        [_targetLangLabel setTextColor:[UIColor whiteColor]];
    }
    
}


- (IBAction)searchClicked:(id)sender {
    
    /*
    NSLog(@"search button clicked");
    NSString *strCurrentLang = [UITextInputMode currentInputMode].primaryLanguage;
    NSLog(@"Current language%@",strCurrentLang);
    NSLog(@"native and targ lang is %@ %@",[UserDefaluts valueForKey:kNativeLangCode],[UserDefaluts valueForKey:kTargetLangCode]);
    NSArray *arrLang = [strCurrentLang componentsSeparatedByString:@"-"];
    SharedAppDelegate.isNativeSrchLang = YES;
    
    SharedAppDelegate.isNativeSrchLang = [self isDictionaryWord:_txtSearch.text];
    
    if (SharedAppDelegate.isNativeSrchLang) {
        
        NSLog(@"IN CURRENT LANGAGE");
    } else {
        NSLog(@"IN TARGET LANGUAGE");
    }
    
    
    
    
    if([arrLang count] > 0)
    {
        NSString *strNativeLang = [[UserDefaluts valueForKey:@"nativeLanguageCode"] substringToIndex:2];
        NSString *strTargetLang = [[UserDefaluts valueForKey:@"targetLanguageCode"] substringToIndex:2];
        if([[arrLang objectAtIndex:0] isEqualToString:strTargetLang])
        {
            SharedAppDelegate.isNativeSrchLang = NO;
            
        }
        else
        {
            SharedAppDelegate.isNativeSrchLang = YES;
            
        }
    }
    
    //NSLog(@"%@",[UserDefaluts objectForKey:@"nativeLanguageCode"]);
    //NSLog(@"%@",[UserDefaluts objectForKey:@"targetLanguageCode"]);
    //    strCurrentLang = [UserDefaluts objectForKey:@"nativeLanguageCode"];
    */
    
    
    // Spell checker
    /*
    
    NSString *spellCLangCode = SharedAppDelegate.isNativeSrchLang ? [UserDefaluts objectForKey:kTargetLangCode] : [UserDefaluts objectForKey:kNativeLangCode];
    UITextChecker *checker = [[UITextChecker alloc] init];
    
    NSRange checkRange = NSMakeRange(0, _txtSearch.text.length);
    
    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:_txtSearch.text
                                                               range:checkRange
                                                          startingAt:checkRange.location
                                                                wrap:NO
                                                            language:spellCLangCode];
    
    NSArray *arrGuessed = [checker guessesForWordRange:misspelledRange inString:_txtSearch.text language:spellCLangCode];
    if([arrGuessed count]>0)
        _txtSearch.text = [_txtSearch.text stringByReplacingCharactersInRange:misspelledRange withString:[arrGuessed objectAtIndex:0]];
    */
    
    if (_txtSearch.text.length > 0) {
        
    
        [_txtSearch resignFirstResponder];
        NSLog(@"new check is %@",[self languageForString:_txtSearch.text]);
        if([self connected])
        {
            NSString *nib = SharedAppDelegate.isPhone5 ? @"SearchVC" : @"SearchVCiPhone4";
            SearchVC *search = [[SearchVC alloc] initWithNibName:nib bundle:[NSBundle mainBundle]];
           // NSLog(@"nativ lang = %@ \n target lang = %@ \n search type = %c",[UserDefaluts objectForKey:kNativeLangCode],[UserDefaluts objectForKey:kTargetLangCode],SharedAppDelegate.isNativeSrchLang);
            
            NSString *baseString = SharedAppDelegate.isNativeSrchLang ? [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode]:[[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode];
            if ([baseString isEqualToString:@"de"]) {
                search.strSearchWord = _txtSearch.text;
            } else {
                search.strSearchWord = [_txtSearch.text lowercaseString];
            }
            
            [self.navigationController pushViewController:search animated:YES];
        }
        else
        {
            [Common showAlertView:nil message:NSLocalizedString(@"No internet connection!", nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        }
    
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please enter any word.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
    }
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


- (NSString *)languageForString:(NSString *)text {
    
    if (text.length < 100) {
        
        return (__bridge NSString *)CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, CFRangeMake(0, text.length));
        
    } else {
        
        return (__bridge NSString *)CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, CFRangeMake(0, 100));
    }
}
-(BOOL)isDictionaryWord:(NSString*)word {
    
    UITextChecker *checker = [[UITextChecker alloc] init];
    //NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *currentLanguage = [UserDefaluts objectForKey:kNativeLangCode];//[currentLocale objectForKey:NSLocaleLanguageCode];//@"en"
    NSRange searchRange = NSMakeRange(0, [word length]);
    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:word range: searchRange startingAt:0 wrap:NO language: currentLanguage];
    return misspelledRange.location == NSNotFound;
                                      
}

#pragma mark - Text field delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [textField setInputAccessoryView:_toolBar];
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
}
#pragma mark - Toolbar delegate
-(void) closePicker:(NSInteger)tag
{
    [_txtSearch resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self searchClicked:nil];
    //[_txtSearch setText:@""];
    //[textField resignFirstResponder];
    return YES;
}

- (IBAction)infoButtonClicked:(id)sender {
    
    NSString *nib = SharedAppDelegate.isPhone5 ? @"InfoViewC" : @"InfoViewCiPhone4";
    InfoViewC *infoVCObj = [[InfoViewC alloc] initWithNibName:nib bundle:nil];
    [self.navigationController pushViewController:infoVCObj animated:YES];
    
}


- (IBAction)doneButtonActionOnToolBar:(id)sender {
    
    [_txtSearch setText:@""];
    [_txtSearch resignFirstResponder];

}



@end
