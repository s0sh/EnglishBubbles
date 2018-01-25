//
//  LearnEngTGameViewC.m
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "LearnEngTGameViewC.h"

@interface LearnEngTGameViewC ()

@end

@implementation LearnEngTGameViewC

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
    [_titleLabel setText:NSLocalizedString(@"Learn English through games", nil)];
    NSString *btnTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"TRY A FREE CLASS", nil)];
    [_btnTryFreeClass setTitle:btnTitle forState:UIControlStateNormal];
    [_btnTryFreeClass.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
}

- (void)viewDidLoad
{
    
    [self setLocalizedString];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Learn English Through Game Screen";
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

- (IBAction)soundsCoolButtonClicked:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.eepurl.com/sVTjf"]];
}
- (void)viewDidUnload {
    [self setDetailTextView:nil];
    [self setTitleLabel:nil];
    [self setBtnTryFreeClass:nil];
    [super viewDidUnload];
}
@end
