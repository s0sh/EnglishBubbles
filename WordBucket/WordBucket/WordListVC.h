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


@interface WordListVC : GAITrackedViewController<MFMailComposeViewControllerDelegate,ActionSheetDelegate,UIActionSheetDelegate,AVAudioPlayerDelegate>
{
    NSMutableIndexSet *expandedSections;
    DBHelper *dbHelper;
    BOOL isRemoved;
    BOOL isCurrentColor;
    NSInteger currentOpen;
    NSMutableArray *arrForTable;
    BOOL isAlreadyInserted;
    NSMutableArray *arrSection;
}

@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
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

-(void) popUpActionSheet;
-(IBAction)bucketClick:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (void)shareButtonClicked:(id)sender event:(id)event;
- (IBAction)homeButtonClicked:(id)sender;
-(void)miniMizeThisRows:(NSArray*)ar section:(NSInteger)section row:(NSInteger)row;

@end
