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
    
    _isUpgradeClicked = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComplete:)
                                                 name:@"noteModified" object:nil];
    
    if (_isFromGreen) {
        
        if (SharedAppDelegate.isPhone5) {
            
           [self.view addSubview:_bucketFullView];
        } else {
            
            [self.view addSubview:_bucketFullScroll];
            [_bucketFullScroll setContentSize:CGSizeMake(320, 460)];
            
        }
        
    } else {
        
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

- (UIFont*)getFontWithString:(NSString*)string withHeight:(CGFloat)ht withWidth:(CGFloat)wd
{
    CGSize constraint = CGSizeMake(wd, 2000.0f);
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    NSInteger finalFont = 17;
    for (int k = 17; k >1; k--) {
        CGSize size = [string sizeWithFont: [UIFont fontWithName:@"Helvetica-Bold" size:k]
                         constrainedToSize:constraint
                             lineBreakMode:UILineBreakModeWordWrap];
        
        if (size.height <= ht) {
            finalFont = k;
            break;
        }
        
    }
    
    return [font fontWithSize:finalFont];
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
    [_upgradnowfor1Lbl setText:NSLocalizedString(@"Upgrade now and get:", nil)];
    
    [_bucketFullLabel setText:NSLocalizedString(@"UPGRADE NOW", nil)];
    
    [_oops1Label setText:NSLocalizedString(@"Oops your Bucket is full!", nil)];
    
    [_updageNow1Label setText:NSLocalizedString(@"Upgrade now to save and learn more words in Word Bucket", nil)];
    [_upgradenow2Label setText:NSLocalizedString(@"Upgrade now to save and learn unlimited words in Word Bucket.", nil)];
    [_wbFree1Label setText:NSLocalizedString(@"With Word Bucket FREE you have 50 words and 25 new word saved", nil)];
    [_saved25WordLabel setText:NSLocalizedString(@"You have saved 25 words in your Bucket.", nil)];
    [_upgradenow2Label setFont:[Common AdjustLabelFont:_upgradenow2Label]];
    //[_upgradenow2Label setFont:[self getFontWithString:_upgradenow2Label.text withHeight:46 withWidth:280]];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"%@",language);
    if ([language isEqualToString:@"fr"]) {
        
        [_upgradenow2Label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:9]];
    }
    
}

- (IBAction)upgradeButtonClicked:(id)sender {
    
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: Load document...
        
        _isUpgradeClicked = YES;
        [[Common sharedInstance] showActivityIndicator:self];
        [[Common sharedInstance] synconCloud];
        [self.view setUserInteractionEnabled:NO];
        [self performSelector:@selector(updateComplete:) withObject:nil afterDelay:60.0];
        
    } else {
        
        NSLog(@"No iCloud access");
        
        
        NSString *iCloudWarningMsg = NSLocalizedString(@"Important! You haven't set up iCloud yet. If you want to transfer your words to the full version, set up iCloud in your iPhone settings now and then come back and upgrade here.", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:iCloudWarningMsg delegate:self cancelButtonTitle:NSLocalizedString(@"Ignore", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alert show];
            [UserDefaluts setBool:YES forKey:@"upgradeAlert"];
            [UserDefaluts synchronize];
        
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self openPaidVersion];
    } else {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
    }
}


- (void)openPaidVersion
{
        NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@",kWBPaidAppId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
- (void)updateComplete:(NSNotification*)note
{
    if (_isUpgradeClicked) {
        [self.view setUserInteractionEnabled:NO];
        _isUpgradeClicked=NO;
        [[Common sharedInstance] stopActivityIndicator:self];
        [self openPaidVersion];
    }
    
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

@end
