//
//  WordListVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>


@interface WordListVC : GAITrackedViewController<MFMailComposeViewControllerDelegate,ActionSheetDelegate,UIActionSheetDelegate,AVAudioPlayerDelegate,ADBannerViewDelegate>
{
    NSMutableIndexSet *expandedSections;
    DBHelper *dbHelper;
    BOOL isRemoved;
    BOOL isCurrentColor;
    NSInteger currentOpen;
    BOOL isAlreadyInserted;
    NSMutableArray *arrSection;
    AVAudioPlayer *audioPlayer;
}

@property(nonatomic,strong) NSString *idString;
@property(nonatomic,strong) NSString *selectedTargetWord;
@property(nonatomic,strong) NSString *bucketColor;
@property(nonatomic,strong) NSString *selectedWord;
@property(nonatomic,strong) NSMutableArray *arrWord;
@property(nonatomic,strong) NSMutableArray *arrMeaning;
@property(nonatomic,strong) IBOutlet UITableView *tblSearch;
@property(nonatomic,strong) IBOutlet UIButton *btnWhite;
@property(nonatomic,strong) IBOutlet UIButton *btnRed;
@property(nonatomic,strong) IBOutlet UIButton *btnOrange;
@property(nonatomic,strong) IBOutlet UIButton *btnGreen;
@property(nonatomic,strong) NSString *selectedRowImage;
@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;
@property (nonatomic, strong) NSMutableArray *arrForTable;

- (void)addBannerView;

-(void) popUpActionSheet;
-(IBAction)bucketClick:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (void)shareButtonClicked:(id)sender event:(id)event;
- (IBAction)homeButtonClicked:(id)sender;

@end
