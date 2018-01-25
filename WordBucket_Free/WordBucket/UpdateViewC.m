//
//  UpdateViewC.m
//  WordBucket
//
//  Created by ashish on 3/21/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "UpdateViewC.h"

@interface UpdateViewC ()

@end

@implementation UpdateViewC

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
    [_lblLoveWordBucket setText:NSLocalizedString(@"Do you love Word Bucket?", nil)];
    [_lblfreefiftyWord setText:NSLocalizedString(@"With Word Bucket FREE you have 50 words and 25 new word saved", nil)];
    [_lblUpgradeNow setText:NSLocalizedString(@"Upgrade now and get:", nil)];
    [_lblUnlimited setText:NSLocalizedString(@"Unlimited storage for new words", nil)];
    [_lblGreenBucketGame setText:NSLocalizedString(@"Green Bucket game", nil)];
    [_lblNoads setText:NSLocalizedString(@"No ads", nil)];
    [_lblOfflineWishlist setText:NSLocalizedString(@"Offline Wishlist", nil)];
    [_btnUpgrade setTitle:NSLocalizedString(@"UPGRADE", nil) forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLocalizedString];
    
    _isUpgradeClicked = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(updateComplete:)
                                                      name:@"noteModified" object:nil];
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Update Screen";
}


- (IBAction)upgradeButtonClicked:(id)sender {
    
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    
    if (ubiq) {
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [Common hideTabBar:self.tabBarController];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [Common showTabBar:self.tabBarController];
    [super viewWillDisappear:animated];
    
    
}


- (IBAction)corssButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noteModified" object:nil];
    
    [self setLblLoveWordBucket:nil];
    [self setLblfreefiftyWord:nil];
    [self setLblUpgradeNow:nil];
    [self setLblUnlimited:nil];
    [self setLblGreenBucketGame:nil];
    [self setLblNoads:nil];
    [self setLblOfflineWishlist:nil];
    [self setBtnUpgrade:nil];
    [super viewDidUnload];
}
@end
