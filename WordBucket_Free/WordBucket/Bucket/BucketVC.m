//
//  BucketVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "BucketVC.h"
#import "WordListVC.h"
#import "WikipediaHelper.h"
#import "SearchVC.h"
#import "TestVC.h"
#import "CommunityVC.h"
#import "MoreVC.h"
#import "OfflineWishlistVC.h"
@interface BucketVC ()

@end

@implementation BucketVC
@synthesize btnGreen,btnOrange,btnRed,btnWhite,profilePic,userName,txtSearch,btnSearch,btnCommunity,btnLearn,btnMore,toolbar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Bucket", @"Bucket");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dbHelper = [[DBHelper alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    
    
//    barSearch.autocapitalizationType = UITextAutocorrectionTypeYes;
    
}
-(void) viewWillAppear:(BOOL)animated
{
    txtSearch.text = @"";
    [self.navigationController.navigationBar setHidden:YES];
    [btnWhite setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"White"]] forState:UIControlStateNormal];
    [btnGreen setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Green"]] forState:UIControlStateNormal];
    [btnOrange setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Orange"]] forState:UIControlStateNormal];
    [btnRed setTitle:[NSString stringWithFormat:@"%d",[[Common sharedInstance] getWordCount:@"Red"]] forState:UIControlStateNormal];
    [btnWhite setUserInteractionEnabled:YES];
    [btnGreen setUserInteractionEnabled:YES];
    [btnOrange setUserInteractionEnabled:YES];
    [btnRed setUserInteractionEnabled:YES];
    
    if([btnWhite.titleLabel.text intValue]==0)
        [btnWhite setUserInteractionEnabled:NO];
    if([btnGreen.titleLabel.text intValue]==0)
        [btnGreen setUserInteractionEnabled:NO];
    if([btnOrange.titleLabel.text intValue]==0)
        [btnOrange setUserInteractionEnabled:NO];
    if([btnRed.titleLabel.text intValue]==0)
        [btnRed setUserInteractionEnabled:NO];
    
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfileId"])
//        self.profilePic.profileID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfileId"];
    
    UIImage *imgProfile = [[Common sharedInstance] getImageWithName:@"avatar.png"];
    if(imgProfile)
        profilePic.image = imgProfile;
  
//    profilePic = [[Common sharedInstance] rotateImage:profilePic angle:(M_PI / 4)];
    NSString *userNameString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    
    NSLog(@"userName is %@ %@ ",userNameString,[NSUserDefaults standardUserDefaults]);
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"])
        userName.text = [NSString stringWithFormat:@"%@'s Word Bucket",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]];
    else
        userName.text = @"Word Bucket";
   
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
-(IBAction)whiteBucket:(id)sender
{
    [self bucketAccess:@"White"];
}
-(IBAction)greenBucket:(id)sender
{
    [self bucketAccess:@"Green"];
}
-(IBAction) orangeBucket:(id)sender
{
    [self bucketAccess:@"Orange"];
}
-(IBAction) redBucket:(id)sender
{
    [self bucketAccess:@"Red"];
}

-(IBAction)searchClicked:(id)sender
{
    NSLog(@"search button clicked");
    NSString *strCurrentLang = [UITextInputMode currentInputMode].primaryLanguage;
    NSLog(@"Current language%@",strCurrentLang);
    NSArray *arrLang = [strCurrentLang componentsSeparatedByString:@"-"];
    if([arrLang count] > 0)
    {
        NSString *strNativeLang = [[[NSUserDefaults standardUserDefaults] valueForKey:@"nativeLanguageCode"] substringToIndex:2];
        NSString *strTargetLang = [[[NSUserDefaults standardUserDefaults] valueForKey:@"targetLanguageCode"] substringToIndex:2];
        if([[arrLang objectAtIndex:0] isEqualToString:strTargetLang])
        {
            [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"nativeLanguageCode"] forKey:@"targetLanguageCode"];
            [[NSUserDefaults standardUserDefaults] setValue:[arrLang objectAtIndex:0] forKey:@"nativeLanguageCode"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:strNativeLang forKey:@"nativeLanguageCode"];
            [[NSUserDefaults standardUserDefaults] setValue:strTargetLang forKey:@"targetLanguageCode"];
        }
    }
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nativeLanguageCode"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"targetLanguageCode"]);
//    strCurrentLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"nativeLanguageCode"];
    [txtSearch resignFirstResponder];
    
    UITextChecker *checker = [[UITextChecker alloc] init];
    
    NSRange checkRange = NSMakeRange(0, txtSearch.text.length);
    
    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:txtSearch.text
                                                               range:checkRange
                                                          startingAt:checkRange.location
                                                                wrap:NO
                                                            language:strCurrentLang];
    
    NSArray *arrGuessed = [checker guessesForWordRange:misspelledRange inString:txtSearch.text language:strCurrentLang];
    if([arrGuessed count]>0)
        txtSearch.text = [txtSearch.text stringByReplacingCharactersInRange:misspelledRange withString:[arrGuessed objectAtIndex:0]];
    
    if([[Common sharedInstance] checkInternetConnection])
    {
        SearchVC *search = [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:[NSBundle mainBundle]];
        search.strSearchWord = txtSearch.text;
        [self.navigationController pushViewController:search animated:YES];
    }
    else
    {
        OfflineWishlistVC *list = [[OfflineWishlistVC alloc] initWithNibName:@"OfflineWishlistVC" bundle:[NSBundle mainBundle]];
        list.strSearchWord = txtSearch.text;
        [self.navigationController pushViewController:list animated:YES];
    }
    
}



//- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
//    if([searchText length]==0) {
//        
//        
//        // user tapped the 'clear' button
//        
//        // do whatever I want to happen when the user clears the search...
//       barSearch.text = @"";
//        return;
//    }
//    else
//    {
//        
//    }
//}

-(IBAction)tabBarClicked:(id)sender
{
    UIButton *btnTab = (UIButton*)sender;
    [[NSUserDefaults standardUserDefaults] setInteger:btnTab.tag forKey:@"tabIndex"];
    UIViewController *communityVC = [[CommunityVC alloc] initWithNibName:@"CommunityVC" bundle:nil];
    UINavigationController *navcommunityVC = [[UINavigationController alloc] initWithRootViewController:communityVC];
    
    NSString *nib = nil;
    NSString *moreNib = nil;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"iPhone5"]){
        nib = @"TestVC";
        moreNib = @"MoreVC";
    } else {
        nib = @"TestVCiPhone4";
        moreNib = @"MoreVCiPhone4";
    }
    UIViewController *testVC = [[TestVC alloc] initWithNibName:nib bundle:nil];
    UINavigationController *navTestVC = [[UINavigationController alloc] initWithRootViewController:testVC];
    UIViewController *moreVC = [[MoreVC alloc] initWithNibName:moreNib bundle:nil];
    UINavigationController *navMoreVC = [[UINavigationController alloc] initWithRootViewController:moreVC];
    //    self.tabBarController = [[UITabBarController alloc] init];
    //    self.tabBarController.viewControllers = @[navBucketVC, navcommunityVC, navTestVC,navMoreVC];
    //    self.window.rootViewController = self.tabBarController;
    //    [self.window makeKeyAndVisible];
    
    
    NSArray *ctrlArr = [NSArray arrayWithObjects:navcommunityVC,navTestVC,navMoreVC,nil];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tabBar_community@2x.png"] forKey:@"Default"];
    [imgDic setObject:[UIImage imageNamed:@"tabBar_communityPressed@2x.png"] forKey:@"Highlighted"];
    [imgDic setObject:[UIImage imageNamed:@"tabBar_communityPressed@2x.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"tabBar_learn@2x.png"] forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"tabBar_learnPressed@2x.png"] forKey:@"Highlighted"];
    [imgDic2 setObject:[UIImage imageNamed:@"tabBar_learnPressed@2x.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"tabBar_more@2x.png"] forKey:@"Default"];
    [imgDic3 setObject:[UIImage imageNamed:@"tabBar_morePressed@2x.png"] forKey:@"Highlighted"];
    [imgDic3 setObject:[UIImage imageNamed:@"tabBar_morePressed@2x.png"] forKey:@"Seleted"];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,nil];
    
    CMTabBarController *leveyTabBarController = [[CMTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    //[leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarbg.png"]];
    //[leveyTabBarController setTabBarTransparent:YES];
//    leveyTabBarController.selectedIndex = btnTab.tag;
    
    [self.navigationController pushViewController:leveyTabBarController animated:NO];
//    [leveyTabBarController displayViewAtIndex:btnTab.tag];
//     [leveyTabBarController setSelectedIndex:btnTab.tag];
//     [self.view addSubview:leveyTabBarController.view];
    
}
#pragma mark - Text field delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    //add toolbar
    
    if(toolbar)
        [toolbar removeFromSuperview];
    toolbar = [[Common sharedInstance] returnToolbar:textField.tag frame:CGRectMake(0.0,
                                                                                    200,
                                                                                    320,
                                                                                    44)];
    //    toolbar.frame = CGRectMake(0.0,156, 320,44);
    toolbar.tag = 0;
    [Common sharedInstance].pickerDelegate = self;
    [self.view addSubview:toolbar];
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
}
#pragma mark - Toolbar delegate
-(void) closePicker:(NSInteger)tag
{
    [toolbar removeFromSuperview];
    [txtSearch resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(toolbar)
        [toolbar removeFromSuperview];
}

@end
