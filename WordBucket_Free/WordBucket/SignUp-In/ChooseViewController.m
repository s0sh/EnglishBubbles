//
//  ChooseViewController.m
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import "ChooseViewController.h"
#import "JoinViewController.h"
#import "LoginViewController.h"

@interface ChooseViewController ()



@end
@implementation ChooseViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
  
    
}
-(IBAction)join:(id)sender
{
    JoinViewController *splashObj = nil;
    if([UserDefaluts boolForKey:@"iPhone5"])
        splashObj = [[JoinViewController alloc] initWithNibName:@"JoinViewController"
                                               bundle:nil];
    else
        splashObj = [[JoinViewController alloc] initWithNibName:@"JoinViewController"
                                               bundle:nil];
    
    
    [self.navigationController pushViewController:splashObj animated:YES];
    

}
-(IBAction)login:(id)sender
{
    LoginViewController *splashObj = nil;
    if([UserDefaluts boolForKey:@"iPhone5"])
        splashObj = [[LoginViewController alloc] initWithNibName:@"LoginVCiPhone4"
                                                         bundle:nil];
    else
        splashObj = [[LoginViewController alloc] initWithNibName:@"LoginVCiPhone4"
                                                         bundle:nil];
    
    
    [self.navigationController pushViewController:splashObj animated:YES];
    
    
}
@end
