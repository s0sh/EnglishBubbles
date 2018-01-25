//
//  ResultsVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/20/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>
#import "WordList.h"


@interface ResultsVC : GAITrackedViewController<ADBannerViewDelegate>

@property(nonatomic,retain) IBOutlet UITableView *tblResult;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblScore;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnHome;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *scoreTexLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTestAgain;

@property (nonatomic, retain) UIImage *bucketImage;
@property (nonatomic, retain) UIImage *redbucketImage;
@property (nonatomic, retain) UIImage *greenbucketImage;
@property (nonatomic,retain) NSMutableArray *arrTestWords;
@property (nonatomic, retain) NSMutableArray *resultIdArray;
@property (nonatomic,retain) NSString *lblColor;
@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;
@property (strong) WordList * doc;

- (void)addBannerView;
- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)testAgain:(id)sender;
@end
