//
//  InviteFriendsVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/24/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsVC : GAITrackedViewController

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnShareOnEmail;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnText;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPostOnFacebook;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTweet;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLbl;




- (IBAction)inviteFrndsButtonClicked:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;

@end
