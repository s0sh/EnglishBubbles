//
//  AppDelegate.h
//  WordBucket
//
//  Created by Mehak Bhutani on 11/22/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TabBarViewC.h"
#import "SplashVC.h"
#import "WordList.h"
#import "GAI.h"


#define APP_HANDLED_URL @"APP_HANDLED_URL"


extern NSString *const FBSessionStateChangedNotification;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,ImageSaveDelegate>

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

-(void) checkAndCopyDatabase;
-(sqlite3 *) getNewDBConnection;
- (void)showTabBar;
@end
