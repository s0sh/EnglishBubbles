//
//  BucketPlusVC.m
//  WordBucket
//
//  Created by Amit Garg on 12/31/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "BucketPlusVC.h"
#import "WordOfWeekListViewC.h"

@interface BucketPlusVC ()

@end

@implementation BucketPlusVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIFont*)getFontWithString:(NSString*)string withHeight:(CGFloat)ht withWidth:(CGFloat)wd
{
    CGSize constraint = CGSizeMake(wd, 2000.0f);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:SharedAppDelegate.isPhone5 ? 39 : 26];
    NSInteger finalFont = SharedAppDelegate.isPhone5 ? 39 : 26;
    for (int k = SharedAppDelegate.isPhone5 ? 39 : 26; k >1; k--) {
        CGSize size = [string sizeWithFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:k]
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
    [_btnSkype setTitle:NSLocalizedString(@"SKYPE GAMES CLASSES", nil) forState:UIControlStateNormal];
    [_btnSkype.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnFacebook setTitle:NSLocalizedString(@"DAILY FACEBOOK GAMES", nil) forState:UIControlStateNormal];
    [_btnFacebook.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnWordOfWeek setTitle:NSLocalizedString(@"WORDS OF THE WEEK", nil) forState:UIControlStateNormal];
    [_btnWordOfWeek.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_learnEnglishLabel setText:NSLocalizedString(@"Learn English through games", nil)];
    //[_learnEnglishLabel setFont:[self getFontWithString:_learnEnglishLabel.text withHeight:SharedAppDelegate.isPhone5 ? 98 : 69 withWidth:297]];
    
    [_learnEnglishLabel setFont:[Common AdjustLabelFont:_learnEnglishLabel]];
    [_withEnglishLabel setText:NSLocalizedString(@"with English Bubble", nil)];
}

- (void)viewDidLoad
{
    [self setLocalizedString];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Bucket+ Screen";
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)wordOfWeekBtnClicked:(id)sender {

    NSString *nib = SharedAppDelegate.isPhone5 ? @"WordOfWeekListViewC" : @"WordOfWeekListViewCiPhone4";
    WordOfWeekListViewC *wordOfWeekObj = [[WordOfWeekListViewC alloc] initWithNibName:nib bundle:nil];
    [self.navigationController pushViewController:wordOfWeekObj animated:YES];
    
}

- (IBAction)skypeButtonClicked:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.englishbubble.com"]];
}

-(IBAction)fbGames:(id)sender
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/englishbubble"]];
}
- (void)viewDidUnload {
    [self setBtnSkype:nil];
    [self setBtnFacebook:nil];
    [self setBtnWordOfWeek:nil];
    [self setLearnEnglishLabel:nil];
    [self setWithEnglishLabel:nil];
    [super viewDidUnload];
}
@end
