//
//  AllTestViewC.m
//  WordBucket
//
//  Created by ashish on 2/18/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "AllTestViewC.h"
#import "NSMutableArray+Shuffling.h"
#import "ResultsVC.h"

@interface AllTestViewC ()

@end

@implementation AllTestViewC

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
    [self.btnFalse setTitle:falseStr forState:UIControlStateNormal];
    //[self.instructionLabel setText:NSLocalizedString(@"To give a letter an accent just hold it down and select the correct one.", nil)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLocalizedString];
    

    
    [_optionView setFrame:CGRectMake(0, SharedAppDelegate.isPhone5 ? 130 : 120, 320, SharedAppDelegate.isPhone5 ? 292 : 216)];
    //[_optionView setBackgroundColor:[UIColor colorWithPatternImage:GetImage(@"background")]];
    [self.view addSubview:_optionView];
    //[_optionView setHidden:YES];
    _arrQuesSeq = [[NSMutableArray alloc] init];
    _arrAnswers = [[NSMutableArray alloc] init];
    _idArray = [[NSMutableArray alloc] init];
    _lblFrame = self.lblTargetWord.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    NSInteger w1Count = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where (action = 'Saved' and bucketColor = 'White') or (bucketColor = 'Red')"]];
    NSInteger w2Count = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where action = 'WhiteTest1' and bucketColor = 'White'"]];
    NSInteger o1Count = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where action = 'WhiteTest2' and bucketColor = 'Orange'"]];
    NSInteger o2Count = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where action = 'OrangeTest1' and bucketColor = 'Orange'"]];
    
    NSLog(@"%d %d %d %d ",w1Count,w2Count,o1Count,o2Count);
    
    NSInteger w1Qust = ceil(((CGFloat)w1Count/(w1Count+w2Count+o1Count+o2Count))*SharedAppDelegate.totolQustCount);
     NSInteger w2Qust = ceil(((CGFloat)w2Count/(w1Count+w2Count+o1Count+o2Count))*SharedAppDelegate.totolQustCount);
     NSInteger o1Qust = ceil(((CGFloat)o1Count/(w1Count+w2Count+o1Count+o2Count))*SharedAppDelegate.totolQustCount);
     NSInteger o2Qust = ceil(((CGFloat)o2Count/(w1Count+w2Count+o1Count+o2Count))*SharedAppDelegate.totolQustCount);
    
     NSLog(@"Final count is  %d %d %d %d ",w1Qust,w2Qust,o1Qust,o2Qust);
    
    //arrTargetWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'Green' and id NOT IN(%@) ORDER BY RANDOM() LIMIT %d",idString,limit] withField:@"targetWord,id"];
    NSMutableArray *allWordArray = [[NSMutableArray alloc] init];
    
    // Get all white test L1 and red test 
    allWordArray = [[DBHelper sharedDbInstance] getAllValuesFromDictionaryTable:[NSString stringWithFormat:@"select * from tbl_Dictionary WHERE (bucketColor = 'White' and action = 'Saved') OR (bucketColor = 'Red') ORDER BY RANDOM() LIMIT %d",w1Qust]];
    
        for (int k = 0; k < [allWordArray count]; k++) {
            
            if(_arrQuesSeq.count<SharedAppDelegate.totolQustCount){
            NSMutableDictionary *dic = [allWordArray objectAtIndex:k];
            [dic setObject:kWhiteTest1 forKey:kTestType];
            [_arrQuesSeq addObject:dic];
            [_idArray addObject:[dic objectForKey:kId]];
            } else
                break;
        }
    [allWordArray removeAllObjects];allWordArray=nil;
    
    
    // Get all white test L2
    allWordArray = [[DBHelper sharedDbInstance] getAllValuesFromDictionaryTable:[NSString stringWithFormat:@"select * from tbl_Dictionary WHERE bucketColor = 'White' and action = 'WhiteTest1' ORDER BY RANDOM() LIMIT %d",w2Qust]];
    
    for (int k = 0; k < [allWordArray count]; k++) {
        if(_arrQuesSeq.count<SharedAppDelegate.totolQustCount){
        NSMutableDictionary *dic = [allWordArray objectAtIndex:k];
        [dic setObject:kWhiteTest2 forKey:kTestType];
        [_arrQuesSeq addObject:dic];
        [_idArray addObject:[dic objectForKey:kId]];
        } else
            break;
    }
    [allWordArray removeAllObjects];allWordArray=nil;
    
    
    // Get all orange test L1
    allWordArray = [[DBHelper sharedDbInstance] getAllValuesFromDictionaryTable:[NSString stringWithFormat:@"select * from tbl_Dictionary WHERE bucketColor = 'Orange' and action = 'WhiteTest2' ORDER BY RANDOM() LIMIT %d",o1Qust]];
    
    for (int k = 0; k < [allWordArray count]; k++) {
        if(_arrQuesSeq.count<SharedAppDelegate.totolQustCount){
        NSMutableDictionary *dic = [allWordArray objectAtIndex:k];
        [dic setObject:kOrangeTest1 forKey:kTestType];
        [_arrQuesSeq addObject:dic];
        [_idArray addObject:[dic objectForKey:kId]];
        } else
            break;
    }
    [allWordArray removeAllObjects];allWordArray=nil;
    
    // Get all orange test L2
    allWordArray = [[DBHelper sharedDbInstance] getAllValuesFromDictionaryTable:[NSString stringWithFormat:@"select * from tbl_Dictionary WHERE bucketColor = 'Orange' and action = 'OrangeTest1' ORDER BY RANDOM() LIMIT %d",o2Qust]];
    
    for (int k = 0; k < [allWordArray count]; k++) {
        
        if(_arrQuesSeq.count<SharedAppDelegate.totolQustCount){
        NSMutableDictionary *dic = [allWordArray objectAtIndex:k];
        [dic setObject:kOrangeTest2 forKey:kTestType];
        [_arrQuesSeq addObject:dic];
        [_idArray addObject:[dic objectForKey:kId]];
        } else
            break;
    }
    [allWordArray removeAllObjects];allWordArray=nil;
    NSLog(@"array quetion cound is %d  %d",_arrQuesSeq.count, _idArray.count);
    
    // Add timer view
    [self setUpTimerAndView];
    
    [_totalQuestLabel setText:[NSString stringWithFormat:@"/%d",SharedAppDelegate.totolQustCount]];
    
    [_arrQuesSeq shuffle];
    _attemptForOT2 = 0;
    self.testDate = [NSDate date];
    [UserDefaluts setObject:self.testDate forKey:@"CurrentTestDate"];
    optionNo = 0;
    [self getNewQuestion];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"All Test Screen";
    [SharedAppDelegate.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"All_Test" action:@"AllTest_Test_Begin" label:@"WordBucket-Free" value:nil] build]];
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
    if(_mainTimer){[_mainTimer invalidate];_mainTimer=nil;}
    [Common showTabBar:self.tabBarController];
}

