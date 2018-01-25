//
//  UpdateViewC.h
//  WordBucket
//
//  Created by ashish on 3/21/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateViewC : GAITrackedViewController
- (IBAction)corssButtonClicked:(id)sender;
- (IBAction)upgradeButtonClicked:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblLoveWordBucket;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblfreefiftyWord;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblUpgradeNow;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblUnlimited;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblGreenBucketGame;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblNoads;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblOfflineWishlist;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnUpgrade;
@property (nonatomic, assign) BOOL isUpgradeClicked;

@end
