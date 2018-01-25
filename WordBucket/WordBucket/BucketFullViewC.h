//
//  BucketFullViewC.h
//  WordBucket
//
//  Created by ashish on 3/24/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketFullViewC : GAITrackedViewController
@property (strong, nonatomic) IBOutlet UIScrollView *bucketFullScroll;
@property (strong, nonatomic) IBOutlet UIView *upgradeView;
@property (strong, nonatomic) IBOutlet UIView *bucketFullView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bucketFullLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cngrtltonLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *saved25WordLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *upgradenow2Label;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *yougetLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *unlimitesStorageLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *greenBckGameLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *noAdsLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *offlineWLLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnUpgrade;



@property (unsafe_unretained, nonatomic) IBOutlet UILabel *oops1Label;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *updageNow1Label;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wbFree1Label;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *upgradnowfor1Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *unlimitedStrg1Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *greenBckGame1Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *noAda1Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *offileWL1Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnUpgrade1;





- (IBAction)upgradeButtonClicked:(id)sender;
- (IBAction)corssButtonClicked:(id)sender;

@end
