//
//  InfoViewC.m
//  WordBucket
//
//  Created by ashish on 3/12/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "InfoViewC.h"

@interface InfoViewC ()

@end

@implementation InfoViewC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if (_isFromLogin) {
        [_crossButton setHidden:YES];
    }
    
    [self setLocalizedString];
    [_scrollView setContentSize:CGSizeMake(320, 525)];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Word Bucket: Hows it works";
}



- (BOOL)insertMultipleRowQuerywithArray:(NSMutableArray*)freeVersionArray
{
    
    BOOL isSuccess = NO;
    
    NSString *multipleRowData = @"insert into tbl_Dictionary (targetWord,nativeWord,bucketColor,nativeLanguage,targetLanguage,action,userLevel,sense,POS,dateOfTest) ";
    NSString *strUnion = @"";
    //NSDate *currentDate = [NSDate date];
    for(int i=0;i<[freeVersionArray count];i++)
    {
        
        //NSArray *arrLan = [[arrWords objectAtIndex:i] componentsSeparatedByString:@"/|"];
        NSMutableDictionary *dic = [freeVersionArray objectAtIndex:i];
        strUnion = [strUnion stringByAppendingString:[NSString stringWithFormat:@"select \"%@\" as targetWord,\"%@\" as nativeWord, '%@' as bucketColor, '%@' as nativeLanguage, '%@' as targetLanguage, '%@' as action, '%@' as userLevel, '%@' as sense, '%@' as POS, '%@' as dateOfTest union ",[dic objectForKey:kTargetWord],[dic objectForKey:kNativeWord],[dic objectForKey:kBucketColor],[UserDefaluts valueForKey:@"nativeLanguageCode"],[UserDefaluts valueForKey:kTargetLangCode],[dic objectForKey:kAction],[UserDefaluts objectForKey:kUserLevel],[dic objectForKey:ksense],[dic objectForKey:kPOS],[dic objectForKey:kdateOfTest]]];
        
    }
    
    if([strUnion length]>0)
        multipleRowData = [multipleRowData stringByAppendingString:[strUnion substringToIndex:[strUnion length]-6]];
    
    NSString *lastIdValue =  [[DBHelper sharedDbInstance] insertMultipleRows:multipleRowData];
    
    
    // Check wheater data is successfully inserted or not ..
    if ([lastIdValue integerValue] > 0)
        isSuccess = YES;
    
    return isSuccess;
    
}

- (void)setLocalizedString
{
    [_titileLabel setText:NSLocalizedString(@"Your dictionary, your notebook and your language teacher!", nil)];
    [_searchLabel setText:NSLocalizedString(@"Find translation for the words and meanings you're learning.", nil)];
    [_saveLabel setText:NSLocalizedString(@"Never lose words again by saving to your personal Word Bucket. You can even add your own translations.", nil)];
    [_playLabel setText:NSLocalizedString(@"Learn words with fun tests and games. To practise move your new words (and the 50 starter words you've already got) from White to Orange to Green.", nil)];
    [_carefullLabel setText:NSLocalizedString(@"Be careful, wrong answers go to Red to start again!", nil)];
    [_btnFindAndLear setTitle:NSLocalizedString(@"FIND AND LEARN NEW WORDS", nil) forState:UIControlStateNormal];
    [_btnFindAndLear setTitle:NSLocalizedString(@"FIND AND LEARN NEW WORDS", nil) forState:UIControlStateSelected];
    [_btnFindAndLear setTitle:NSLocalizedString(@"FIND AND LEARN NEW WORDS", nil) forState:UIControlStateHighlighted];
    [_searchTitleLabel setText:NSLocalizedString(@"SEARCH", nil)];
    [_saveTitleLabel setText:NSLocalizedString(@"SAVE", nil)];
    [_playTitleLabel setText:NSLocalizedString(@"PLAY", nil)];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Common hideTabBar:self.tabBarController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Common showTabBar:self.tabBarController];
}

- (IBAction)crossButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)findNewWordButtonClicked:(id)sender {
    
    
    
    if (_isFromLogin) {
        
        [SharedAppDelegate showTabBar];
        
    } else {
    
        for(UIView *view in self.tabBarController.tabBar.subviews) {
            if([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        [self.tabBarController setSelectedIndex:1];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"learnsel.png"]];
        [self.tabBarController.tabBar insertSubview:imgView atIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
        [self.navigationController popViewControllerAnimated:NO];
    }
}


- (void)viewDidUnload {
    [self setCrossButton:nil];
    [self setScrollView:nil];
    [self setTitileLabel:nil];
    [self setSearchLabel:nil];
    [self setSaveLabel:nil];
    [self setPlayLabel:nil];
    [self setCarefullLabel:nil];
    [self setSearchTitleLabel:nil];
    [self setSaveTitleLabel:nil];
    [self setPlayTitleLabel:nil];
    [self setBtnFindAndLear:nil];
    [super viewDidUnload];
}
@end
