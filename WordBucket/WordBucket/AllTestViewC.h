//
//  AllTestViewC.h
//  WordBucket
//
//  Created by ashish on 2/18/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ProgressView.h"

@interface AllTestViewC : GAITrackedViewController <AVAudioPlayerDelegate>
{
    NSInteger quesNo;
    NSInteger optionNo;
}


@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property(nonatomic, retain) ProgressView *progressBar;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *placeHolderLbl;
@property (nonatomic, assign) CGRect lblFrame;
@property (nonatomic, retain) NSDate *testDate;
@property(nonatomic, assign) NSInteger attemptForOT2;
@property (nonatomic, retain) NSMutableArray *arrAnswers;
@property (nonatomic, assign) NSInteger questionType;
@property (nonatomic, assign) NSTimer *mainTimer;
@property (nonatomic, assign) CGRect orgnlFrame;
@property (nonatomic, retain)  NSString *strCorrectAns;
@property (nonatomic, retain) NSMutableArray *arrQuesSeq;
@property (nonatomic,retain) NSMutableArray *idArray;
@property (strong, nonatomic) IBOutlet UIView *optionView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *firstOptButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *secondOptButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *thirdOptButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *fourthOptButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblAnimation;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTargetWord;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTotalQues;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTimer;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *submitButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnFalse;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTrue;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBucket1;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBucket2;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtNativeWord;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblAnswer;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnHint;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalQuestLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *dotsImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *textFieldBgView;




- (void)setUpTimerAndView;
- (IBAction)hintButtonClicked:(id)sender;
- (IBAction)submitClicked:(id)sender;
- (IBAction)trueClicked:(id)sender;
- (IBAction)falseClicked:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;

- (IBAction)optionButtonClicked:(id)sender;
-(void)stopAnimation;
- (void)correctAnsAnimation;
- (void)wrongAnsAnimation;
- (void)playCorrectSong;
- (void)playIncorrectSong;

@end
