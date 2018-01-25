//
//  AppDelegate.h
//  WordBucket
//
//  Created by Mehak Bhutani on 11/22/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "TabBarViewC.h"
#import "SplashVC.h"
#import "WordList.h"
#import <FacebookSDK/FacebookSDK.h>
#import <iAd/iAd.h>
#import "GAI.h"

#define SharedAdBannerView ((AppDelegate *)[[UIApplication sharedApplication] delegate]).adBanner
#define SharedAdBannerViewIsLoaded ((AppDelegate *)[[UIApplication sharedApplication] delegate]).bannerLoaded

extern NSString *const FBSessionStateChangedNotification;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,ImageSaveDelegate,ADBannerViewDelegate>
{
    bool *bannerLoaded;
}


@property (strong, nonatomic) ADBannerView *adBanner;
@property (strong, nonatomic) SplashVC *splashObj;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) id<GAITracker> tracker;
@property (assign, nonatomic) BOOL isPhone5;
@property (assign, nonatomic) NSInteger totolQustCount;
@property (assign, nonatomic) BOOL isNativeSrchLang;
@property (strong, nonatomic) UINavigationController *navController;
@property (retain, nonatomic) TabBarViewC *objTabBarViewController;
@property (strong) WordList * doc;
@property (strong) NSMetadataQuery *query;
@property (nonatomic, retain) NSURL *openedURL;

- (void)loadDocument;
- (void)loadData:(NSMetadataQuery *)query;
-(void) checkAndCopyDatabase;
-(sqlite3 *) getNewDBConnection;
- (void)showTabBar;
+ (AppDelegate*)sharedApplication;
- (ADBannerView*)sharedAd;
-(void)substituteAuthController;
@end