- (void)receivePlayPauseNoti:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo objectForKey:kisAppActive] isEqualToString:@"1"]) {
        if(quesNo <= SharedAppDelegate.totolQustCount)
            _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        
    } else {
        
        [self pauseTimer];
    }
    
}



- (void)checkQuestiontypeWithString:(NSString*)qustType
{
    
    if ([qustType isEqualToString:kWhiteTest1]) {
        _questionType = 1;
    } else if ([qustType isEqualToString:kWhiteTest2]) {
        _questionType = 2;
    } else if ([qustType isEqualToString:kOrangeTest1]) {
        _questionType = 3;
    } else {
        _questionType = 4;
    }
}

- (void)getWhiteTest1
{
        _lblTargetWord.text = [[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kTargetWord];
        if(_arrAnswers)
            [_arrAnswers removeAllObjects];
        _arrAnswers = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE id != \"%@\" AND nativeWord != \"%@\" AND action !=\"\" GROUP BY nativeWord  ORDER BY RANDOM() LIMIT 3",[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kId],[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kNativeWord]] withField:@"nativeWord"];
            [_arrAnswers addObject:[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kNativeWord]];
            _strCorrectAns = [[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kNativeWord];
            NSLog(@"CORECT ANS IS %@",_strCorrectAns);
        
        
        //[_btnBucket2 setImage:[UIImage imageNamed:@"bucketWhite.png"] forState:UIControlStateNormal];
        [_optionView setHidden:NO];
    // Need to uncomment
    [self.arrAnswers shuffle];
    if([self.arrAnswers count]>0)
        [_firstOptButton setTitle:[self.arrAnswers objectAtIndex:0] forState:UIControlStateNormal];
    if([self.arrAnswers count]>1)
        [_secondOptButton setTitle:[self.arrAnswers objectAtIndex:1] forState:UIControlStateNormal];
    if([self.arrAnswers count]>2)
        [_thirdOptButton setTitle:[self.arrAnswers objectAtIndex:2] forState:UIControlStateNormal];
    if([self.arrAnswers count]>3)
        [_fourthOptButton setTitle:[self.arrAnswers objectAtIndex:3] forState:UIControlStateNormal];
    
    if ([[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kBucketColor] isEqualToString:@"Red"]) {
        
        NSInteger whiteCount = [[UserDefaluts objectForKey:kRedTestCount] integerValue]+1;
        [UserDefaluts setInteger:whiteCount forKey:kRedTestCount];
        [self updateAverageTimeWithDate:[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kdateOfTest] andid:1];
        
    } else {
    
        NSInteger whiteCount = [[UserDefaluts objectForKey:kWhiteTestCount] integerValue]+1;
        [UserDefaluts setInteger:whiteCount forKey:kWhiteTestCount];
    }
}

