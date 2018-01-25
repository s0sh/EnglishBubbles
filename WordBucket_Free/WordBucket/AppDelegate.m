//
//  AppDelegate.m
//  WordBucket
//
//  Created by Mehak Bhutani on 11/22/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "TabBarViewC.h"
#import "Flurry.h"
#import <Crashlytics/Crashlytics.h>
#import "GoogleConversionPing.h"
#import "GAI.h"
#import "InfoViewC.h"
#import "ChooseViewController.h"
#define kDatabaseName @"WordBucket.sqlite"
/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-37853977-3";
static NSString *const kAllowTracking = @"allowTracking";
static sqlite3 *newDBconnection=nil;


NSString *const FBSessionStateChangedNotification = @"com.facebook.Scrumptious:FBSessionStateChangedNotification";
@interface AppDelegate ()



@end
@implementation AppDelegate
@synthesize navController;

- (void)loadDocument {
    
    NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
    _query = query;
    [query setSearchScopes:[NSArray arrayWithObject:
                            NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:
                         @"%K == %@", NSMetadataItemFSNameKey, kFILENAME];
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
        WordList *doc = [[WordList alloc] initWithFileURL:url];
        self.doc = doc;
        [self.doc openWithCompletionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"iCloud document opened");
            } else {
                NSLog(@"failed opening document from iCloud");
            }
        }];
        
        
	} else {
        
        // Save if file is not there ...
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:kFILENAME];
        
        WordList *doc = [[WordList alloc] initWithFileURL:ubiquitousPackage];
        self.doc = doc;
        
        [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [doc openWithCompletionHandler:^(BOOL success) {
                    
                    NSLog(@"new document opened from iCloud");
                    
                }];
            }
        }];
    }
}
                    

-(void) saveImage
{                
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    self.openedURL = url;
    [[FBSession activeSession] handleOpenURL:url];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object; this is a good idea because
    // things may be hanging off the session, that need releasing (completion block, etc.) and
    // other components in the app may be awaiting close notification in order to do cleanup
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application	{
    
     NSLog(@"become active");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"1" forKey:kisAppActive];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPauseWhenAppGoesInBack object:nil userInfo:userInfo];
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    
    //[FBSession setDefaultAppID:kAppId];
    [FBSession.activeSession handleDidBecomeActive];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"0" forKey:kisAppActive];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPauseWhenAppGoesInBack object:nil userInfo:userInfo];
    
    NSLog(@"enter in background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
     NSLog(@"enter in four ground");
}


-(void)substituteAuthController
{
    
    if(![UserDefaluts objectForKey:@"loginDone"])
    {
        if([UserDefaluts boolForKey:@"iPhone5"])
            self.splashObj = [[SplashVC alloc] initWithNibName:@"SplashVC"
                                                        bundle:nil];
        else
            self.splashObj = [[SplashVC alloc] initWithNibName:@"SplashVCiPhone4"
                                                        bundle:nil];
       
        
        [self.navController pushViewController:self.splashObj animated:YES];
        
    } else {
        
        NSString *nib = SharedAppDelegate.isPhone5 ? @"InfoViewC" : @"InfoViewCiPhone4";
        InfoViewC *infoObject = [[InfoViewC alloc] initWithNibName:nib bundle:nil];
        infoObject.isFromLogin = YES;
        [self.navController pushViewController:infoObject animated:YES];
    }


}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        [UserDefaluts setBool:YES forKey:@"iPhone5"];
        _isPhone5 = YES;
    } else {
        [UserDefaluts setBool:NO forKey:@"iPhone5"];
        _isPhone5 = NO;
    }
    
    
    [self checkAndCopyDatabase];
    
    
    [FBProfilePictureView class];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: Load document...
        [self loadDocument];
        
    } else {
        NSLog(@"No iCloud access");
//        if (![UserDefaluts boolForKey:@"iClouldAlert"]) {
//            [Common showAlertView:nil message:@"Thanks for downloading Word Bucket. To get the best from Word Bucket we recommend you set up iCloud in your iPhone settings to store all your new words online." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [UserDefaluts setBool:YES forKey:@"iClouldAlert"];
//            [UserDefaluts synchronize];
//        }
        
    }
    // Override point for customization after application launch.
    
     [self.window makeKeyAndVisible];
    if(![UserDefaluts objectForKey:@"loginDone"])
    {
        ChooseViewController *firstController = [[ChooseViewController alloc] initWithNibName:@"ChooseVCiPhone4" bundle:nil];
        self.navController = [[UINavigationController alloc] initWithRootViewController:firstController];
        self.window.rootViewController = self.navController;
        [self.navController.navigationBar setHidden:YES];
    }
    else{
    
        NSString *nib = SharedAppDelegate.isPhone5 ? @"InfoViewC" : @"InfoViewCiPhone4";
        InfoViewC *infoObject = [[InfoViewC alloc] initWithNibName:nib bundle:nil];
        infoObject.isFromLogin = NO;
        self.navController = [[UINavigationController alloc] initWithRootViewController:infoObject];
        self.window.rootViewController = self.navController;
        [self showTabBar];
    
    }
     NSInteger yValue = _isPhone5 ? 449 : 361;
    self.adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, yValue, 320, yValue)];
    self.adBanner.currentContentSizeIdentifier =ADBannerContentSizeIdentifierPortrait;
    self.adBanner.delegate = self;
    // adBanner.backgroundColor = [UIColor clearColor];
    self.adBanner.hidden = true;
    
    
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"WordBucket_Free"
                                              trackingId:kTrackingId];
    
        
    [Flurry startSession:@"S3WMRHFWJ3HCY48Q3TNV"];
    [GoogleConversionPing pingWithConversionId:@"1020163539" label:@"Ih5LCO3VzQcQ0-u55gM" value:@"0" isRepeatable:NO];
    [Crashlytics startWithAPIKey:@"4ef35d938d6ec91a5c8888697f592da11b2a8653"];
    
    return YES;
}

