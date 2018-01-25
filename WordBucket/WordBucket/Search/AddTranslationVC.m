//
//  AddTranslationVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 1/24/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "AddTranslationVC.h"

@interface AddTranslationVC ()

@end

@implementation AddTranslationVC
@synthesize btnAddTrans,btnShare,txtTranslation,strSearchedWord;
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
    [_titleLabel setText:NSLocalizedString(@"Add Your Own Meaning", nil)];
    //[self.txtSearchWord setText:NSLocalizedString(@"Searched Word", nil)];
    [_yourTranslatioinLbl setText:NSLocalizedString(@"Your Translation:", nil)];
    [self.txtTranslation setPlaceholder:NSLocalizedString(@"Type your translation", nil)];
    [self.btnShare setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    [self.btnShare.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.btnShare setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 2)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _txtSearchWord.text = strSearchedWord;
    self.txtTranslation.horizontalPadding=10;
    [self setLocalizedString];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Add Translation Screen";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)share:(id)sender
{
    
    if (self.txtTranslation.text.length>0) {
        //[[Common sharedInstance] popUpActionSheet:self.view buttonTitle:[NSArray arrayWithObjects:@"Share on Facebook",@"Share on Twitter",@"Email",@"Cancel", nil] desctructiveButtonIndex:-1];
        //[Common sharedInstance].delegate = self;
        [self.txtTranslation resignFirstResponder];
       UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share on Facebook", nil),NSLocalizedString(@"Share on Twitter", nil),NSLocalizedString(@"Email", nil),NSLocalizedString(@"Cancel", nil), nil];
        [actionSheet setTag:10];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    } else  {
        [Common showAlertView:nil message:NSLocalizedString(@"Please enter your translation", nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    }
    
}
-(IBAction)addTranslation:(id)sender
{
    
    if(![sender isSelected]){
        if(![txtTranslation.text isEqualToString:@""])
        {
            NSString *targetLanCode = [UserDefaluts objectForKey:kTargetLangCode];
            NSString *nativeLanCode = [UserDefaluts objectForKey:kNativeLangCode];
            NSString *nativeWordStr = SharedAppDelegate.isNativeSrchLang ? txtTranslation.text : _txtSearchWord.text;
            NSString *targetWordStr = SharedAppDelegate.isNativeSrchLang ? _txtSearchWord.text : txtTranslation.text;
            
            [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest, sense, POS" fieldValue:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"",targetWordStr,nativeWordStr,@"White",nativeLanCode,targetLanCode,@"Saved",[UserDefaluts objectForKey:@"userLevel"],[NSDate date],@"",@""]];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:NSLocalizedString(@"%@ added to your Word Bucket", nil),self.txtTranslation.text] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alertView show];
            
            [sender setSelected:YES];
            //[self.navigationController popViewControllerAnimated:YES];
            [self.txtTranslation resignFirstResponder];

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Please enter your meaning", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    } 
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --  ActionSheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *targetWordStr = SharedAppDelegate.isNativeSrchLang ? _txtSearchWord.text : txtTranslation.text;
        
    switch (buttonIndex) {
        case 0:
        {
            // Share on facebook
            NSMutableString *message =[NSString stringWithFormat:NSLocalizedString(@"Do you know this %@ word? \"%@\" I just found it in Word Bucket. FREE to download for iOS and Android.", nil),targetWordStr];
            [[Common sharedInstance] postStatusUpdateClick:self message:message withUrl:[NSURL URLWithString:@"http://www.wordbucket.com"]];
        }
            break;
        case 1:
        {
            // Share on twitter
            NSString *message =[NSString stringWithFormat:NSLocalizedString(@"Just found the word \"%@\" in @Wordbucket. Great app to find and learn new words.", nil),targetWordStr];
            [[Common sharedInstance] sendEasyTweet:self text:message withUrl:[NSURL URLWithString:@"http://wordbucket.com"]];
        }
            
            break;
        case 2:
        {
            // Email
            //NSString *firstpartStr = [NSString stringWithFormat:NSLocalizedString(@"Do you know this %@ word? \"%@\" I just found it in", nil),[Common getTargetLanguage],targetWordStr];
            //NSString *secondpartStr = [NSString stringWithFormat:NSLocalizedString(@"Great app to find and learn new words & FREE to download for iOS and Android.", nil)];
            //NSMutableString *message =[NSMutableString stringWithFormat:@"<html><body>%@ <a href=\"http://www.wordbucket.com\">Word Bucket</a>. %@</body></html>",firstpartStr,secondpartStr];
            
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Email Do you know this %@ word? \"%@\" I just found it in Word Bucket. FREE to download for iOS and Android.", nil),targetWordStr];
            [[Common sharedInstance] showMailPicker:self subject:NSLocalizedString(@"Word Bucket - find and learn new words", nil) emailBody:message];
        } break;
            
        default:
            break;
    }
}
#pragma mark - Text field delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setTxtSearchWord:nil];
    [self setTitleLabel:nil];
    [self setYourTranslatioinLbl:nil];
    [super viewDidUnload];
}
@end
