//
//  TabBarViewC.m
//  WordBucket
//
//  Created by ashish on 2/12/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "TabBarViewC.h"
#import "TestVC.h"

@interface TabBarViewC ()

@end

@implementation TabBarViewC

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
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    
    
    /*
    UIImage *tabBackground = [[UIImage imageNamed:@"tabBar.png"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    // Set background for all UITabBars
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    // Set background for only this UITabBar
    [[_tabBar tabBar] setBackgroundImage:tabBackground];
    //[[_tabBar tabBar] setSelectedImageTintColor:[UIColor clearColor]];
    [[_tabBar tabBar] setFrame:CGRectMake(0, 0, 320, 49)];
    */
    
    //[[_tabBar tabBar] setFrame:CGRectMake(0, 460-55, 320, 49)];
    NSLog(@"%@",self.tabBar.tabBar.subviews);
    NSLog(@"%@",[[self.tabBar.tabBar.subviews objectAtIndex:0] subviews]);
    
    for(UIView *view in self.tabBar.tabBar.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"learn.png"]];
    [self.tabBar.tabBar insertSubview:imgView atIndex:0];
    [self.tabBar.tabBar setSelectedImageTintColor:[UIColor clearColor]];
    
    // Set empty image to avoid any selection image
    UIImage *emptyImage = [[UIImage alloc] init];
    [self.tabBar.tabBar setSelectionIndicatorImage:emptyImage];
    [self setTabBarFrame];
    
    UITabBarItem *communityItem = [[[self.tabBar tabBar] items] objectAtIndex:0];
    [communityItem setTitle:NSLocalizedString(@"Community", nil)];
    communityItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    self.learnBarButton = [[[self.tabBar tabBar] items] objectAtIndex:1];
    [self.learnBarButton setTitle:NSLocalizedString(@"Learn", nil)];
    self.learnBarButton.titlePositionAdjustment = UIOffsetMake(0, -7);
    
    
    
    
    
    [self.learnBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0], UITextAttributeTextColor,[UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], UITextAttributeFont,nil]
                                       forState:UIControlStateSelected];
    
    [self.learnBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0], UITextAttributeTextColor,[UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], UITextAttributeFont,nil]
                                       forState:UIControlStateNormal];
    
    
    
    UITabBarItem *moreItem = [[[self.tabBar tabBar] items] objectAtIndex:2];
    [moreItem setTitle:NSLocalizedString(@"More", nil)];
    moreItem.titlePositionAdjustment = UIOffsetMake(1, -2);
    
    
    
     // iCloud block
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReloaded:)
                                                 name:@"newWordAdded" object:nil];
    
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: Load document...
        [self loadDocument];
    } else {
        NSLog(@"No iCloud access");
        if (![UserDefaluts boolForKey:@"iClouldAlertWarning"]) {
            
            NSString *iCloudMsg = NSLocalizedString(@"Thanks for downloading Word Bucket. To get the best from Word Bucket we recommend you set up iCloud in your iPhone settings to store all your new words online.", nil);
            
            [Common showAlertView:nil message:iCloudMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [UserDefaluts setBool:YES forKey:@"iClouldAlertWarning"];
            [UserDefaluts synchronize];
        }
    }

    
    //[self.tabBar showiAds];
}

- (void)setTabBarFrame
{
    NSInteger yValue = SharedAppDelegate.isPhone5 ? 511 : 423;
    for(UIView *view in self.tabBar.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, yValue, view.frame.size.width,
                                      view.frame.size.height+8)];
            
        }
        else
        {
            //[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y,
            //                          view.frame.size.width, yValue)];
        }
    }
}


- (void)getAddedWord:(NSNotification *)notification {
    
    self.WordNew = notification.object;
}



- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    for(UIView *view in self.tabBar.tabBar.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self.learnBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0], UITextAttributeTextColor,[UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], UITextAttributeFont,nil]
                                       forState:UIControlStateSelected];
    
    UIImageView *imgView = nil;
    switch (tabBarController.selectedIndex) {
        case 0:
            imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"communitysel.png"]];
            break;
        case 1:
        {
            [self.learnBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], UITextAttributeFont,nil]
                                               forState:UIControlStateSelected];
            imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"learnsel.png"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:kNote]];
        }
            break;
        case 2:
            imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moresel.png"]];
            break;
        default:
            break;
    }
    
    [self.tabBar.tabBar insertSubview:imgView atIndex:0];
    
    
}

- (void)showWordList
{
    _tabBar.selectedIndex = 1;
}




- (void)dataReloaded:(NSNotification *)notification {
    
    //[NSString stringWithFormat:@"spanishWord##frenchWord##es##fr"];
    self.wordNew = notification.object;
    NSString *wordStr = self.wordNew.addedWord;
    
    // If there is no word then return ...
    if ([wordStr isEqualToString:@"Empty"])
        return;
    
    NSArray *wordsArray = [wordStr componentsSeparatedByString:@"$$"];
    for (int k = 0; k < [wordsArray count]; k++) {
        
        NSArray *splitArray = [[wordsArray objectAtIndex:k] componentsSeparatedByString:@"##"];
        NSString *targetLanCode = [UserDefaluts objectForKey:kTargetLangCode];
        NSString *nativeLanCode = [UserDefaluts objectForKey:kNativeLangCode];
        
        if (([splitArray count] >= 4) && [[splitArray objectAtIndex:2] isEqualToString:nativeLanCode] && [[splitArray objectAtIndex:3] isEqualToString:targetLanCode]) {
            
            NSString *targetWordStr = [splitArray objectAtIndex:1]?[splitArray objectAtIndex:1]:@"";
            NSString *nativeWordStr = [splitArray objectAtIndex:0]?[splitArray objectAtIndex:0]:@"";
            
            NSString *alreadySaved = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"select COUNT(*) from tbl_Dictionary where targetWord = \"%@\" AND nativeword = \"%@\"",targetWordStr,nativeWordStr]];
            if ([alreadySaved integerValue]==0) {
                
                [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest, sense, POS" fieldValue:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"",targetWordStr,nativeWordStr,@"White",nativeLanCode,targetLanCode,@"Saved",[UserDefaluts objectForKey:@"userLevel"],[NSDate date],@"",@""]];
            }
            
        }
        
    }
    
    self.wordNew.addedWord = @"Empty";
    [self.wordNew updateChangeCount:UIDocumentChangeDone];
    
}


- (void)loadDocument {
    
    NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
    _query = query;
    [query setSearchScopes:[NSArray arrayWithObject:
                            NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:
                         @"%K == %@", NSMetadataItemFSNameKey, kNewWord];
    [query setPredicate:pred];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(queryDidFinishGathering:)
     name:NSMetadataQueryDidFinishGatheringNotification
     object:query];
    [query startQuery];
    
}

- (void)queryDidFinishGathering:(NSNotification *)notification {
    
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query];
    
    _query = nil;
	[self loadData:query];
    
}

- (void)loadData:(NSMetadataQuery *)query {
    
    if ([query resultCount] == 1) {
        NSMetadataItem *item = [query resultAtIndex:0];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        AddNewWord *doc = [[AddNewWord alloc] initWithFileURL:url];
        self.wordNew = doc;
        [self.wordNew openWithCompletionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"iCloud document opened");
            } else {
                NSLog(@"failed opening document from iCloud");
            }
        }];
        
        
	} else {
        
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:kNewWord];
        
        AddNewWord *doc = [[AddNewWord alloc] initWithFileURL:ubiquitousPackage];
        self.wordNew = doc;
        
        [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [doc openWithCompletionHandler:^(BOOL success) {
                    
                    NSLog(@"new document opened from iCloud");
                    
                }];
            }
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTabBar:nil];
    [super viewDidUnload];
}
@end