- (void)getWhiteTest2
{
        _lblTargetWord.text = [[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kNativeWord];
        if(_arrAnswers)
            [_arrAnswers removeAllObjects];
        _arrAnswers = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE id != \"%@\" AND targetWord != \"%@\" AND action !=\"\" GROUP BY targetWord  ORDER BY RANDOM() LIMIT 3",[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kId],[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kTargetWord]] withField:@"targetWord"];
    
            [_arrAnswers addObject:[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kTargetWord]];
            _strCorrectAns = [[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kTargetWord];
            NSLog(@"CORECT ANS IS %@",_strCorrectAns);
        //[_btnBucket2 setImage:[UIImage imageNamed:@"bucketOrange.png"] forState:UIControlStateNormal];
        [_optionView setHidden:NO];
        // Need to uncomment
    
    [self.arrAnswers shuffle];
    if([self.arrAnswers count]>0)
        [_firstOptButton setTitle:[self.arrAnswers objectAtIndex:0] forState:UIControlStateNormal];
    if([self.arrAnswers count]>1)
        [_secondOptButton setTitle:[self.arrAnswers objectAtIndex:1] forState:UIControlStateNormal];
    if([self.arrAnswers count]>2)
        [_thirdOptButton setTitle:[self.arrAnswers objectAtIndex:2] forState:UIControlStateNormal];
    if([self.arrAnswers count]>3)
        [_fourthOptButton setTitle:[self.arrAnswers objectAtIndex:3] forState:UIControlStateNormal];
    
    NSInteger whiteCount = [[UserDefaluts objectForKey:kWhiteTestCount] integerValue]+1;
    [UserDefaluts setInteger:whiteCount forKey:kWhiteTestCount];
    
    [self updateAverageTimeWithDate:[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kdateOfTest] andid:1];
    
    
}

