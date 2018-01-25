//
//  JoinViewController.m
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import "JoinViewController.h"
#import "WBDummyJoinInService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JoinViewModel.h"
#import "SynchronizationModel.h"
@interface JoinViewController ()
{

    
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signInFBButton;
@property (weak, nonatomic) IBOutlet UIButton *signInGPButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)WBDummyJoinInService *service;
@property(nonatomic,retain)JoinViewModel *viewModel;
@end

@implementation JoinViewController

#define Y_OFFSET 50

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
    self.usernameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    [self setIndents:self.usernameTextField];
    [self setIndents:self.passwordTextField];
    [self setIndents:self.emailTextField];
    
    RAC(self.viewModel, nameStr) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel, passwordStr) = self.passwordTextField.rac_textSignal;
    RAC(self.viewModel, emailStr) = self.emailTextField.rac_textSignal;
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
         
         [self.usernameTextField resignFirstResponder];
         
         
     }];


}
-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
     [[self view] endEditing:YES];
    [self.emailTextField resignFirstResponder];
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
    int off = 0;
    if(textField==self.emailTextField){
        off = Y_OFFSET+50;
    }
    else if(textField==self.passwordTextField){
        off = Y_OFFSET+100;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.mainScroll setContentOffset:CGPointMake(0, self.mainScroll.frame.origin.y+off) animated:YES];
       
    }];
    
    
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
}
-(void)setActionFlag
{

    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"enterAction"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)addGestures
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];

}
- (void)viewDidLoad {
    
    [self setActionFlag];
    
    [super viewDidLoad];
    
    [self.mainScroll setContentSize:CGSizeMake(self.view.frame.size.width,650)];
    self.viewModel = [[JoinViewModel alloc] init];
    self.signInFailureText.hidden = YES;
    
    [self bindViewModel];
    
    [self addGestures];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)moveNext
{

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
