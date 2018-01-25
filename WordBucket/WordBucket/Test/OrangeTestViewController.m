//
//  OrangeTestViewController.m
//  WordBucket
//
//  Created by Mehak Bhutani on 1/23/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "OrangeTestViewController.h"
#import "ResultsVC.h"
#import <AudioToolbox/AudioToolbox.h>
@interface OrangeTestViewController ()

@end

@implementation OrangeTestViewController
@synthesize btnFalse,btnTrue,lblTargetWord,btnTimer,btnTotalQues,arrAnswers,strCorrectAns,btnBucket1,btnBucket2,arrQustType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setLocalizedString
{
    [self.submitButton setTitle:NSLocalizedString(@"ENTER", nil) forState:UIControlStateNormal];
    NSString *trueStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"TRUE", nil)];
    NSString *falseStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"FALSE", nil)];
    [self.btnTrue setTitle:trueStr forState:UIControlStateNormal];
    //[self.instructionLabel setText:NSLocalizedString(@"To give a letter an accent just hold it down and select the correct one.", nil)];
    [self.btnFalse setTitle:falseStr forState:UIControlStateNormal];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLocalizedString];
    _lblFrame = self.lblTargetWord.frame;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [_txtNativeWord setText:@""];
    [_txtNativeWord setEnabled:NO];
    [_submitButton setHidden:YES];
    _attemptForOT2 = 0;
    _idArray = [[NSMutableArray alloc] init];
    
    NSInteger w1Count = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where action = 'WhiteTest2' and bucketColor = 'Orange'"]];
    NSInteger w2Count = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where action = 'OrangeTest1' and bucketColor = 'Orange'"]];
    NSInteger w1Qust = ceil(((CGFloat)w1Count/(w1Count+w2Count))*SharedAppDelegate.totolQustCount);
    NSInteger w2Qust = SharedAppDelegate.totolQustCount-w1Qust;
    NSLog(@"w1 and w2 w1qust w2qust is %d %d %d %d",w1Count,w2Count,w1Qust,w2Qust);
    
    arrQustType = [[NSMutableArray alloc] init];
    for (int k =1; k <= w2Qust; k++) {[arrQustType addObject:kOrangeTest2];}
    for (int k =1; k <= w1Qust; k++) {[arrQustType addObject:kOrangeTest1];}
    [arrQustType shuffle];
    
    // Add timer view
    [self setUpTimerAndView];
    
    [_totalQuestLabel setText:[NSString stringWithFormat:@"/%d",SharedAppDelegate.totolQustCount]];
    
    
    quesNo = 0;
    optionNo = 0;
    testDate = [NSDate date];
    [self.navigationController.navigationBar setHidden:YES];
    [UserDefaluts setObject:testDate forKey:@"CurrentTestDate"];
    [self getNewQuestion];
    [self getNewOption];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Orange Test Screen";
    [SharedAppDelegate.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Orange_Test" action:@"Orange_Test_Begin" label:@"WordBucket-Paid" value:nil] build]];
}


- (void)setUpTimerAndView
{
    // Add timer view
    
    if (!SharedAppDelegate.isPhone5 && ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"ja"] || [[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"zh"])) {
        _progressBar = [[ProgressView alloc] initWithFrame:CGRectMake(248, 55, 40, 40) isSmallSize:YES];
        CGRect frame;
        frame = self.btnTimer.frame;
        frame.size = CGSizeMake(40, 40);
        [self.btnTimer setFrame:CGRectMake(248, 55, 40, 40)];
        [self.btnTimer.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        
        frame = self.btnTotalQues.frame;
        frame.size = CGSizeMake(47, 39);
        [self.btnTotalQues setFrame:frame];
        [self.btnTotalQues.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:40]];
        
        [self.totalQuestLabel setFrame:CGRectMake(52, 65, 32, 27)];
        [self.totalQuestLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        
        frame = self.dotsImageView.frame;
        frame.origin.y = 70;
        [self.dotsImageView setFrame:frame];
        
        frame = self.textFieldBgView.frame;
        frame.origin.y = 98;
        [self.textFieldBgView setFrame:frame];
        
        frame = self.placeHolderLbl.frame;
        frame.origin.y = 104;
        [self.placeHolderLbl setFrame:frame];
        
        frame = self.txtNativeWord.frame;
        frame.origin.y = 105;
        [self.txtNativeWord setFrame:frame];
        
        frame = self.btnHint.frame;
        frame.origin.y = 113;
        [self.btnHint setFrame:frame];
        
        frame = self.btnTrue.frame;
        frame.origin.y = 157;
        [self.btnTrue setFrame:frame];
        
        frame = self.btnFalse.frame;
        frame.origin.y = 157;
        [self.btnFalse setFrame:frame];
        
        frame = self.submitButton.frame;
        frame.origin.y = 157;
        [self.submitButton setFrame:frame];
        
        
        
        
    } else {
        
        _progressBar = [[ProgressView alloc] initWithFrame:CGRectMake(248, 55, 60, 60) isSmallSize:NO];
    }
    
    _progressBar.percent = 7;
    _progressBar.increament = 0;
    [self.view addSubview:_progressBar];
    [self.view bringSubviewToFront:self.btnTimer];
    
    
}



