//
//  CommunityVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 12/24/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "CommunityVC.h"
#import "LatestTestVC.h"
#import "HistoryVC.h"
#import "InviteFriendsVC.h"
#import "SendAWordVC.h"
#import "Common.h"
#import "BucketPlusVC.h"
#import "UserVoice.h"

@interface CommunityVC ()

@end

@implementation CommunityVC

bool bannerLoadded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = NSLocalizedString(@"Community", @"Community");
        //self.tabBarItem.image = [UIImage imageNamed:@"first"];
        //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(home:)];
    }
    return self;
}

- (IBAction)homeButtonClicked:(id)sender {
    
    for(UIView *view in self.tabBarController.tabBar.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    [self.tabBarController setSelectedIndex:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
}

- (void)setLocalizedString
{
    [_bucketPlusButton setTitle:NSLocalizedString(@"Bucket+", nil) forState:UIControlStateNormal];
    [_btnHelpUsToImprove setTitle:NSLocalizedString(@"Help us to improve Word Bucket", nil) forState:UIControlStateNormal];
    [_btnInviteFrnd setTitle:NSLocalizedString(@"Invite friend to Word Bucket", nil) forState:UIControlStateNormal];
    [_btnSendAWord setTitle:NSLocalizedString(@"Send a friend a word", nil) forState:UIControlStateNormal];
    [_btnWBLeaderboard setTitle:NSLocalizedString(@"The Word Bucket Leaderboard", nil) forState:UIControlStateNormal];
    [_bucketPlusButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnInviteFrnd.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnHelpUsToImprove.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnSendAWord.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnWBLeaderboard.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_titileLbl setText:NSLocalizedString(@"Community", nil)];
    
}

- (void)viewDidLoad
{
    [self setLocalizedString];
    [super viewDidLoad];
    
    
    
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[SharedAppDelegate sharedAd] removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bannerError" object:nil];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Community Screen";
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBanner:) name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerError:) name:@"bannerError" object:nil];
    [self addBannerView];
    
    // Hide bucket+ button when target language is not english
    if (![[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"en"]) {
        
        [_containerImgView setFrame:CGRectMake(14, 105, 295, 140)];
        [_bucketPlusButton setHidden:YES];
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (UVConfig *)uvConfig {
    UVConfig *config = [UVConfig configWithSite:@"demo.uservoice.com" andKey:@"pZJocTBPbg5FN4bAwczDLQ" andSecret:@"Q7UKcxRYLlSJN4CxegUYI6t0uprdsSAGthRIDvYmI"];
//    UVConfig *config = [UVConfig configWithSite:@"demo.uservoice.com" andKey:@"zVT2LErHVrRGLRhd67JCg" andSecret:@"rR2KVI3Qmc25lDHTawZCgcURZq4JOej72IWovpUP0Q"];
    // config.topicId = 4656;
    // config.customFields = @{@"Type" : @"Support Request", @"Platform" : @"Mobile"};
    // config.showContactUs = NO;
    // config.showForum = NO;
    // config.showPostIdea = NO;
    // config.showKnowledgeBase = NO;
    // [UserVoice setDelegate:self];
    // [UVStyleSheet setStyleSheet:[[DemoStyleSheet alloc] init]];
    return config;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"en"])
        {
            BucketPlusVC *bucket = [[BucketPlusVC alloc] initWithNibName:@"BucketPlusVC" bundle:nil];
            
            [self.navigationController pushViewController:bucket animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"English is not set as the Target Language" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    else if(indexPath.section == 1)
    {
        SendAWordVC *sendAWord = [[SendAWordVC alloc] initWithNibName:@"SendAWordVC" bundle:nil];
        
        [self.navigationController pushViewController:sendAWord animated:YES];
    }
    else if(indexPath.section == 2)
    {
        InviteFriendsVC *invite = [[InviteFriendsVC alloc] initWithNibName:@"InviteFriendsVC" bundle:nil];
        [self.navigationController pushViewController:invite animated:YES];
    }
    else if(indexPath.section == 4)
    {        
        [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:[self uvConfig]];
    }
    
}
 
*/


- (IBAction)commnunityButtonClicked:(id)sender {
    
    switch ([sender tag]) {
        case 100:
        {
            // Bucket+
            NSString *nib = SharedAppDelegate.isPhone5 ? @"BucketPlusVC" : @"BucketPlusVCiPhone4";
            BucketPlusVC *bucket = [[BucketPlusVC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:bucket animated:YES];
            
        }
            break;
        case 101:
        {
            // Send a friend a word
            NSString *nib = SharedAppDelegate.isPhone5 ? @"SendAWordVC" : @"SendAWordVCiPhone4";
            SendAWordVC *sendAWord = [[SendAWordVC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:sendAWord animated:YES];
        }
            break;
        case 102:
        {
            // Invite friends to Word Bucket
            NSString *nib = SharedAppDelegate.isPhone5 ? @"InviteFriendsVC" : @"InviteFriendsVCiPhone4";
            InviteFriendsVC *invite = [[InviteFriendsVC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:invite animated:YES];
            
        }
            break;
        case 103:
        {
            // The Word Bucket leaderboard
        }
            break;
        case 104:
        {
            // Help us to improve WordBucket
            [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:[self uvConfig]];
        }
            break;
            
        default:
            break;
    }
}

- (UVConfig *)uvConfig {
    
    UVConfig *config = [UVConfig configWithSite:@"wordbucket.uservoice.com" andKey:@"zVT2LErHVrRGLRhd67JCg" andSecret:@"rR2KVI3Qmc25lDHTawZCgcURZq4JOej72IWovpUP0Q"];
    //http://wordbucket.uservoice.com/
    
    //    UVConfig *config = [UVConfig configWithSite:@"demo.uservoice.com" andKey:@"zVT2LErHVrRGLRhd67JCg" andSecret:@"rR2KVI3Qmc25lDHTawZCgcURZq4JOej72IWovpUP0Q"];
    // config.topicId = 4656;
    // config.customFields = @{@"Type" : @"Support Request", @"Platform" : @"Mobile"};
    // config.showContactUs = NO;
    // config.showForum = NO;
    // config.showPostIdea = NO;
    // config.showKnowledgeBase = NO;
    // [UserVoice setDelegate:self];
    // [UVStyleSheet setStyleSheet:[[DemoStyleSheet alloc] init]];
    return config;
}


- (void)viewDidUnload {
    [self setContainerImgView:nil];
    [self setBucketPlusButton:nil];
    [self setBtnSendAWord:nil];
    [self setBtnInviteFrnd:nil];
    [self setBtnWBLeaderboard:nil];
    [self setBtnHelpUsToImprove:nil];
    [self setTitileLbl:nil];
    [super viewDidUnload];
}
@end
