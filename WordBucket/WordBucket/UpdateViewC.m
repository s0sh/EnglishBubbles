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
    [_lblUpgradeNow setText:NSLocalizedString(@"Upgrade now for $1.99 and get:", nil)];
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
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Update Screen";
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

- (IBAction)upgradeButtonClicked:(id)sender {
    
}
- (void)viewDidUnload {
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