- (void)pauseTimer
{
    if(_mainTimer){[_mainTimer invalidate];_mainTimer = nil;}
}

- (void)resumeTimer
{
    if(_mainTimer){[_mainTimer invalidate];_mainTimer = nil;}
    _progressBar.increament = 0;
    _progressBar.percent = _isOrangeTest1 ? 7 : 45;
    [_progressBar setNeedsDisplay];
    NSString *timeString = _isOrangeTest1 ? @"7" : @"45";
    [self.btnTimer setTitle:[NSString stringWithString:timeString] forState:UIControlStateNormal];
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayPauseNoti:) name:kPauseWhenAppGoesInBack object:nil];
    
    [Common hideTabBar:self.tabBarController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPauseWhenAppGoesInBack object:nil];
    [self pauseTimer];
    [Common showTabBar:self.tabBarController];
}

- (void)receivePlayPauseNoti:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo objectForKey:kisAppActive] isEqualToString:@"1"]) {
        if(quesNo <= SharedAppDelegate.totolQustCount)
            _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        
    } else {
        
        [self pauseTimer];
    }
    
}


-(void)getNewOption
{
    if(quesNo<=SharedAppDelegate.totolQustCount){
    //NSLog(@"OPTION NO IS %d",optionNo);
    if(optionNo < 5)
    {
        [_txtNativeWord setText:[arrAnswers objectAtIndex:optionNo]];
        optionNo++;
        NSString *imgName = [NSString stringWithFormat:@"dots%d",optionNo];
        [_dotsImageView setImage:GetImage(imgName)];
        //NSLog(@"OPTION NO IS %d",optionNo);
        if (!_isOrangeTest1)[_txtNativeWord setText:@""];
        [self resumeTimer];
        
    }
    else
    {
        optionNo = 0;
        [self pauseTimer];
        [self submitAnswer:nil];
        
       
    }
        
    }
}


