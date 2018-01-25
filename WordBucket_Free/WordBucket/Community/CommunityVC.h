//
//  CommunityVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/24/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>

@interface CommunityVC : GAITrackedViewController<ADBannerViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *bucketPlusButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSendAWord;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *containerImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnInviteFrnd;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnWBLeaderboard;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnHelpUsToImprove;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titileLbl;
@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;

- (void)addBannerView;
- (IBAction)commnunityButtonClicked:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;

@end
