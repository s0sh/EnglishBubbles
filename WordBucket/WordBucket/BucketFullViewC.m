//
//  BucketFullViewC.m
//  WordBucket
//
//  Created by ashish on 3/24/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "BucketFullViewC.h"

@interface BucketFullViewC ()

@end

@implementation BucketFullViewC

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
    
    [self setLocalizedString];
    _bucketFullLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _bucketFullLabel.transform = CGAffineTransformMakeRotation(degreesToRadian(-5));
    NSInteger date = [Common dayStringForDate:[NSDate date]];
    
    if (SharedAppDelegate.isPhone5) {
        if (date%2==0)
            [self.view addSubview:_upgradeView];
         else 
            [self.view addSubview:_bucketFullView];
        
    } else {
        
        [_bucketFullScroll setContentSize:CGSizeMake(320, 460)];
        
        if (date%2==0)
            [self.view addSubview:_upgradeView];
        else
            [self.view addSubview:_bucketFullScroll];
        
    }
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Bucket Full Screen";
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Common hideTabBar:self.tabBarController];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Common showTabBar:self.tabBarController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)corssButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLocalizedString
{
    [_btnUpgrade setTitle:NSLocalizedString(@"UPGRADE", nil) forState:UIControlStateNormal];
    [_btnUpgrade1 setTitle:NSLocalizedString(@"UPGRADE", nil) forState:UIControlStateNormal];
    [_unlimitedStrg1Lbl setText:NSLocalizedString(@"Unlimited storage for new words", nil)];
    [_unlimitesStorageLabel setText:_unlimitedStrg1Lbl.text];
    [_greenBckGame1Lbl setText:NSLocalizedString(@"Green Bucket game", nil)];
    [_greenBckGameLbl setText:_greenBckGame1Lbl.text];
    [_noAda1Lbl setText:NSLocalizedString(@"No ads", nil)];
    [_noAdsLbl setText:_noAda1Lbl.text];
    [_offileWL1Lbl setText:NSLocalizedString(@"Offline Wishlist", nil)];
    [_yougetLabel setText:NSLocalizedString(@"You get:", nil)];
    [_upgradnowfor1Lbl setText:NSLocalizedString(@"Upgrade now for $1.99 and get:", nil)];
    
    [_bucketFullLabel setText:NSLocalizedString(@"UPGRADE NOW", nil)];
    
    [_oops1Label setText:NSLocalizedString(@"Oops your Bucket is full!", nil)];
    
    [_updageNow1Label setText:NSLocalizedString(@"Upgrade now to save and learn more words in Word Bucket", nil)];
    [_upgradenow2Label setText:_updageNow1Label.text];
    [_wbFree1Label setText:NSLocalizedString(@"With Word Bucket FREE you have 50 words and 25 new word saved", nil)];
    [_saved25WordLabel setText:NSLocalizedString(@"You have saved 25 words in your Bucket.", nil)];
    
    
    
}


- (void)viewDidUnload {
    [self setUpgradeView:nil];
    [self setBucketFullView:nil];
    [self setBucketFullScroll:nil];
    [self setBucketFullLabel:nil];
    [self setCngrtltonLabel:nil];
    [self setSaved25WordLabel:nil];
    [self setUpgradenow2Label:nil];
    [self setYougetLabel:nil];
    [self setUnlimitesStorageLabel:nil];
    [self setGreenBckGameLbl:nil];
    [self setNoAdsLbl:nil];
    [self setOfflineWLLbl:nil];
    [self setBtnUpgrade:nil];
    [self setOops1Label:nil];
    [self setUpdageNow1Label:nil];
    [self setWbFree1Label:nil];
    [self setUpgradnowfor1Lbl:nil];
    [self setUnlimitedStrg1Lbl:nil];
    [self setGreenBckGameLbl:nil];
    [self setGreenBckGame1Lbl:nil];
    [self setNoAda1Lbl:nil];
    [self setOffileWL1Lbl:nil];
    [self setBtnUpgrade1:nil];
    [super viewDidUnload];
}
- (IBAction)upgradeButtonClicked:(id)sender {
}
@end