-(void) getNewQuestion
{
    quesNo++;
    if(quesNo <= SharedAppDelegate.totolQustCount)
    {
        if([[arrQustType objectAtIndex:quesNo-1] isEqualToString:kOrangeTest1])
            _isOrangeTest1 = YES;
         else
             _isOrangeTest1 = NO;
            
            [self.btnTotalQues setTitle:[NSString stringWithFormat:@"%d",quesNo] forState:UIControlStateNormal];
            [btnBucket2 setImage:[UIImage imageNamed:@"bucketOrange.png"] forState:UIControlStateNormal];
        
        NSString *actionString = _isOrangeTest1 ? kWhiteTest2 : kOrangeTest1;
        NSString *natTarString = _isOrangeTest1 ? @"targetWord" : @"nativeWord";
        NSString *idString = [Common getStringValueSeperatedByCommaWithArray:_idArray];
        
         NSMutableArray *arrNewWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'Orange' and action = \"%@\" and id NOT IN(%@) ORDER BY RANDOM() LIMIT 1",actionString,idString] withField:[NSString stringWithFormat:@"%@ , id, dateOfTest",natTarString]];
        if([arrNewWord count]>0)
        {
            NSArray *split = [[arrNewWord objectAtIndex:0] componentsSeparatedByString:@"/|"];
            if(split.count>1)
                [_idArray addObject:[split objectAtIndex:1]];
            
            lblTargetWord.text = [split objectAtIndex:0];
            NSString *field = _isOrangeTest1 ? @"nativeWord" : @"targetWord";
            
             NSMutableArray *arrCorrectWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE id = \"%@\"",[split objectAtIndex:1]] withField:field];
            
            if([arrCorrectWord count]>0)
            {
                self.strCorrectAns = [arrCorrectWord objectAtIndex:0];
                NSLog(@"CORRECT ANS IS > %@",self.strCorrectAns);
                
                if (_isOrangeTest1) {
                    
                    [_dotsImageView setHidden:NO];
                    [_txtNativeWord resignFirstResponder];
                    [_txtNativeWord setEnabled:NO];
                    [_txtNativeWord setTextAlignment:NSTextAlignmentCenter];
                    [_submitButton setHidden:YES];
                    [self.btnTrue setHidden:NO];
                    [self.btnFalse setHidden:NO];
                    [_lblAnswer setHidden:YES];
                    [_placeHolderLbl setHidden:YES];
                    [_btnHint setHidden:YES];
                    [_textFieldBgView setImage:GetImage(@"container116")];
                    arrAnswers = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE nativeWord != \"%@\"  and action !=\"\" GROUP BY nativeWord ORDER BY RANDOM() LIMIT 4",[arrCorrectWord objectAtIndex:0]] withField:@"nativeWord"];
                    [arrAnswers addObject:[arrCorrectWord objectAtIndex:0]];
                    // Need to uncomment it, its only for testing
                    [self.arrAnswers shuffle];
                } else {
                    
                    [_dotsImageView setHidden:YES];
                    _attemptForOT2 = 0;
                    [_submitButton setHidden:NO];
                    [_txtNativeWord setTextAlignment:NSTextAlignmentLeft];
                    [_txtNativeWord setEnabled:YES];
                    [_txtNativeWord setText:@""];
                    [_placeHolderLbl setText:@""];
                    [_txtNativeWord becomeFirstResponder];
                    [self.btnTrue setHidden:YES];
                    [self.btnFalse setHidden:YES];
                    [_textFieldBgView setImage:GetImage(@"containerBlueBorder")];
                    [_lblAnswer setHidden:NO];
                    [_placeHolderLbl setHidden:NO];
                    [_btnHint setHidden:NO];
                    [_lblAnswer setText:self.strCorrectAns];
                    
                    NSDate *olderDate = [Common dateFromString:[split lastObject]];
                    NSInteger timediff = [[NSDate date] timeIntervalSinceDate:olderDate];
                    NSLog(@"time in sec and min %d  %d",timediff,timediff/60);
                    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Average_Time set Counter = Counter + 1, Time = Time+%d where id = '2'",timediff/60]];
                    
                }
                
                NSInteger whiteCount = [[UserDefaluts objectForKey:kOrangeTestCount] integerValue]+1;
                [UserDefaluts setInteger:whiteCount forKey:kOrangeTestCount];
            }
            
            
            if(quesNo !=(SharedAppDelegate.totolQustCount+1))
                [self resumeTimer];
            
           
            
        }
    }
    else
    {
        
        [self pauseTimer];
        _progressBar.increament = 0;
        [_progressBar setNeedsDisplay];
        [self.btnTimer setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Finished", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Finished", nil];
        alert.tag = 1;
        [alert show];
    }
    
}



