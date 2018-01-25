//
//  AppDelegate.m
//  WordBucket
//
//  Created by Mehak Bhutani on 11/22/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "AppDelegate.h"
#import "DBHelper.h"
#import "Common.h"
#import "TabBarViewC.h"
#import "Flurry.h"
#import <Crashlytics/Crashlytics.h>
#import "GoogleConversionPing.h"
#import "GAI.h"
#import "InfoViewC.h"
#define kDatabaseName @"WordBucket.sqlite"
static sqlite3 *newDBconnection=nil;
/******* Set your tracking ID here *******/

static NSString *const kTrackingId = @"UA-37853977-4";
static NSString *const kAllowTracking = @"allowTracking";


//NSString *const FBSessionStateChangedNotification = @"com.facebook.Scrumptious:FBSessionStateChangedNotification";


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
                         @"%K == %@", NSMetadataItemFSNameKey,kFILENAME];
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
        
        // show alert
        NSString *upgradeMsg = NSLocalizedString(@"Thank you for upgrading Word Bucket. It may take a few minutes for iCloud to transfer your words. Once it's done you can enjoy all the great Word Bucket features. Excited?", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:upgradeMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        
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
        
        // No files at iCloud...Continue normal login here
        [self showLoginView];
        
    }
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




 
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // handler code here
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // if the app is going away, we close the session object; this is a good idea because
    // things may be hanging off the session, that need releasing (completion block, etc.) and
    // other components in the app may be awaiting close notification in order to do cleanup
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application	{
    
     NSLog(@"become active");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"1" forKey:kisAppActive];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPauseWhenAppGoesInBack object:nil userInfo:userInfo];
    
    
    //[FBSession setDefaultAppID:kAppId];
    //[FBSession.activeSession handleDidBecomeActive];
    
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        [UserDefaluts setBool:YES forKey:@"iPhone5"];
        [UserDefaluts synchronize];
        _isPhone5 = YES;
    } else {
        [UserDefaluts setBool:NO forKey:@"iPhone5"];
        [UserDefaluts synchronize];
        _isPhone5 = NO;
    }
    [self checkAndCopyDatabase];
    [self.navController.navigationBar setHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    
    if(![UserDefaluts objectForKey:@"loginDone"])
    {
        
        //if (![UserDefaluts objectForKey:kisUpgrade]) {
            [self setUpiCloud];
        //}
                
    } else {
        
        NSString *nib = SharedAppDelegate.isPhone5 ? @"InfoViewC" : @"InfoViewCiPhone4";
        InfoViewC *infoObject = [[InfoViewC alloc] initWithNibName:nib bundle:nil];
        infoObject.isFromLogin = NO;
        self.navController = [[UINavigationController alloc] initWithRootViewController:infoObject];
        self.window.rootViewController = self.navController;
        [self showTabBar];
    }
    
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    //[GAI sharedInstance].optOut = YES;
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"WordBucket_Paid"
                                              trackingId:kTrackingId];
    
    
    [Flurry startSession:@"S3WMRHFWJ3HCY48Q3TNV"];
    
    [GoogleConversionPing pingWithConversionId:@"1020163539" label:@"LRxUCMWszwcQ0-u55gM" value:@"0" isRepeatable:NO];
    
    
    [Crashlytics startWithAPIKey:@"4ef35d938d6ec91a5c8888697f592da11b2a8653"];
    return YES;
}

- (void)showLoginView
{
    if([UserDefaluts boolForKey:@"iPhone5"])
        self.splashObj = [[SplashVC alloc] initWithNibName:@"SplashVC"
                                                    bundle:nil];
    else
        self.splashObj = [[SplashVC alloc] initWithNibName:@"SplashVCiPhone4"
                                                    bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.splashObj];
    self.window.rootViewController = self.navController;
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

//get instance of database connection
-(sqlite3 *) getNewDBConnection{
	
	NSString *databasePath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:kDatabaseName];
    //NSLog(@"%@",databasePath);
    
	if (newDBconnection == nil) {
		
		if (sqlite3_open([databasePath UTF8String], &newDBconnection) == SQLITE_OK) {
			NSLog(@"Database Successfully Opened ");
            
		} else {
			NSLog(@"Error in opening database ");
		}
    }
	
	return newDBconnection;
}

- (void)setUpiCloud
{
    
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: Load document...
        
        [self loadDocument];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataReloaded:)
                                                     name:@"upgradeWord" object:nil];
    } else {
        NSLog(@"No iCloud access");
        [self showLoginView];
        
        
    }

}

