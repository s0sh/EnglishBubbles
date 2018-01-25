//
//  LoginViewController.m
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import "LoginViewController.h"
#import "WBDummyJoinInService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"
#import "SynchronizationModel.h"
@interface LoginViewController()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signInFBButton;
@property (weak, nonatomic) IBOutlet UIButton *signInGPButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)WBDummyJoinInService *service;
@property(nonatomic,retain)LoginViewModel *viewModel;
@end

@implementation LoginViewController

#define Y_OFFSET 57
#define Y_OFFSET_SMALL 5

/*!
 * @discussion  Set square [10x10] indents to textfilds
 */
-(void)setIndents:(UITextField*)textfield
{
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [textfield setLeftViewMode:UITextFieldViewModeAlways];
    [textfield setLeftView:spacerView];
    
}

-(void)sendLocalDataToServerToSynch
{

    [[SynchronizationModel currentObject] prepareJsonWithNewWord:nil];
    
}
-(void)bindViewModel
{
    
    RAC(self.viewModel, nameStr) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel, passwordStr) = self.passwordTextField.rac_textSignal;
    self.signInButton.rac_command = self.viewModel.executeJoin;
    [RACObserve(self.viewModel, successDict) subscribeNext:^(id x) {
        if([[NSString stringWithFormat:@"%@",x[@"error"] ] isEqualToString:@"0"])
        {
            [self sendLocalDataToServerToSynch];
            [self moveNext];
            
        }
            [[Common sharedInstance] stopActivityIndicator:self];
    }];
    
    
    [self.viewModel.executeJoin.executionSignals
     subscribeNext:^(id x) {
         [[Common sharedInstance] showActivityIndicator:self];
         [self.usernameTextField resignFirstResponder];
         
         
     }];
    
    
}
- (void)viewDidLoad {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"enterAction"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super viewDidLoad];
    [self.mainScroll setContentSize:CGSizeMake(self.view.frame.size.width,600)];
    self.viewModel = [[LoginViewModel alloc] init];
    self.signInFailureText.hidden = YES;
    [self setIndents:self.usernameTextField];
    [self setIndents:self.passwordTextField];
    [self bindViewModel];
    self.passwordTextField.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [[self view] endEditing:YES];
    
    [self.passwordTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [UIView animateWithDuration:1.0 animations:^{
        [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
}
#pragma mark - Text field delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
   
    [UIView animateWithDuration:1.0 animations:^{
        [self.mainScroll setContentOffset:CGPointMake(0, self.mainScroll.frame.origin.y+(textField==self.passwordTextField?Y_OFFSET:Y_OFFSET_SMALL)) animated:YES];
        
    }];
    
    
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)moveNext
{
    
    [[Common sharedInstance] stopActivityIndicator:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SplashVC *splashObj = nil;
        if([UserDefaluts boolForKey:@"iPhone5"])
            splashObj = [[SplashVC alloc] initWithNibName:@"SplashVC"
                                                   bundle:nil];
        else
            splashObj = [[SplashVC alloc] initWithNibName:@"SplashVCiPhone4"
                                                   bundle:nil];
        
        
        [self.navigationController pushViewController:splashObj animated:YES];
        
    });
    
    
}

- (IBAction)joinWithFacebook:(id)sender {
    [self moveNext];
}

- (IBAction)joinWithTwitter:(id)sender {
    [self moveNext];
}
@end