-(IBAction)submitAnswer:(id)sender
{
 
    
    if (sender) {
        
        if (_isOrangeTest1) {
            
            if([arrAnswers count]>0)
            {
                if([self.strCorrectAns isEqualToString:_txtNativeWord.text])
                {
                    [self playCorrectSong];
                    [self correctAnsAnimation];
                    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Orange', action = 'OrangeTest1',dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",testDate,lblTargetWord.text,self.strCorrectAns]];
                }
                else
                {
                    [self playIncorrectSong];
                    [self wrongAnsAnimation];
                    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'OrangeTest1',dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",testDate,lblTargetWord.text,self.strCorrectAns]];
                }
                
            }
            else
            {
                [self playIncorrectSong];
                [self wrongAnsAnimation];
                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'OrangeTest1',dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",testDate,lblTargetWord.text,self.strCorrectAns]];
            }
            
        } else {
            
            [self playCorrectSong];
            [self correctAnsAnimation];
            [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Green', action = 'OrangeTest2',dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",testDate,lblTargetWord.text,self.strCorrectAns]];
            
        }
        
    } else {
        
        
        [self playIncorrectSong];
        [self wrongAnsAnimation];
        
        if(_isOrangeTest1)
        [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'OrangeTest1',dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",testDate,lblTargetWord.text,self.strCorrectAns]];
        else
        [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'OrangeTest2',dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",testDate,lblTargetWord.text,self.strCorrectAns]];
    }
    optionNo = 0;
    [self getNewQuestion];
    [self getNewOption];
    
}



- (IBAction)submitClicked:(id)sender {
    
    if( ([self.strCorrectAns caseInsensitiveCompare:_txtNativeWord.text] == NSOrderedSame) && ([sender tag] !=100)) {
        
        [self submitAnswer:sender];
        
    } else {
        
        [_txtNativeWord setText:@""];
        _attemptForOT2++;
        switch (_attemptForOT2) {
            case 1:
            {
                NSString *dotString = @"";
                for (int k =0; k < self.strCorrectAns.length; k++) {
                
                    unichar space = [self.strCorrectAns characterAtIndex:k];
                    if ([[NSString stringWithFormat:@"%c",space] isEqualToString:@" "])
                        dotString = [dotString stringByAppendingString:@" "];
                     else 
                        dotString = [dotString stringByAppendingString:@" _"];
                    
                }
                
                [_placeHolderLbl setText:dotString];
                //[self selectTextForInput:_txtNativeWord atRange:NSMakeRange(0, 0)];
            }
                break;
                
            case 2:
            {
                
                NSString *dotString = @"";
                for (int k =0; k < self.strCorrectAns.length; k++) {
                    
                    if(k==0){
                        dotString = [dotString stringByAppendingString:[self.strCorrectAns substringToIndex:1]];
                        continue;
                    }
                    unichar space = [self.strCorrectAns characterAtIndex:k];
                    if ([[NSString stringWithFormat:@"%c",space] isEqualToString:@" "])
                        dotString = [dotString stringByAppendingString:@" "];
                    else
                        dotString = [dotString stringByAppendingString:@" _"];
                    
                }
                [_placeHolderLbl setText:dotString];
                [_txtNativeWord setText:[self.strCorrectAns substringToIndex:1]];
            
            }
                break;
            case 3:
            {
                [self.view setUserInteractionEnabled:NO];
                [_txtNativeWord setText:self.strCorrectAns];
                [_placeHolderLbl setText:self.strCorrectAns];
                [self pauseTimer];
                [self performSelector:@selector(makeSmallDealy) withObject:nil afterDelay:3.0];
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (void)makeSmallDealy
{
    [self.view setUserInteractionEnabled:YES];
    [self submitAnswer:nil];
}


- (IBAction)hintButtonClicked:(id)sender {
    
    if (_attemptForOT2<2) {
        
        [self submitClicked:sender];
    }
}

- (void)textChanged:(NSNotification *)notification
{
    //NSLog(@"nnoti is %@",notification);
    
    switch (_attemptForOT2) {
        case 0:
            [_placeHolderLbl setText:@""];
            break;
        case 1:
        case 2:
        {
            
            NSString *dotString = _txtNativeWord.text;
            for (int k = _txtNativeWord.text.length; k < self.strCorrectAns.length; k++) {
                unichar space = [self.strCorrectAns characterAtIndex:k];
                if ([[NSString stringWithFormat:@"%c",space] isEqualToString:@" "])
                    dotString = [dotString stringByAppendingString:@" "];
                else
                    dotString = [dotString stringByAppendingString:@" _"];
            }
            
            [_placeHolderLbl setText:dotString];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)checkWidhOfText:(NSString*)dotString
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    CGSize size = [dotString sizeWithFont:font];
    NSLog(@"widh is %f",size.width);
    
}

-(IBAction)trueClicked:(id)sender
{
    optionNo = 0;
    [self submitAnswer:sender];
    
}
-(IBAction)falseClicked:(id)sender
{
    if([self.strCorrectAns isEqualToString:_txtNativeWord.text])
        [self submitAnswer:nil];
    else
        [self getNewOption];
}

- (void)updateTimer:(NSTimer *)timer {
    
    NSInteger time = 0;
    time = [self.btnTimer.titleLabel.text integerValue]-1;
    if (time >= 0) {
        _progressBar.increament = _progressBar.increament+1;
        [_progressBar setNeedsDisplay];
        [self.btnTimer setTitle:[NSString stringWithFormat:@"%d",time] forState:UIControlStateNormal];
        //NSLog(@"times is %d",time);
        /*
        if (!_isOrangeTest1) {
            if(time ==15 || time==30)
            {
                 _attemptForOT2 = time == 15 ? 1 : 0;
                [self hintButtonClicked:(id)_btnHint];
            }
        }*/
        
        if(time == 0) {
            if (_isOrangeTest1)
                if([self.strCorrectAns isEqualToString:_txtNativeWord.text])
                    [self submitAnswer:nil];
                else
                [self getNewOption];
            else {
                 _attemptForOT2 = 2;
                [self submitClicked:(id)_btnHint];
            }
        }
     
    }
    
}

-(void)stopAnimation
{
    [self.lblAnimation setFrame:_lblFrame];
    [self.lblAnimation setText:self.lblTargetWord.text];
    
}

- (void)correctAnsAnimation
{
    [self.lblAnimation setText:self.lblTargetWord.text];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
    [UIView setAnimationDuration:0.4];
    self.lblAnimation.center = btnBucket2.center;
    [UIView commitAnimations];
}

- (void)wrongAnsAnimation
{
    [self.lblAnimation setText:self.lblTargetWord.text];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
    [UIView setAnimationDuration:0.4];
    self.lblAnimation.center = btnBucket1.center;
    [UIView commitAnimations];
}


#pragma mark alertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *nib = SharedAppDelegate.isPhone5 ? @"ResultsVC" : @"ResultsVCiPhone4";
    ResultsVC *test = [[ResultsVC alloc] initWithNibName:nib bundle:[NSBundle mainBundle]];
    test.lblColor = @"Orange";
    test.resultIdArray = _idArray;
    [self.navigationController pushViewController:test animated:YES];
}


#pragma mark UITextFieldDelegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (![[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"en"]) {
         textField.inputAccessoryView = _instructionLabel;
    }
   
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    BOOL checkContion = YES;
    
    if (_attemptForOT2==1){
    int length = [textField.text length] ;
    if (length >= self.strCorrectAns.length && ![string isEqualToString:@""]) {
        textField.text = [textField.text substringToIndex:self.strCorrectAns.length];
        checkContion =  NO;
    }
    }
    
    if (_attemptForOT2==2){
        int length = [textField.text length] ;
        NSLog(@"both lent is %d %d",length, self.strCorrectAns.length);
        if (length >= self.strCorrectAns.length && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:self.strCorrectAns.length];
            checkContion =  NO;
        }
    }
    
    if(_attemptForOT2==2){
    if (range.location==0 && range.length == 1)
        checkContion = NO;
    }
    
    return checkContion;
    /*
    if (_attemptForOT2 == 1 && (([_txtNativeWord.text rangeOfString:@"-"].location!=NSNotFound) || [_txtNativeWord.text rangeOfString:@" "].location!=NSNotFound)) {
        
        NSString *text = _txtNativeWord.text;
        NSRange newRange = NSMakeRange(range.location, 1);
        
        if(text.length > range.location) {
        unichar space = [text characterAtIndex:range.location];
        
        if ([[NSString stringWithFormat:@"%c",space] isEqualToString:@" "]) {
            text = [text stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:newRange];
        } else {
            text = [text stringByReplacingOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:newRange];
        }
        
        [_txtNativeWord setText:text];
        }
        [self selectTextForInput:_txtNativeWord atRange:range];
    }*/
    //return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) playSoundCorrectSound{
    
    //[audioPlayerCorrect play];
    NSLog(@"PLAY SOUND");
        
    
        
        SystemSoundID bell;
        AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"correctAns.mp3" ofType:nil]], &bell);
        AudioServicesPlaySystemSound (bell);
    
	
}

-(void) playSoundInCorrectSound{
    
    //[audioPlayerFalse play];
    NSLog(@"PLAY SOUND");
    
    SystemSoundID bell;
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"incorrectAns.mp3" ofType:nil]], &bell);
    AudioServicesPlaySystemSound (bell);
    
    
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
}

- (void)playCorrectSong
{
    [Common playCorrectSound];
    NSInteger whiteCount = [[UserDefaluts objectForKey:kCorrectCounter] integerValue]+1;
    [UserDefaluts setInteger:whiteCount forKey:kCorrectCounter];

}

- (void)playIncorrectSong
{
    [Common playIncorrectSound];

}

- (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}


- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRetakeOrangeTestNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self setTxtNativeWord:nil];
    [self setLblAnimation:nil];
    [self setMainTimer:nil];
    [self setSubmitButton:nil];
    [self setLblAnswer:nil];
    [self setPlaceHolderLbl:nil];
    [self setBtnHint:nil];
    [self setProgressBar:nil];
    [self setTotalQuestLabel:nil];
    [self setBtnTotalQues:nil];
    [self setDotsImageView:nil];
    [self setTextFieldBgView:nil];
    [self setInstructionLabel:nil];
    [super viewDidUnload];
}
@end