//containerBlueBorder.png
//container116.png
- (void)getOrangeTest
{
    //UIImage *image = _questionType == 3 ? [UIImage imageNamed:@"bucketOrange.png"] : [UIImage imageNamed:@"bucketGreen.png"];
    //[_btnBucket2 setImage:image forState:UIControlStateNormal];
    [_txtNativeWord setHidden:NO];
    [_textFieldBgView setHidden:NO];
    
    
    _lblTargetWord.text = _questionType == 3 ? [[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kTargetWord] : [[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kNativeWord];
    
            _strCorrectAns = _questionType == 3 ? [[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kNativeWord] : [[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kTargetWord];
            NSLog(@"CORRECT ANSWER IS > %@",_strCorrectAns);
            
            if (_questionType == 3) {
                
                [_txtNativeWord resignFirstResponder];
                [_txtNativeWord setTextAlignment:NSTextAlignmentCenter];
                [_txtNativeWord setEnabled:NO];
                [_submitButton setHidden:YES];
                [self.btnTrue setHidden:NO];    
                [self.btnFalse setHidden:NO];
                [_lblAnswer setHidden:YES];
                [_btnHint setHidden:YES];
                [_placeHolderLbl setHidden:YES];
                [_textFieldBgView setImage:GetImage(@"container116")];
                if(_arrAnswers)
                    [_arrAnswers removeAllObjects];
                _arrAnswers = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE id != \"%@\" AND nativeWord != \"%@\" and action !=\"\" GROUP BY nativeWord  ORDER BY RANDOM() LIMIT 4",[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kId],_strCorrectAns] withField:@"nativeWord"];
                [_arrAnswers addObject:[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kNativeWord]];
                // Need to uncomment it, its only for testing
                [self.arrAnswers shuffle];
                optionNo = 0;
                [_dotsImageView setHidden:NO];
                [self getNewOption];
                
            } else {
                
                _attemptForOT2 = 0;
                [_textFieldBgView setImage:GetImage(@"containerBlueBorder")];
                [_submitButton setHidden:NO];
                [_txtNativeWord setEnabled:YES];
                [_txtNativeWord setTextAlignment:NSTextAlignmentLeft];
                [_txtNativeWord setText:@""];
                [_placeHolderLbl setText:@""];
                [_txtNativeWord becomeFirstResponder];
                [self.btnTrue setHidden:YES];
                [self.btnFalse setHidden:YES];
                [_lblAnswer setHidden:NO];
                [_btnHint setHidden:NO];
                [_placeHolderLbl setHidden:NO];
                [_lblAnswer setText:_strCorrectAns];
                
                [self updateAverageTimeWithDate:[[_arrQuesSeq objectAtIndex:quesNo-1] objectForKey:kdateOfTest] andid:1];
                
            }
    
    NSInteger whiteCount = [[UserDefaluts objectForKey:kOrangeTestCount] integerValue]+1;
    [UserDefaluts setInteger:whiteCount forKey:kOrangeTestCount];
            
}

- (void)makeOrangeTestFieldDiable
{
    [_placeHolderLbl setHidden:YES];
    [_btnHint setHidden:YES];
    [_txtNativeWord setText:@""];
    [_txtNativeWord resignFirstResponder];
    [_txtNativeWord setEnabled:NO];
    [_submitButton setHidden:YES];
    [_btnTrue setHidden:YES];
    [_btnFalse setHidden:YES];
    [_btnHint setHidden:YES];
    [_textFieldBgView setHidden:YES];
    [_txtNativeWord setHidden:YES];
    [_placeHolderLbl setHidden:YES];
}

-(void)getNewOption
{
    
    if(quesNo<=SharedAppDelegate.totolQustCount){
    if(optionNo < 5)
    {
        [_txtNativeWord setText:[self.arrAnswers objectAtIndex:optionNo]];
        optionNo++;
        NSString *imgName = [NSString stringWithFormat:@"dots%d",optionNo];
        [_dotsImageView setImage:GetImage(imgName)];
        if (_questionType==4)[_txtNativeWord setText:@""];
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
       [_btnTotalQues setTitle:[NSString stringWithFormat:@"%d",quesNo] forState:UIControlStateNormal];
        [self checkQuestiontypeWithString:[[_arrQuesSeq objectAtIndex:(quesNo-1)] objectForKey:kTestType]];
        [self makeOrangeTestFieldDiable];
        [_optionView setHidden:YES];
        [_dotsImageView setHidden:YES];
        switch (_questionType) {
            case 1:
                [self getWhiteTest1];
                break;
            case 2:
                [self getWhiteTest2];
                break;
            case 3:
                [self getOrangeTest];
                break;
            case 4:
                [self getOrangeTest];
                break;
                
            default:
                break;
        }
        
        
        if(quesNo != (SharedAppDelegate.totolQustCount+1))
            [self resumeTimer];
    }
    else
    {
        
        [_txtNativeWord resignFirstResponder];
        [_txtNativeWord setEnabled:NO];
        [self pauseTimer];
        _progressBar.increament = 0;
        [_progressBar setNeedsDisplay];
        [_btnTimer setTitle:@"0" forState:UIControlStateNormal];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Finished", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        alert.tag = 1;
        [alert show];
        return;
    }
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1) {
        
        NSString *nib = SharedAppDelegate.isPhone5 ? @"ResultsVC" : @"ResultsVCiPhone4";
        ResultsVC *test = [[ResultsVC alloc] initWithNibName:nib bundle:nil];
        test.lblColor = @"All";
        test.resultIdArray = _idArray;
        [self.navigationController pushViewController:test animated:YES];
    }
}




- (IBAction)submitClicked:(id)sender {
    
    if( ([_strCorrectAns caseInsensitiveCompare:_txtNativeWord.text] == NSOrderedSame) && ([sender tag] !=100)) {
        
        [self submitAnswer:sender];
        
    } else {
        
        [_txtNativeWord setText:@""];
        _attemptForOT2++;
        switch (_attemptForOT2) {
            case 1:
            {
                NSString *dotString = @"";
                for (int k =0; k < _strCorrectAns.length; k++) {
                    
                    unichar space = [_strCorrectAns characterAtIndex:k];
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
                for (int k =0; k < _strCorrectAns.length; k++) {
                    
                    if(k==0){
                        dotString = [dotString stringByAppendingString:[_strCorrectAns substringToIndex:1]];
                        continue;
                    }
                    unichar space = [_strCorrectAns characterAtIndex:k];
                    if ([[NSString stringWithFormat:@"%c",space] isEqualToString:@" "])
                        dotString = [dotString stringByAppendingString:@" "];
                    else
                        dotString = [dotString stringByAppendingString:@" _"];
                    
                }
                [_placeHolderLbl setText:dotString];
                [_txtNativeWord setText:[_strCorrectAns substringToIndex:1]];
                
            }
                break;
            case 3:
            {
                [self.view setUserInteractionEnabled:NO];
                [_txtNativeWord setText:_strCorrectAns];
                [_placeHolderLbl setText:_strCorrectAns];
                
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
    
    [self.view setUserInteractionEnabled:NO];
    [self submitAnswer:nil];
}


- (IBAction)hintButtonClicked:(id)sender {
    
    if (_attemptForOT2<2) {
        [self submitClicked:sender];
    }
}

- (void)textChanged:(NSNotification *)notification
{
    
    switch (_attemptForOT2) {
        case 0:
            [_placeHolderLbl setText:@""];
            break;
        case 1:
        case 2:
        {
            
            NSString *dotString = _txtNativeWord.text;
            for (int k = _txtNativeWord.text.length; k < _strCorrectAns.length; k++) {
                unichar space = [_strCorrectAns characterAtIndex:k];
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



- (IBAction)trueClicked:(id)sender {
    
    optionNo = 0;
    [self submitAnswer:sender];
}

- (IBAction)falseClicked:(id)sender {
    
    if([_strCorrectAns isEqualToString:_txtNativeWord.text])
        [self submitAnswer:nil];
    else
        [self getNewOption];
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
}

- (IBAction)optionButtonClicked:(id)sender {
    
    [self submitAnswer:sender];
    
}

- (void)pauseTimer
{
    if(_mainTimer){[_mainTimer invalidate];_mainTimer = nil;}
}

- (void)resumeTimer
{
    if(_mainTimer){[_mainTimer invalidate];_mainTimer = nil;}
    NSString *timeString = @"";//_questionType == 4 ? @"15s left" : @"5s left";
    _progressBar.increament = 0;
    
    switch (_questionType) {
        case 1:
        case 2:
            timeString = @"10";
            _progressBar.percent = 10;
            break;
        case 3:
            timeString = @"7";
            _progressBar.percent = 7;
            break;
        case 4:
            timeString = @"45";
            _progressBar.percent = 45;
            break;
        default:
            break;
    }
    
    [_progressBar setNeedsDisplay];
    [self.btnTimer setTitle:timeString forState:UIControlStateNormal];
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

- (void)updateTimer:(NSTimer *)timer {
    
    NSInteger time = 0;
    time = [self.btnTimer.titleLabel.text integerValue]-1;
    if (time >= 0) {
        
        _progressBar.increament = _progressBar.increament+1;
        //NSLog(@"time and per is %d %f",time,_progressBar.increament);
        [_progressBar setNeedsDisplay];
        [self.btnTimer setTitle:[NSString stringWithFormat:@"%d",time] forState:UIControlStateNormal];
        
        /*
        if (_questionType == 4){
            if(time ==15 || time==30)
            {
                _attemptForOT2 = time == 15 ? 1 : 0;
                [self hintButtonClicked:(id)_btnHint];
            }
            }*/
        
        if(time == 0) {
            if (_questionType==3)
                [self getNewOption];
            else if(_questionType == 4){
                _attemptForOT2 = 2;
                [self submitClicked:(id)_btnHint];
                
            } else
                 [self submitAnswer:nil];
        }
    }
    
}


- (void)trueAnswer
{
    [self playCorrectSong];
    [self correctAnsAnimation];
    switch (_questionType) {
        case 1:
            [self trueAnsForWhiteTest1];
            break;
        case 2:
            [self trueAnsForWhiteTest2];
            break;
        case 3:
            [self trueAnsForOrangeTest1];
            break;
        case 4:
            [self trueAnsForOrangeTest2];
            break;
            
        default:
            break;
    }
}


- (void)wrongAnswer
{
    
    [self playIncorrectSong];
    [self wrongAnsAnimation];
    switch (_questionType) {
        case 1:
            [self wrongAnsForWhiteTest1];
            break;
        case 2:
            [self wrongAnsForWhiteTest2];
            break;
        case 3:
            [self wrongAnsForOrangeTest1];
            break;
        case 4:
            [self wrongAnsForOrangeTest2];
            break;
            
        default:
            break;
    }
}


-(IBAction)submitAnswer:(id)sender
{
    @try {
        
        
    
    
    if (sender) {
        
        if (_questionType == 1 || _questionType == 2) {
            
            if([_strCorrectAns isEqualToString:[_arrAnswers objectAtIndex:[sender tag]-1]])
                [self trueAnswer];
            else 
                [self wrongAnswer];
          
        } else {
            
            if([_strCorrectAns caseInsensitiveCompare:_txtNativeWord.text] == NSOrderedSame/*[_strCorrectAns isEqualToString:_txtNativeWord.text]*/)
                [self trueAnswer];
             else 
                [self wrongAnswer];
            
        }
        
    } else {
        
        [self wrongAnswer];
        
    }
    
    
    }
    @catch (NSException *exception) {
        
        NSLog(@"execptio is %@",exception);
        [self stopAnimation];
    }
    //optionNo = 0;
    [self getNewQuestion];
    
}


- (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}


#pragma mark UITextFieldDelegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    textField.inputAccessoryView = _instructionLabel;
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
        if (length >= _strCorrectAns.length && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:_strCorrectAns.length];
            checkContion =  NO;
        }
    }
    
    if (_attemptForOT2==2){
        int length = [textField.text length] ;
        NSLog(@"both lent is %d %d",length, _strCorrectAns.length);
        if (length >= _strCorrectAns.length && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:_strCorrectAns.length];
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
    }
    return YES;*/
}

- (void)trueAnsForWhiteTest1
{
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'White', action = 'WhiteTest1', dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
}

- (void)trueAnsForWhiteTest2
{
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Orange', action = 'WhiteTest2', dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
}

- (void)trueAnsForOrangeTest1
{
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Orange', action = 'OrangeTest1',dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
}

- (void)trueAnsForOrangeTest2
{
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Green', action = 'OrangeTest2',dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
}

- (void)wrongAnsForWhiteTest1
{
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'WhiteTest1', dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
}

- (void)wrongAnsForWhiteTest2
{
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'WhiteTest2', dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
}

- (void)wrongAnsForOrangeTest1
{
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'OrangeTest1',dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
}

- (void)wrongAnsForOrangeTest2
{
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'OrangeTest2',dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
}

- (void)updateAverageTimeWithDate:(NSString*)olderDateStr andid:(NSInteger)idValue
{
    NSDate *olderDate = [Common dateFromString:olderDateStr];
    if (olderDate) {
        NSInteger timediff = [[NSDate date] timeIntervalSinceDate:olderDate];
        NSLog(@"time in sec and min %d  %d",timediff,timediff/60);
        [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Average_Time set Counter = Counter + 1, Time = Time+%d where id = '%d'",timediff/60,idValue]];
    }
}



-(void)stopAnimation
{
    [self.view setUserInteractionEnabled:YES];
    [self.lblAnimation setFrame:_lblFrame];
    [self.lblAnimation setText:self.lblTargetWord.text];
    switch (_questionType) {
        case 1:
            [_btnBucket2 setImage:[UIImage imageNamed:@"bucketWhite.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [_btnBucket2 setImage:[UIImage imageNamed:@"bucketOrange.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [_btnBucket2 setImage:[UIImage imageNamed:@"bucketOrange.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [_btnBucket2 setImage:[UIImage imageNamed:@"bucketGreen.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
}

- (void)correctAnsAnimation
{
    [self.view setUserInteractionEnabled:NO];
    [self.lblAnimation setText:self.lblTargetWord.text];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
    [UIView setAnimationDuration:0.4];
    self.lblAnimation.center = self.btnBucket2.center;
    [UIView commitAnimations];
}

- (void)wrongAnsAnimation
{
    [self.view setUserInteractionEnabled:NO];
    [self.lblAnimation setText:self.lblTargetWord.text];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
    [UIView setAnimationDuration:0.4];
    self.lblAnimation.center = self.btnBucket1.center;
    [UIView commitAnimations];
}


#pragma mark - Play sound
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setIdArray:nil];
    [self setArrAnswers:nil];
    [self setArrQuesSeq:nil];
    [self setOptionView:nil];
    [self setFirstOptButton:nil];
    [self setSecondOptButton:nil];
    [self setThirdOptButton:nil];
    [self setFourthOptButton:nil];
    [self setLblAnimation:nil];
    [self setLblTargetWord:nil];
    [self setBtnTotalQues:nil];
    [self setBtnTimer:nil];
    [self setSubmitButton:nil];
    [self setBtnFalse:nil];
    [self setBtnFalse:nil];
    [self setBtnTrue:nil];
    [self setBtnBucket1:nil];
    [self setBtnBucket2:nil];
    [self setTxtNativeWord:nil];
    [self setLblAnswer:nil];
    [self setMainTimer:nil];
    [self setPlaceHolderLbl:nil];
    [self setBtnHint:nil];
    [self setProgressBar:nil];
    [self setTotalQuestLabel:nil];
    [self setDotsImageView:nil];
    [self setInstructionLabel:nil];
    [super viewDidUnload];
}


@end
