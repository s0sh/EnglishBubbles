//
//  OrangeTestViewController.h
//  WordBucket
//
//  Created by Mehak Bhutani on 1/23/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ProgressView.h"


@interface OrangeTestViewController : GAITrackedViewController <AVAudioPlayerDelegate>
{
    
    NSInteger quesNo;
    NSInteger optionNo;
    NSDate *testDate;
    
}

@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalQuestLabel;
@property (nonatomic, retain) ProgressView *progressBar;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *placeHolderLbl;
@property(nonatomic,assign) NSInteger attemptForOT2;
@property(nonatomic,assign) BOOL isOrangeTest1;
@property(nonatomic,retain) NSTimer *mainTimer;
@property(nonatomic,assign) CGRect lblFrame;
@property(nonatomic,retain) IBOutlet UILabel *lblTargetWord;
@property(nonatomic,retain) IBOutlet UIButton *btnTrue;
@property(nonatomic,retain) IBOutlet UIButton *btnFalse;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblAnimation;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *submitButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnHint;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *dotsImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtNativeWord;
@property(nonatomic,retain) NSMutableArray *arrAnswers;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblAnswer;
@property(nonatomic,retain) NSMutableArray *arrQustType;
@property(nonatomic,retain) NSString *strCorrectAns;
@property(nonatomic,retain) NSMutableArray *idArray;
@property(nonatomic,retain) IBOutlet UIButton *btnTimer;
@property(nonatomic,retain) IBOutlet UIButton *btnTotalQues;
@property(nonatomic,retain) IBOutlet UIButton *btnBucket1;
@property(nonatomic,retain) IBOutlet UIButton *btnBucket2;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *textFieldBgView;


- (void)setUpTimerAndView;
- (IBAction)submitClicked:(id)sender;
- (IBAction)hintButtonClicked:(id)sender;
- (void)makeSmallDealy;
-(IBAction)trueClicked:(id)sender;
-(IBAction)falseClicked:(id)sender;
- (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range;
-(void) playSoundCorrectSound;
-(void) playSoundInCorrectSound;
- (IBAction)homeButtonClicked:(id)sender;



@end
