//
//  SettingsViewC.m
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "SettingsViewC.h"

@interface SettingsViewC ()

@end

@implementation SettingsViewC   

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
    [_settingsLbl setText:NSLocalizedString(@"Settings", nil)];
    NSString *btnDefalutTlt = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Default Test Words", nil)];
    [_btnDefaultTestWord setTitle:btnDefalutTlt forState:UIControlStateNormal];
    [_totalWordLbl setText:NSLocalizedString(@"Default Test Words", nil)];
    [_soundSettingLbl setText:NSLocalizedString(@"Sound settings", nil)];
    [_updateLbl setText:NSLocalizedString(@"Update", nil)];
    [_btnDefaultTestWord.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_userNameTxtField setPlaceholder:NSLocalizedString(@"Place User Name Here", nil)];
    [_saveBarButton setTitle:NSLocalizedString(@"Save", nil)];
    [_onLabel setText:NSLocalizedString(@"On", nil)];
    [_offLaebl setText:NSLocalizedString(@"Off", nil)];
    
}

- (void)showOnLabel:(BOOL)isON
{
    if (isON) {
        [_onLabel setHidden:NO];
        [_offLaebl setHidden:YES];
    } else {
        [_onLabel setHidden:YES];
        [_offLaebl setHidden:NO];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLocalizedString];
    
    // Set images on UISlider
    UIImage *img = [[UIImage alloc] init];
    [_wordSlider setThumbImage:GetImage(@"sliderHandle") forState:UIControlStateNormal];
    [_wordSlider setThumbImage:GetImage(@"sliderHandlePressed") forState:UIControlStateHighlighted];
    [_wordSlider setMaximumTrackImage:img forState:UIControlStateNormal];
    [_wordSlider setMinimumTrackImage:img forState:UIControlStateNormal];
    [_wordSlider setMinimumValue:10.0];
    [_wordSlider setMaximumValue:25.0];
    img=nil;
    
    UIImage *imgProfile = [[Common sharedInstance] getImageWithName:@"avatar.png"];
    if(imgProfile)
        _imgView.image = imgProfile;
    _imgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _imgView.transform = CGAffineTransformMakeRotation(degreesToRadians(-15));
    _imgContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _imgContainerView.transform = CGAffineTransformMakeRotation(degreesToRadians(-15));
    
    
    // Set saved value to word slider if any
    if ([UserDefaluts objectForKey:kTotalWords]) {
        [_wordSlider setValue:[[UserDefaluts objectForKey:kTotalWords] floatValue]];
        _totalWords = [[UserDefaluts objectForKey:kTotalWords] integerValue];
        [_wordLabel setText:[NSString stringWithFormat:@"%d",_totalWords]];
    }
    
    if ([[UserDefaluts objectForKey:kisSoundOn] boolValue]  || (![UserDefaluts objectForKey:kisSoundOn]))
    {
        [_soundButton setSelected:YES];
        [self showOnLabel:YES];
    }
    else {
        [_soundButton setSelected:NO];
        [self showOnLabel:NO];
    }
    
    NSString *userName = [UserDefaluts objectForKey:kUserName];
    if(userName.length>0)
    [_userNameTxtField setText:[UserDefaluts objectForKey:kUserName]];
    [_userNameTxtField setEnabled:NO];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Settings Screen";
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Button Action

- (IBAction)testDefaultButtonClicked:(id)sender {
    
    [_wordSlider setValue:10.0];
    _totalWords = 10;
    [_wordLabel setText:[NSString stringWithFormat:@"10"]];
    [UserDefaluts setFloat:_totalWords forKey:kTotalWords];
    [UserDefaluts synchronize];
    
}

- (IBAction)updateButtonClicked:(id)sender {
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@",kWBPaidAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your setting has been updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    alert=nil;
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

- (IBAction)soundSliderValueChanged:(id)sender {
    
    _soundButton.selected = !_soundButton.selected;
    [UserDefaluts setBool:_soundButton.selected forKey:kisSoundOn];
    [UserDefaluts synchronize];
    if (_soundButton.selected) 
        [self showOnLabel:YES];
    else
        [self showOnLabel:NO];
    
}

// Slider value changed

- (IBAction)syncButtonClicked:(id)sender {
    
    NSMutableArray *allArray = [[NSMutableArray alloc] initWithArray:[[DBHelper sharedDbInstance] getAllValuesFromDictionaryTable:[NSString stringWithFormat:@"select * from tbl_Dictionary "]]];
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths1 objectAtIndex:0];
	NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:kWordPlist];
	NSLog(@"path is here %@",path);
	
	
	//NSMutableArray *newArry = [[NSMutableArray alloc] initWithContentsOfFile:path];
	//[newArry addObject:myDict];
	
	[allArray writeToFile:path atomically:YES];
    
    NSMutableArray *newArry = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSLog(@"new array is %@",newArry);
   
}