- (void)dataReloaded:(NSNotification *)notification {
    
    //self.doc = notification.object;
    //NSString *wordStr = self.wordNew.addedWord;
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistPath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:kWordPlist];
    if([fileManager fileExistsAtPath:plistPath])
    {
        NSMutableArray *freeversionWords = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        
        if (freeversionWords.count > 0) {
            
            NSMutableDictionary *dic = [freeversionWords objectAtIndex:0];
            
            [UserDefaluts setObject:[dic objectForKey:kNativeLanguage] forKey:kNativeLangCode];
            [UserDefaluts setObject:[dic objectForKey:kTargetLanguage] forKey:kTargetLangCode];
            [UserDefaluts setObject:[dic objectForKey:kUserLevel] forKey:kUserLevel];
            [UserDefaluts synchronize];
            
            [[DBHelper sharedDbInstance] deleteRecordIntoTableNamed:@"tbl_Dictionary"];
            BOOL isSuccess =  [self insertMultipleRowQuerywithArray:freeversionWords];
                
                if (isSuccess) {
                    
                    [UserDefaluts setBool:YES forKey:@"loginDone"];
                    [UserDefaluts synchronize];
                    
                    //MYCHANGE
                    NSString *nib = SharedAppDelegate.isPhone5 ? @"InfoViewC" : @"InfoViewCiPhone4";
                    InfoViewC *infoObject = [[InfoViewC alloc] initWithNibName:nib bundle:nil];
                    infoObject.isFromLogin = NO;
                    self.navController = [[UINavigationController alloc] initWithRootViewController:infoObject];
                    self.window.rootViewController = self.navController;
                    [self showTabBar];
                    
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"An error occurred while updating." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [self showLoginView];
                }
                
        } else
            [self showLoginView];
    } else
        [self showLoginView];
    
    
    
    /*
    
    if([UserDefaluts objectForKey:@"loginDone"])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *plistPath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:kWordPlist];
        if([fileManager fileExistsAtPath:plistPath])
        {
            NSMutableArray *freeversionWords = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
            
            if (freeversionWords.count > 0) {
                
                NSMutableDictionary *dic = [freeversionWords objectAtIndex:0];
                NSLog(@"dic target lang is %@",[dic objectForKey:kNativeLanguage]);
                NSLog(@"dic native lang is %@",[dic objectForKey:kTargetLanguage]);
                NSLog(@"dic level lang is %@",[dic objectForKey:kUserLevel]);
                NSLog(@"target lang is %@",[UserDefaluts objectForKey:kTargetLangCode]);
                NSLog(@"native lang is %@",[UserDefaluts objectForKey:kNativeLangCode]);
                NSLog(@"level lang is %@",[UserDefaluts objectForKey:kUserLevel]);
                
                if (([[dic objectForKey:kNativeLanguage] isEqualToString:[UserDefaluts objectForKey:kNativeLangCode]] ) && ([[dic objectForKey:kTargetLanguage] isEqualToString:[UserDefaluts objectForKey:kTargetLangCode]]) && ([[dic objectForKey:kUserLevel] isEqualToString:[UserDefaluts objectForKey:kUserLevel]])) {
                    
                    NSMutableArray *newWordsArray = [[NSMutableArray alloc] initWithArray:[[DBHelper sharedDbInstance] getAllValuesFromDictionaryTable:[NSString stringWithFormat:@"select * from tbl_Dictionary"]]];
                    // Delete all existing rows
                    [[DBHelper sharedDbInstance] deleteRecordIntoTableNamed:@"tbl_Dictionary"];
                    BOOL isSuccess =  [self insertMultipleRowQuerywithArray:freeversionWords];
                    
                    if (!isSuccess){
                        
                        BOOL olderValues = [self insertMultipleRowQuerywithArray:newWordsArray];
                        if(!olderValues)
                        [[Common sharedInstance] reinsertAllWord];
                        [UserDefaluts setBool:NO forKey:kisUpgrade];
                        [UserDefaluts synchronize];
                    }
                    else {
                        [UserDefaluts setBool:YES forKey:kisUpgrade];
                        [UserDefaluts synchronize];
                    }
                    
                    
                }
            }
        }
    }
    */
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
        strUnion = [strUnion stringByAppendingString:[NSString stringWithFormat:@"select \"%@\" as targetWord,\"%@\" as nativeWord, \"%@\" as bucketColor, \"%@\" as nativeLanguage, \"%@\" as targetLanguage, \"%@\" as action, \"%@\" as userLevel, \"%@\" as sense, \"%@\" as POS, \"%@\" as dateOfTest union ",[dic objectForKey:kTargetWord],[dic objectForKey:kNativeWord],[dic objectForKey:kBucketColor],[UserDefaluts valueForKey:@"nativeLanguageCode"],[UserDefaluts valueForKey:kTargetLangCode],[dic objectForKey:kAction],[UserDefaluts objectForKey:kUserLevel],[dic objectForKey:ksense],[dic objectForKey:kPOS],[dic objectForKey:kdateOfTest]]];
        
    }
    
    if([strUnion length]>0)
        multipleRowData = [multipleRowData stringByAppendingString:[strUnion substringToIndex:[strUnion length]-6]];
    NSString *lastIdValue =  [[DBHelper sharedDbInstance] insertMultipleRows:multipleRowData];
    // Check wheater data is successfully inserted or not ..
    if ([lastIdValue integerValue] > 0)
        isSuccess = YES;
    
    return isSuccess;
    
}



@end
