//
//  PreGreenTestVC.m
//  WordBucket
//
//  Created by ashish on 3/6/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "PreGreenTestVC.h"
#import <QuartzCore/QuartzCore.h>
#import "BucketFullViewC.h"


@interface PreGreenTestVC ()

@end

@implementation PreGreenTestVC

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
    [self.btnAllGreenTest setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"PLAY GREEN GAME", nil)] forState:UIControlStateNormal];
    [self.btnAllGreenTest.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.btnSaveInDanger setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"SAVE GREEN WORDS IN DANGER", nil)] forState:UIControlStateNormal];
    [self.btnSaveInDanger.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.prctiseGreenLabel setText:NSLocalizedString(@"Practise Green Words", nil)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLocalizedString];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retakeGreenTestNoti:) name:kRetakeGreenTestNotification object:nil];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.screenName = @"Pre-Green Test Screen";
    
    NSString *greenWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT count(*) FROM tbl_Dictionary where bucketColor = 'Green' and action != 'InDanger'"]];
    [_greenLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@ Words Safe", nil),greenWord]];
    
    NSString *indangerWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT count(*) FROM tbl_Dictionary where bucketColor = 'Green' and action = 'InDanger'"]];
    [_indangerLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@ Words In Danger", nil),indangerWord]];
    [_indangeLabel2 setText:_indangerLabel.text];
    [_indangeLabel3 setText:_indangerLabel.text];
    [_indangeLabel4 setText:_indangerLabel.text];
}

- (void)retakeGreenTestNoti:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"userInfo %@",userInfo);
    
    
     if ([[userInfo objectForKey:kBucketColor] isEqualToString:@"Green"]) {
        
        [self pushForGreenTest:YES];
        
    } else  {
        
        [self pushForGreenTest:NO];
        
    } 
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- Button Action 
- (IBAction)testAllGreenBtnClicked:(id)sender {
    
    
    [self pushForGreenTest:YES];
}

- (IBAction)saveIndangerBtnClicked:(id)sender {
    
    [self pushForGreenTest:NO];
}

- (IBAction)greenTestButtonClicked:(id)sender {
    
    [self pushForGreenTest:YES];
}

- (IBAction)indangerTestButtonClicked:(id)sender {
    
    [self pushForGreenTest:NO];
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
}

- (void)pushForGreenTest:(BOOL)isGreenTest
{
    NSString *nib = SharedAppDelegate.isPhone5 ? @"BucketFullViewC" : @"BucketFullViewCiPhone4";
    BucketFullViewC *bucketFull = [[BucketFullViewC alloc] initWithNibName:nib bundle:nil];
    bucketFull.isFromGreen = YES;
    [self.navigationController pushViewController:bucketFull animated:YES];
}

- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRetakeGreenTestNotification object:nil];
    [self setGreenLabel:nil];
    [self setIndangerLabel:nil];
    [self setIndangeLabel2:nil];
    [self setIndangeLabel3:nil];
    [self setIndangeLabel4:nil];
    [self setPrctiseGreenLabel:nil];
    [self setBtnAllGreenTest:nil];
    [self setBtnSaveInDanger:nil];
    [super viewDidUnload];
}
@end
