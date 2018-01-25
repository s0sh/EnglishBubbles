//
//  InviteFriendsVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/24/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>

@interface InviteFriendsVC : GAITrackedViewController<ADBannerViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnShareOnEmail;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnText;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPostOnFacebook;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTweet;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLbl;
@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;

- (void)addBannerView;
- (IBAction)inviteFrndsButtonClicked:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;

@end
