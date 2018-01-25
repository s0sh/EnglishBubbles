//
//  HistoryVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/24/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>

@interface HistoryVC : GAITrackedViewController<ADBannerViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *historyTable;
@property(nonatomic,strong) NSArray *arrHistory;
@property(nonatomic,strong) NSArray *arrHistoryValues;
@property(nonatomic,strong) NSArray *arrBucketColor;
@property(nonatomic,strong) NSArray *arrBucketValue;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bucketHistoryLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalWordSearchLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wordSavedLabl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalTestLeftLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *yourpassLeftLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *avgdaysLeftLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wordLefttotestLeftLbl;


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalSearchWordLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *savedWordLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalTestLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *passLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *whiteTestTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *redTestTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *orangeTestTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *greenTestTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *whiteBcktAvgTimeTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *redBcktAvgTimeTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *orangeBcktAvgTimeTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *greenBcktAvgTimeTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wordLefttoTestLabel;
@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;

- (void)addBannerView;
- (IBAction)homeButtonClicked:(id)sender;


@end