- (IBAction)wordSliderValueChanged:(id)sender {
    
    
    if (_wordSlider.value >= 10.0 && _wordSlider.value < 15.0) {
        _totalWords = 10;
        
    } else if (_wordSlider.value >= 15.0 && _wordSlider.value < 20.0) {
        _totalWords = 15;
        
    } else if (_wordSlider.value >= 20.0 && _wordSlider.value < 25.0) {
        _totalWords = 20;
        
    } else {
        _totalWords = 25;
        
    }
    SharedAppDelegate.totolQustCount = _totalWords;
    [_wordLabel setText:[NSString stringWithFormat:@"%d",_totalWords]];
    [UserDefaluts setFloat:_totalWords forKey:kTotalWords];
    [UserDefaluts synchronize];

}

- (IBAction)corssClicked:(id)sender {
    
    [_userNameTxtField setText:@""];
    if (!_userNameTxtField.isFirstResponder) {
        [_userNameTxtField setEnabled:YES];
        [_userNameTxtField becomeFirstResponder];
    }
}

- (IBAction)saveClicked:(id)sender {
    
    if (_userNameTxtField.text.length>0) {
        
        [UserDefaluts setObject:_userNameTxtField.text forKey:kUserName];
        [UserDefaluts synchronize];
        [_userNameTxtField resignFirstResponder];
        [_userNameTxtField setEnabled:NO];
        
    } else {
        
        [Common showAlertView:nil message:NSLocalizedString(@"Please enter user name.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    }
}

#pragma mark - Text field delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [textField setInputAccessoryView:_toolBar];
    return YES;
}


-(void) textFieldDidEndEditing:(UITextField *)textField
{
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    //[_txtSearch setText:@""];
    [textField resignFirstResponder];
    [_userNameTxtField setText:[UserDefaluts objectForKey:kUserName]];
    [UserDefaluts synchronize];
    return YES;
}

- (IBAction)cameraButtonClicked:(id)sender {
    
    if(_userNameTxtField.isFirstResponder){
        [_userNameTxtField resignFirstResponder];
        [_userNameTxtField setEnabled:NO];
    }
    
    if (_picker)
        _picker=nil;
    _picker = [[UIImagePickerController alloc] init];
    [_picker setDelegate:self];
    [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [_picker setAllowsEditing:NO];
    [self presentViewController:_picker animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma UIImagePickerController delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	if(![self isViewLoaded])
		[self view];
    
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *avatar = [Common generatePhotoThumbnail:image];
    
    NSString  *pngPath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:@"avatar.png"];
	[UIImagePNGRepresentation(avatar) writeToFile:pngPath atomically:YES];
    self.imgView.image = avatar;
    [self.imgView setContentMode:UIViewContentModeScaleToFill];
    [self dismissModalViewControllerAnimated:YES];
}



- (void)viewDidUnload {
    
    [self setWordSlider:nil];
    [self setWordLabel:nil];
    [self setSoundButton:nil];
    [self setUserNameTxtField:nil];
    [self setToolBar:nil];
    [self setBtnDefaultTestWord:nil];
    [self setSoundSettingLbl:nil];
    [self setUpdateLbl:nil];
    [self setTotalWordLbl:nil];
    [self setSettingsLbl:nil];
    [self setSaveBarButton:nil];
    [self setOffLaebl:nil];
    [self setOnLabel:nil];
    [self setImgContainerView:nil];
    [self setImgView:nil];
    [super viewDidUnload];
}


@end
