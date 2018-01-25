//
//  WhiteTestViewController.h
//  WordBucket
//
//  Created by Mehak Bhutani on 1/23/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ProgressView.h"

@interface WhiteTestViewController : GAITrackedViewController <AVAudioPlayerDelegate>
{
    BOOL isSelected;
    NSInteger quesNo;
    NSInteger whiteTest;
    
}


@property(nonatomic, retain) ProgressView *prgressBar;
@property(nonatomic, retain) NSDate *testDate;
@property(nonatomic, retain) NSTimer *mainTimer;
@property(nonatomic, assign) CGRect orgnlFrame;
@property(nonatomic,strong) NSString *strTestColor;
@property(nonatomic,strong) NSString *strTarget;
@property(nonatomic,strong) NSString *strNative;

@property(strong, nonatomic) IBOutlet UILabel *lblTargetWord;
@property(strong, nonatomic) IBOutlet UIButton *btnOption1;
@property(strong, nonatomic) IBOutlet UIButton *btnOption2;
@property(strong, nonatomic) IBOutlet UIButton *btnOption3;
@property(strong, nonatomic) IBOutlet UIButton *btnOption4;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalQuestLabel;

@property(strong, nonatomic) IBOutlet UIButton *btnBucket1;
@property(strong, nonatomic) IBOutlet UIButton *btnBucket2;

@property(strong, nonatomic) IBOutlet UIButton *btnTimer;
@property(strong, nonatomic) IBOutlet UIButton *btnTotalQues;
@property (strong, nonatomic) IBOutlet UILabel *lblAnimation;

@property(nonatomic,retain) NSMutableArray *arrAnswers;
@property(nonatomic,retain) NSMutableArray *arrQuesSeq;
@property(nonatomic,retain) NSMutableArray *idArray;
@property(nonatomic,retain) NSString *strCorrectAns;

- (void)playCorrectSong;
- (void)playIncorrectSong;
-(IBAction)submitAnswer:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;

@end
