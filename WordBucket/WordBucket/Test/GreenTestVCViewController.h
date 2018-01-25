//
//  GreenTestVCViewController.h
//  WordBucket
//
//  Created by Mehak Bhutani on 1/22/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerView.h"


@interface GreenTestVCViewController : GAITrackedViewController <UIGestureRecognizerDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>{
    NSInteger limit;
    TimerView *_timeView;
}


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *quitLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *restartLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *resumeLabel;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) CGRect firstFrame;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bucketLabel;
@property (nonatomic, retain) NSString *actionString;
@property (strong, nonatomic) IBOutlet UIImageView *wrongImgView;
@property (nonatomic, assign) NSInteger pairCount;
@property (nonatomic, assign) NSInteger correctWordCount;
@property (nonatomic, assign) BOOL isGreenTest;
@property (nonatomic, assign) BOOL isiPhone5;
@property (nonatomic, strong) NSMutableArray *arrTargetWords;
@property (nonatomic, strong) NSMutableArray *arrNativeWords;
@property (nonatomic, strong) NSMutableArray *arrTargetTag;
@property (nonatomic, strong) NSMutableArray *arrNativeTag;
@property (nonatomic, strong) NSMutableArray *rectArray;
@property (nonatomic, strong) NSMutableArray *qustIdArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *inDangerIdArray;
@property (nonatomic, retain) NSTimer *mainTimer;
@property (nonatomic, retain) NSDate *testDate;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn1;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn2;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn3;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn4;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn5;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn6;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn7;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn8;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn9;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn10;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn11;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn12;
@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;
@property (strong, nonatomic) IBOutlet UIView *pauseView;
@property (strong, nonatomic) IBOutlet UIButton *wrongButton;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *timeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPause;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *resumeButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *restartButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *quitButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *gamePausedLabel;



- (IBAction)backButtonClicked:(id)sender;
- (IBAction)pauseClicked:(UIButton*)sender;
- (void)playCorrectSong;
- (void)playIncorrectSong;
- (void)updateTimer:(NSTimer *)timer;
- (IBAction)pauseScreenButtonClicked:(id)sender;
- (void)removeWrongImgView:(UIButton*)imageView;

@end
