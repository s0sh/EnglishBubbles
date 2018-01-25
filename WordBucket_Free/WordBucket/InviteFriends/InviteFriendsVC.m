//
//  InviteFriendsVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 12/24/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "InviteFriendsVC.h"
#import "Common.h"
@interface InviteFriendsVC ()

@end

@implementation InviteFriendsVC

bool bannerLoadded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setLocalizedString
{
    [_btnPostOnFacebook setTitle:NSLocalizedString(@"POST ON FACEBOOK", nil) forState:UIControlStateNormal];
    [_btnPostOnFacebook.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnShareOnEmail setTitle:NSLocalizedString(@"SHARE ON EMAIL", nil) forState:UIControlStateNormal];
    [_btnShareOnEmail.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnText setTitle:NSLocalizedString(@"TEXT IT", nil) forState:UIControlStateNormal];
    [_btnText.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnTweet setTitle:NSLocalizedString(@"TWEET IT", nil) forState:UIControlStateNormal];
    [_btnText.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_titleLbl setText:NSLocalizedString(@"Invite Your Friends", nil)];
}

- (void)viewDidLoad
{
    
    [self setLocalizedString];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBanner:) name:@"bannerLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerError:) name:@"bannerError" object:nil];
    [self addBannerView];
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
    self.screenName = @"Invite Friends Screen";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableview datasource methods
//table data source methods

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        [[Common sharedInstance] postStatusUpdateClick:self message:@"Check out Word Bucket. (LINK - HTTP://WORDBUCKET.COM) It's a great app for finding and learning new words. FREE to download for Android and iOS." withUrl:nil];
    }
    else if(indexPath.section == 1)
    {
        [[Common sharedInstance] showMailPicker:self subject:@"" emailBody:@"Check out Word Bucket. (LINK - HTTP://WORDBUCKET.COM) It's a great app for finding and learning new words. FREE to download for Android and iOS."];
    }
    else if(indexPath.section == 2)
    {
        [[Common sharedInstance] sendSMS:self message:@"Check out Word Bucket. (LINK - HTTP://WORDBUCKET.COM) It's a great app for finding and learning new words. FREE to download for Android and iOS." recipientList:nil];
    }
    else
    {
        [[Common sharedInstance] sendEasyTweet:self text:@"Are you learning a language? Find and learn new words with @WordBucket (LINK - HTTP://WORDBUCKET.COM)" withUrl:nil];
    }
}*/

- (IBAction)inviteFrndsButtonClicked:(id)sender {
    
    switch ([sender tag]) {
        case 100:
        {
            
            // Share on email
            // Share on email
            NSString *messageString = NSLocalizedString(@"Check out <a href=\"http://www.wordbucket.com\">Word Bucket.</a> It's a great app for finding and learning new words. FREE to download for Android and iOS.", nil);
            NSMutableString *message =[NSMutableString stringWithFormat:@"<html><body>%@</body></html>",messageString];
            [[Common sharedInstance] showMailPicker:self subject:NSLocalizedString(@"Word Bucket - find and learn new words", nil) emailBody:message];
            
        }
            break;
        case 101:
        {
            // Text it
            NSString *message = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Check out Word Bucket. It's a great app for finding and learning new words. FREE to download for Android and iOS.", nil),@" http://www.wordbucket.com"];
            NSLog(@"message is %@",message);
            [[Common sharedInstance] sendSMS:self message:message recipientList:nil];
        }
            break;
        case 102:
        {
            // Post on facebook
            NSString *message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Check out Word Bucket. It's a great app for finding and learning new words. FREE to download for Android and iOS.", nil)];
            [[Common sharedInstance] postStatusUpdateClick:self message:message withUrl:[NSURL URLWithString:@"http://www.wordbucket.com"]];
        }
            break;
        case 103:
        {
            // Tweet it            
            [[Common sharedInstance] sendEasyTweet:self text:NSLocalizedString(@"Are you learning a language? Find and learn new words with @WordBucket", nil) withUrl:[NSURL URLWithString:@"http://wordbucket.com"]];
        }
            break;
            
        default:
            break;
    }
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
- (void)viewDidUnload {
    
    [self setBtnShareOnEmail:nil];
    [self setBtnText:nil];
    [self setBtnPostOnFacebook:nil];
    [self setBtnTweet:nil];
    [self setTitleLbl:nil];
    [super viewDidUnload];
    
}
@end
