//
//  TestVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>

@interface TestVC : GAITrackedViewController<ADBannerViewDelegate>{
   
}



@property (weak, nonatomic) IBOutlet UILabel *whitePlayLbl;
@property (weak, nonatomic) IBOutlet UILabel *orangePlayLbl;
@property (weak, nonatomic) IBOutlet UILabel *greenPlayLbl;
@property (weak, nonatomic) IBOutlet UILabel *redPlayLbl;


@property (unsafe_unretained, nonatomic) IBOutlet UIButton *bthHome;
@property (nonatomic, strong) UIImageView *tabBarImageView;
@property(nonatomic,strong) IBOutlet UIButton *btnWhite;
@property(nonatomic,strong) IBOutlet UIButton *btnOrange;
@property(nonatomic,strong) IBOutlet UIButton *btnGreen;
@property(nonatomic,strong) IBOutlet UIButton *btnRed;
-(IBAction)whiteTest:(id)sender;
-(IBAction)redTest:(id)sender;
-(IBAction) orangeTest:(id)sender;
-(IBAction) greenTest:(id)sender;
-(IBAction) allBucketTest:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *imgView;

// Word list Bucket
@property (strong, nonatomic) UIToolbar *toolbar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnWhiteWordList;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnRedWordList;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnOrgangeWordList;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnGreenWordList;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *userName;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *profilePic;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtSearch;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIView *wordListView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnAllBucket;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnLanguage;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *infoButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *profilepicBgImgVew;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nativeLangLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *targetLangLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *chooseyrTestLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *barbuttonDone;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *thenewLaebl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *learnedLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mistakesLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *learningLabel;
@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;

- (void)addBannerView;



- (IBAction)wordListButtonClicked:(id)sender;
- (IBAction)searchClicked:(id)sender;
- (void)wordListBucketViewMakeHidden:(NSNotification*)notification;
- (void)receiveTestNotification:(NSNotification *)notification;
- (IBAction)languageButtonClicked:(id)sender;
- (IBAction)infoButtonClicked:(id)sender;
- (IBAction)wishListButtonClicked:(id)sender;
- (IBAction)doneButtonActionOnToolBar:(id)sender;





@end
