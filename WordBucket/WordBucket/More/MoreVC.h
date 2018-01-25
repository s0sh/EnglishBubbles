//
//  MoreVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/28/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreVC : GAITrackedViewController

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *containerImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *whishListButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnHistory;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSetting;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnRateWordBucket;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnWBCredit;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnUpdateWB;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnHowsItWork;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnOfflineWishList;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *moreLabel;










- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)moreButtonClicked:(id)sender;



@end
