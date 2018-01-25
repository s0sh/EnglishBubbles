//
//  SendAWordVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 12/28/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "SendAWordVC.h"
#import "WordListVC.h"
#import "WikipediaHelper.h"
#import "SearchVC.h"
#import "OfflineWishlistVC.h"

@interface SendAWordVC ()

@end

@implementation SendAWordVC



@synthesize btnGreen,btnOrange,btnRed,btnWhite;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self.title = NSLocalizedString(@"Type the Word", @"Type the Word");
    }
    return self;
}

- (void)setLocalizedSgring
{
    
    [self.txtSearch setPlaceholder:NSLocalizedString(@"Search Word", nil)];
    [_lblNew setText:NSLocalizedString(@"New", nil)];
    [_lblLearned setText:NSLocalizedString(@"Learned", nil)];
    [_lblLearning setText:NSLocalizedString(@"Learning", nil)];
    [_lblMistakes setText:NSLocalizedString(@"Mistakes", nil)];
    [_lblExploreBucket setText:NSLocalizedString(@"Explore Bucket", nil)];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dbHelper = [[DBHelper alloc] init];
    [self setLocalizedSgring];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Send a Word Screen";
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [btnWhite setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"White"]] forState:UIControlStateNormal];
    [btnGreen setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Green"]] forState:UIControlStateNormal];
    [btnOrange setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Orange"]] forState:UIControlStateNormal];
    [btnRed setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Red"]] forState:UIControlStateNormal];
    [btnWhite setUserInteractionEnabled:YES];
    [btnGreen setUserInteractionEnabled:YES];
    [btnOrange setUserInteractionEnabled:YES];
    [btnRed setUserInteractionEnabled:YES];
    
    
    /*
    if([btnWhite.titleLabel.text intValue]==0)
        [btnWhite setUserInteractionEnabled:NO];
    if([btnGreen.titleLabel.text intValue]==0)
        [btnGreen setUserInteractionEnabled:NO];
    if([btnOrange.titleLabel.text intValue]==0)
        [btnOrange setUserInteractionEnabled:NO];
    if([btnRed.titleLabel.text intValue]==0)
        [btnRed setUserInteractionEnabled:NO];
    */
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) bucketAccess:(NSString *) bucketColor
{
    WordListVC *wordListVC = [[WordListVC alloc] initWithNibName:@"WordListVC" bundle:[NSBundle mainBundle]];
    wordListVC.bucketColor = bucketColor;
    [self.navigationController pushViewController:wordListVC animated:YES];
}

- (void)showAlertWithMessage:(NSString*)message
{
    [Common showAlertView:nil message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
}
-(IBAction)whiteBucket:(id)sender
{
    if ([self.btnWhite.titleLabel.text integerValue] > 0) {
        
        [self bucketAccess:@"White"];
        
    } else {
        
        NSString *message = NSLocalizedString(@"You have no words in your White Bucket. Search and save more new words!", nil);
        [self showAlertWithMessage:message];
    }
        
}

-(IBAction)greenBucket:(id)sender
{
    if ([self.btnGreen.titleLabel.text integerValue] > 0) {
        
        [self bucketAccess:@"Green"];
        
    } else {
        
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You have no words in your Green Bucket. To add words to Green you must do the Orange Bucket tests.", nil)];
        [self showAlertWithMessage:message];
    }

}
-(IBAction) orangeBucket:(id)sender
{
    
    if ([self.btnOrange.titleLabel.text integerValue] > 0) {
        
        [self bucketAccess:@"Orange"];
        
    } else {
        
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You have no words in your Orange Bucket. To add words to Orange you must do the White Bucket tests.", nil)];
        [self showAlertWithMessage:message];
    }
    
}
-(IBAction) redBucket:(id)sender
{
    if ([self.btnRed.titleLabel.text integerValue] > 0) {
        
        [self bucketAccess:@"Red"];
        
    } else {
        
        NSString *message = NSLocalizedString(@"Good work! You have no words in your Red Bucket. Only words that you get wrong in the other colours go here.", nil);
        [self showAlertWithMessage:message];
    }
    
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma Search Bar delegate
//called when search result button is clicked
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search button clicked");
    [barSearch resignFirstResponder];
    SearchVC *search = [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:[NSBundle mainBundle]];
    search.strSearchWord = searchBar.text;
    [self.navigationController pushViewController:search animated:YES];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	NSLog(@"cancel button clicked");
    [barSearch resignFirstResponder];
    barSearch.text = @"";
}
- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
    if([searchText length]==0) {
        // user tapped the 'clear' button
        
        // do whatever I want to happen when the user clears the search...
        barSearch.text = @"";
    }
}*/


- (IBAction)searchClicked:(id)sender {
    
    /*
     NSLog(@"search button clicked");
     NSString *strCurrentLang = [UITextInputMode currentInputMode].primaryLanguage;
     NSLog(@"Current language%@",strCurrentLang);
     NSLog(@"native and targ lang is %@ %@",[UserDefaluts valueForKey:kNativeLangCode],[UserDefaluts valueForKey:kTargetLangCode]);
     NSArray *arrLang = [strCurrentLang componentsSeparatedByString:@"-"];
     SharedAppDelegate.isNativeSrchLang = YES;
     
     SharedAppDelegate.isNativeSrchLang = [self isDictionaryWord:_txtSearch.text];
     
     if (SharedAppDelegate.isNativeSrchLang) {
     
     NSLog(@"IN CURRENT LANGAGE");
     } else {
     NSLog(@"IN TARGET LANGUAGE");
     }
     
     
     
     
     if([arrLang count] > 0)
     {
     NSString *strNativeLang = [[UserDefaluts valueForKey:@"nativeLanguageCode"] substringToIndex:2];
     NSString *strTargetLang = [[UserDefaluts valueForKey:@"targetLanguageCode"] substringToIndex:2];
     if([[arrLang objectAtIndex:0] isEqualToString:strTargetLang])
     {
     SharedAppDelegate.isNativeSrchLang = NO;
     
     }
     else
     {
     SharedAppDelegate.isNativeSrchLang = YES;
     
     }
     }
     
     //NSLog(@"%@",[UserDefaluts objectForKey:@"nativeLanguageCode"]);
     //NSLog(@"%@",[UserDefaluts objectForKey:@"targetLanguageCode"]);
     //    strCurrentLang = [UserDefaluts objectForKey:@"nativeLanguageCode"];
     */
    
    
    NSString *spellCLangCode = SharedAppDelegate.isNativeSrchLang ? [UserDefaluts objectForKey:kTargetLangCode] : [UserDefaluts objectForKey:kNativeLangCode];
    UITextChecker *checker = [[UITextChecker alloc] init];
    
    NSRange checkRange = NSMakeRange(0, _txtSearch.text.length);
    
    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:_txtSearch.text
                                                               range:checkRange
                                                          startingAt:checkRange.location
                                                                wrap:NO
                                                            language:spellCLangCode];
    
    NSArray *arrGuessed = [checker guessesForWordRange:misspelledRange inString:_txtSearch.text language:spellCLangCode];
    if([arrGuessed count]>0)
        _txtSearch.text = [_txtSearch.text stringByReplacingCharactersInRange:misspelledRange withString:[arrGuessed objectAtIndex:0]];
    
    
    if (_txtSearch.text.length > 0) {
        
        
        [_txtSearch resignFirstResponder];
        if([[Common sharedInstance] checkInternetConnection])
        {
            NSString *nib = SharedAppDelegate.isPhone5 ? @"SearchVC" : @"SearchVCiPhone4";
            SearchVC *search = [[SearchVC alloc] initWithNibName:nib bundle:[NSBundle mainBundle]];
            search.strSearchWord = _txtSearch.text;
            [self.navigationController pushViewController:search animated:YES];
        }
        else
        {
            NSString *nib = SharedAppDelegate.isPhone5 ? @"OfflineWishlistVC" : @"OfflineWishlistVCiPhone4";
            OfflineWishlistVC *list = [[OfflineWishlistVC alloc] initWithNibName:nib bundle:[NSBundle mainBundle]];
            list.strSearchWord = _txtSearch.text;
            [self.navigationController pushViewController:list animated:YES];
        }
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please enter any word.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - Text field delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
}
#pragma mark - Toolbar delegate
-(void) closePicker:(NSInteger)tag
{
    [_txtSearch resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    //[self searchClicked:nil];
    [_txtSearch setText:@""];
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidUnload {
    [self setTxtSearch:nil];
    [self setLblExploreBucket:nil];
    [self setLblLearning:nil];
    [self setLblMistakes:nil];
    [self setLblNew:nil];
    [self setLblLearned:nil];
    [super viewDidUnload];
}
@end