- (void)showTabBar
{
    [self.navController.view removeFromSuperview];
    self.objTabBarViewController = nil;
    
    NSString *nibName = nil;
    if([UserDefaluts boolForKey:@"iPhone5"])
        nibName = @"TabBarViewC";
    else
        nibName = @"TabBarViewCiPhone4";
    self.objTabBarViewController = [[TabBarViewC alloc] initWithNibName:nibName bundle:nil];
    if (self.objTabBarViewController.view)
    {
        [self.window addSubview:[self.objTabBarViewController.tabBar view]];
        [self.objTabBarViewController.tabBar setSelectedIndex:1];
        //[[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:@"NO"];
    }
    
}



//copy WordBucket database from resources folder to application documents directory
-(void) checkAndCopyDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *dbPath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:kDatabaseName];
    NSLog(@"%@",dbPath);
    if(![fileManager fileExistsAtPath:dbPath])
    {
        NSError *error;
        [fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseName] toPath:dbPath error:&error];
       
        NSLog(@"%@",[error description]);
    }
}

- (void)checkAndCopyWordList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *dbPath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:kWordPlist];
    NSLog(@"%@",dbPath);
    if(![fileManager fileExistsAtPath:dbPath])
    {
        NSError *error;
        [fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kWordPlist] toPath:dbPath error:&error];
        
        NSLog(@"%@",[error description]);
    }
}


//get instance of database connection
-(sqlite3 *) getNewDBConnection{
	
	NSString *databasePath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:kDatabaseName];
    
	if (newDBconnection == nil) {
		
		if (sqlite3_open([databasePath UTF8String], &newDBconnection) == SQLITE_OK) {
			NSLog(@"Database Successfully Opened ");
            
		} else {
			NSLog(@"Error in opening database ");
		}
    }
	
	return newDBconnection;
}


#pragma mark -- AdBannerView 
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
    NSLog(@"BANNER LOADED");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bannerLoaded" object:self];
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (self.adBanner.bannerLoaded == true) {
            NSLog(@"BANNER ERROR");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bannerError" object:self];
    }
}


/*
+ (AppDelegate*) sharedApplication
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}



- (ADBannerView*)sharedAd
{
    if(self.bannerView==nil){
        self.bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        [self.bannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, nil]];
        [self.bannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        [self.bannerView setDelegate:self];

    }
    return self.bannerView;
     
     
}

#pragma mark ADBannerViewDelegame method


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    NSLog(@"banner loaded");
//    if (!self.isBannerVisible)
//    {
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        // banner is invisible now and moved out of the screen on 50 px
//        banner.frame = CGRectMake(0, self.view.frame.size.height-50, 320, 50);
//        [UIView commitAnimations];
//        self.isBannerVisible = YES;
//    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"error is %@",[error localizedDescription]);
//    if (self.isBannerVisible)
//    {
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        // banner is visible and we move it out of the screen, due to connection issue
//        banner.frame = CGRectMake(0, self.view.frame.size.height-50, 320, 50);
//        [UIView commitAnimations];
//        self.isBannerVisible = NO;
//    }
}
*/


@end
