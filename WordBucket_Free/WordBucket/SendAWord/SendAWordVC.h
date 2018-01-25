//
//  SendAWordVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/28/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <iAd/iAD.h>


@interface SendAWordVC : GAITrackedViewController<ADBannerViewDelegate>{
    DBHelper *dbHelper;
    
}


@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtSearch;
@property(nonatomic,strong) IBOutlet UIButton *btnWhite;
@property(nonatomic,strong) IBOutlet UIButton *btnGreen;
@property(nonatomic,strong) IBOutlet UIButton *btnOrange;
@property(nonatomic,strong) IBOutlet UIButton *btnRed;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblExploreBucket;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblLearning;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblNew;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblLearned;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblMistakes;

@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;

- (void)addBannerView;
-(IBAction)whiteBucket:(id)sender;
-(IBAction)greenBucket:(id)sender;
-(IBAction)orangeBucket:(id)sender;
-(IBAction)redBucket:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)searchClicked:(id)sender;



@end
