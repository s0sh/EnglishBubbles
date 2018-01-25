//
//  WhiteTestViewController.m
//  WordBucket
//
//  Created by Mehak Bhutani on 1/23/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "WhiteTestViewController.h"
#import "Common.h"
#import "ResultsVC.h"
#import "NSMutableArray+Shuffling.h"
#import "SynchronizationModel.h"
@interface WhiteTestViewController ()

@end

@implementation WhiteTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    // Do any additional setup after loading the view from its nib.
    // Setup WhiteTest1 and WhiteTest2 question
    
    _orgnlFrame = self.lblTargetWord.frame;
    
    quesNo = 0;
    _arrQuesSeq = [[NSMutableArray alloc] init];
    _idArray = [[NSMutableArray alloc] init];
    _arrAnswers = [[NSMutableArray alloc] init];
    if ([_strTestColor isEqualToString:@"RedTest"]) {
        [_arrQuesSeq addObject:@"RedTest"];
        
    } else {
    
        NSInteger w1Count = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where action = 'Saved' and bucketColor = 'White'"]];
        NSInteger w2Count = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where action = 'WhiteTest1' and bucketColor = 'White'"]];
        NSInteger w1Qust = ceil(((CGFloat)w1Count/(w1Count+w2Count))*SharedAppDelegate.totolQustCount);
        NSInteger w2Qust = SharedAppDelegate.totolQustCount-w1Qust;
        NSLog(@"w1 and w2 w1qust w2qust is %d %d %d %d",w1Count,w2Count,w1Qust,w2Qust);
        
        for (int k =1; k <= w2Qust; k++) {[_arrQuesSeq addObject:@"WhiteTest2"];}
        for (int k =1; k <= w1Qust; k++) {[_arrQuesSeq addObject:@"WhiteTest1"];}
        
        
    }
    
    [_arrQuesSeq shuffle];
    self.testDate = [NSDate date];
    [UserDefaluts setObject:self.testDate forKey:@"CurrentTestDate"];
    [self getNewQuestion];
    
    
    _prgressBar = [[ProgressView alloc] initWithFrame:CGRectMake(248, 55, 60, 60) isSmallSize:NO];
    _prgressBar.percent = 10;
    _prgressBar.increament = 0;
    [self.view addSubview:_prgressBar];
    [self.view bringSubviewToFront:self.btnTimer];
    
    [_totalQuestLabel setText:[NSString stringWithFormat:@"/%d",SharedAppDelegate.totolQustCount]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"White Test Screen";
    [SharedAppDelegate.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"White_Test" action:@"White_Test_Begin" label:@"WordBucket-Free" value:nil] build]];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayPauseNoti:) name:kPauseWhenAppGoesInBack object:nil];
    [Common hideTabBar:self.tabBarController];
    NSLog(@"viw will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPauseWhenAppGoesInBack object:nil];
    if(_mainTimer){[_mainTimer invalidate];_mainTimer=nil;}
    [Common showTabBar:self.tabBarController];
     NSLog(@"viw will disappear");
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




- (void)pauseTimer
{
    if(_mainTimer){[_mainTimer invalidate];_mainTimer = nil;}
}

- (void)resumeTimer
{
    
    if(_mainTimer){[_mainTimer invalidate];_mainTimer = nil;}
    //NSString *timeString = _isOrangeTest1 ? @"5s left" : @"10s left";
    _prgressBar.increament = 0;
    [_prgressBar setNeedsDisplay];
    [self.btnTimer setTitle:[NSString stringWithFormat:@"10"] forState:UIControlStateNormal];
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
     
}



-(void) getWhiteTest1
{    
    whiteTest = 1;
    NSString *idString = [Common getStringValueSeperatedByCommaWithArray:_idArray];
    NSMutableArray *arrNewWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'White' and action = 'Saved' and id NOT IN(%@) ORDER BY RANDOM() LIMIT 1",idString] withField:@"targetWord , id, nativeWord"];
    if([arrNewWord count]>0)
    {
        NSArray *split = [[arrNewWord objectAtIndex:0] componentsSeparatedByString:@"/|"];
        if(split.count>2){
            _lblTargetWord.text = [split objectAtIndex:0];
            [_idArray addObject:[split objectAtIndex:1]];
            _strCorrectAns = [split objectAtIndex:2];
        }
        
//        NSMutableArray *arrCorrectWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'White' and action = 'Saved' and targetWord = \"%@\"",[split objectAtIndex:0]] withField:@"nativeWord"];
//        if([arrCorrectWord count]>0)
//        {
//            _strCorrectAns = [arrCorrectWord objectAtIndex:0];
//        }
        
        
        if(_arrAnswers)
            [_arrAnswers removeAllObjects];
        _arrAnswers = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE nativeWord != \"%@\" and action !=\"\" GROUP BY nativeWord ORDER BY RANDOM() LIMIT 3",_strCorrectAns] withField:@"nativeWord"];
        
       [_arrAnswers addObject:_strCorrectAns];
        NSLog(@"CORRECT ANS IS %@",_strCorrectAns);
        
        NSInteger whiteCount = [[UserDefaluts objectForKey:kWhiteTestCount] integerValue]+1;
        [UserDefaluts setInteger:whiteCount forKey:kWhiteTestCount];
        //[_btnBucket2 setImage:[UIImage imageNamed:@"bucketWhite.png"] forState:UIControlStateNormal];
    }
}
-(BOOL) getWhiteTest2
{
    whiteTest = 2;
   NSString *idString = [Common getStringValueSeperatedByCommaWithArray:_idArray];
    NSMutableArray *arrNewWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'White' and action = 'WhiteTest1' and id NOT IN(%@) ORDER BY RANDOM() LIMIT 1",idString] withField:@"nativeWord , id, dateOfTest, targetWord"];
    if([arrNewWord count]>0)
    {
        NSArray *split = [[arrNewWord objectAtIndex:0] componentsSeparatedByString:@"/|"];
        if(split.count>3){
        [_idArray addObject:[split objectAtIndex:1]];
        _strCorrectAns = [split objectAtIndex:3];
        _lblTargetWord.text = [split objectAtIndex:0];
        }
        
//        NSMutableArray *arrCorrectWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'White' and action = 'WhiteTest1' and nativeWord = \"%@\"",[split objectAtIndex:0]] withField:@"targetWord"];
//        if([arrCorrectWord count]>0)
//        {
//            
//            _strCorrectAns = [arrCorrectWord objectAtIndex:0];
//        }
        
        if(_arrAnswers)
            [_arrAnswers removeAllObjects];
        _arrAnswers = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE targetWord != \"%@\" and action !=\"\" GROUP BY targetWord ORDER BY RANDOM() LIMIT 3",_strCorrectAns] withField:@"targetWord"];
        
        [_arrAnswers addObject:_strCorrectAns];
        NSLog(@"CORRECT ANS IS %@",_strCorrectAns);
                
        //[_btnBucket2 setImage:[UIImage imageNamed:@"bucketOrange.png"] forState:UIControlStateNormal];
        NSInteger whiteCount = [[UserDefaluts objectForKey:kWhiteTestCount] integerValue]+1;
        [UserDefaluts setInteger:whiteCount forKey:kWhiteTestCount];
        
        NSDate *olderDate = [Common dateFromString:[split lastObject]];
        if(olderDate){
        NSInteger timediff = [[NSDate date] timeIntervalSinceDate:olderDate];
        [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Average_Time set Counter = Counter + 1, Time = Time+%d where id = '1'",timediff/60]];
        }
        
        return YES;
    }
 return NO;

}


-(void) getRedTest
{
    whiteTest = 3;
    NSString *idString = [Common getStringValueSeperatedByCommaWithArray:_idArray];
    NSLog(@"id string is %@",idString);
    NSMutableArray *arrNewWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'Red' and id NOT IN(%@) ORDER BY RANDOM() LIMIT 1",idString] withField:@"targetWord , action , id, dateOfTest, nativeWord"];
    
    if([arrNewWord count]>0)
    {
        NSArray *split = [[arrNewWord objectAtIndex:0] componentsSeparatedByString:@"/|"];
        if (split.count > 4) {
            [_idArray addObject:[split objectAtIndex:2]];
            _lblTargetWord.text = [split objectAtIndex:0];
            _strCorrectAns = [split objectAtIndex:4];
        }
        
        
//        NSMutableArray *arrCorrectWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'Red' and action = \"%@\" and targetWord = \"%@\"",[split objectAtIndex:1],[split objectAtIndex:0]] withField:@"nativeWord"];
//        if([arrCorrectWord count]>0)
//        {
//            
//            _strCorrectAns = [arrCorrectWord objectAtIndex:0];
//        }
        
        if(_arrAnswers)
            [_arrAnswers removeAllObjects];
        _arrAnswers = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE nativeWord != \"%@\" and action !=\"\" GROUP BY nativeWord ORDER BY RANDOM() LIMIT 3",_strCorrectAns] withField:@"nativeWord"];
        
        [_arrAnswers addObject:_strCorrectAns];
        NSLog(@"CORRECT ANS IS %@",_strCorrectAns);
        
        NSInteger whiteCount = [[UserDefaluts objectForKey:kRedTestCount] integerValue]+1;
        [UserDefaluts setInteger:whiteCount forKey:kRedTestCount];
        
        NSDate *olderDate = [Common dateFromString:[split lastObject]];
        if (olderDate){
        NSInteger timediff = [[NSDate date] timeIntervalSinceDate:olderDate];
        NSLog(@"time in sec and min %d  %d",timediff,timediff/60);
        [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Average_Time set Counter = Counter + 1, Time = Time+%d where id = '4'",timediff/60]];
        }
        
        
    }
    
    
}


-(void) getNewQuestion
{
    
    quesNo++;
    int testWord = SharedAppDelegate.totolQustCount;
    if(quesNo <= testWord)
    {
        [_btnTotalQues setTitle:[NSString stringWithFormat:@"%d",quesNo] forState:UIControlStateNormal];
            
        if([_strTestColor isEqualToString:@"WhiteTest"])
        {
            if([[_arrQuesSeq objectAtIndex:quesNo-1] isEqualToString:@"WhiteTest1"])
                [self getWhiteTest1];
            else
            {
                if(![self getWhiteTest2])
                    [self getWhiteTest1];
            }
        }
        else
            [self getRedTest];
        // Need to uncomment when sending build to client
        [self.arrAnswers shuffle];
        if([self.arrAnswers count]>0)
            [_btnOption1 setTitle:[self.arrAnswers objectAtIndex:0] forState:UIControlStateNormal];
        if([self.arrAnswers count]>1)
            [_btnOption2 setTitle:[self.arrAnswers objectAtIndex:1] forState:UIControlStateNormal];
        if([self.arrAnswers count]>2)
            [_btnOption3 setTitle:[self.arrAnswers objectAtIndex:2] forState:UIControlStateNormal];
        if([self.arrAnswers count]>3)
            [_btnOption4 setTitle:[self.arrAnswers objectAtIndex:3] forState:UIControlStateNormal];
        
        if(quesNo !=(SharedAppDelegate.totolQustCount+1))
            [self resumeTimer];
    }
    else
    {
        
        [self pauseTimer];
        [self.btnTimer setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        _prgressBar.increament = 0;
        [_prgressBar setNeedsDisplay];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Finished", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Finished", nil];
        alert.tag = 1;
        [alert show];
        return;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateTimer:(NSTimer *)timer {
    
    
    NSInteger time = 0;
    time = [self.btnTimer.titleLabel.text integerValue]-1;
    if (time >= 0) {
        [self.btnTimer setTitle:[NSString stringWithFormat:@"%d",time] forState:UIControlStateNormal];
        _prgressBar.increament = _prgressBar.increament+1;
        [_prgressBar setNeedsDisplay];
        if(time == 0)
            [self submitAnswer:nil];
    }
    
    
    
}

-(void)stopAnimation
{
    [self.view setUserInteractionEnabled:YES];
    [self.lblAnimation setFrame:_orgnlFrame];
    [self.lblAnimation setText:self.lblTargetWord.text];
    if (whiteTest ==2) 
        [_btnBucket2 setImage:[UIImage imageNamed:@"bucketOrange.png"] forState:UIControlStateNormal];
    else
        [_btnBucket2 setImage:[UIImage imageNamed:@"bucketWhite.png"] forState:UIControlStateNormal];
    
}

-(IBAction) submitAnswer:(id)sender
{
    
    @try {
        
    
    [self.lblAnimation setText:self.lblTargetWord.text];
     NSMutableDictionary *params = [NSMutableDictionary new];
    if(sender)
    {
        UIButton *btnOption = (UIButton *)sender;
        
        if([_strCorrectAns isEqualToString:[_arrAnswers objectAtIndex:btnOption.tag-1]])
        {
            
            [self.view setUserInteractionEnabled:NO];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
            [UIView setAnimationDuration:0.4];
            self.lblAnimation.center = _btnBucket2.center;
            [UIView commitAnimations];
            
           
            
            
            //[[Common sharedInstance] playSound:self fileName:@"correctAns"];
            [self playCorrectSong];
            if(whiteTest == 1){
                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'White', action = 'WhiteTest1', dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
             [params setObject:@"White" forKey:kBucketColor];
             [params setObject:_lblTargetWord.text forKey:kTargetWord];
             [params setObject:_strCorrectAns forKey:kNativeWord];
             
            }else if(whiteTest == 2){
                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Orange', action = 'WhiteTest2', dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
             [params setObject:@"Orange" forKey:kBucketColor];
             [params setObject:_lblTargetWord.text forKey:kNativeWord];
             [params setObject:_strCorrectAns forKey:kTargetWord];
            }else{
                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'White', action = 'WhiteTest1', dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
             
             [params setObject:@"White" forKey:kBucketColor];
             [params setObject:_lblTargetWord.text forKey:kTargetWord];
             [params setObject:_strCorrectAns forKey:kTargetWord];
            }
            [[SynchronizationModel currentObject] prepareJsonWithNewWord:params];
            
        }
        else
        {
            [self.view setUserInteractionEnabled:NO];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
            [UIView setAnimationDuration:0.4];
            self.lblAnimation.center = _btnBucket1.center;
            [UIView commitAnimations];
            
            //[[Common sharedInstance] playSound:self fileName:@"incorrectAns"];
            [self playIncorrectSong];
            if(whiteTest == 1){
                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'WhiteTest1', dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
                [params setObject:@"Red" forKey:kBucketColor];
                [params setObject:_lblTargetWord.text forKey:kTargetWord];
                [params setObject:_strCorrectAns forKey:kNativeWord];
            }
            else if(whiteTest == 2){
                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'WhiteTest2', dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
            
                [params setObject:@"Red" forKey:kBucketColor];
                [params setObject:_lblTargetWord.text forKey:kNativeWord];
                [params setObject:_strCorrectAns forKey:kTargetWord];
            }
            else{
                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'WhiteTest1', dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
                
                [params setObject:@"Red" forKey:kBucketColor];
                [params setObject:_lblTargetWord.text forKey:kTargetWord];
                [params setObject:_strCorrectAns forKey:kNativeWord];
                
            }

        }
    
        [[SynchronizationModel currentObject] prepareJsonWithNewWord:params];
    }
    else
    {
        [self.view setUserInteractionEnabled:NO];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
        [UIView setAnimationDuration:0.4];
        self.lblAnimation.center = _btnBucket1.center;
        [UIView commitAnimations];
        //[[Common sharedInstance] playSound:self fileName:@"incorrectAns"];
        [self playIncorrectSong];
        if(whiteTest == 1){
            [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'WhiteTest1', dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
            [params setObject:@"Red" forKey:kBucketColor];
            [params setObject:_lblTargetWord.text forKey:kTargetWord];
            [params setObject:_strCorrectAns forKey:kNativeWord];
        }
        else if(whiteTest == 2){
            [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'WhiteTest2', dateOfTest=\"%@\" WHERE nativeWord = \"%@\" AND targetWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
            
            [params setObject:@"Red" forKey:kBucketColor];
            [params setObject:_lblTargetWord.text forKey:kNativeWord];
            [params setObject:_strCorrectAns forKey:kTargetWord];
        }
        else{
            [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'WhiteTest1', dateOfTest=\"%@\" WHERE targetWord = \"%@\" AND nativeWord = \"%@\"",self.testDate,_lblTargetWord.text,_strCorrectAns]];
        
            [params setObject:@"Red" forKey:kBucketColor];
            [params setObject:_lblTargetWord.text forKey:kTargetWord];
            [params setObject:_strCorrectAns forKey:kNativeWord];
        
        }
        
        [[SynchronizationModel currentObject] prepareJsonWithNewWord:params];
    }
    
    }
    @catch (NSException *exception) {
        
        [self stopAnimation];
        
    }
    //[_btnTimer setTitle:@"5" forState:UIControlStateNormal];
    [self getNewQuestion];
    
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
}


#pragma mark alertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSString *nib = SharedAppDelegate.isPhone5 ? @"ResultsVC" : @"ResultsVCiPhone4";
    ResultsVC *test = [[ResultsVC alloc] initWithNibName:nib bundle:nil];
    if(whiteTest == 3)
        test.lblColor = @"Red";
    else
        test.lblColor = @"White";
    test.resultIdArray = _idArray;
    [self.navigationController pushViewController:test animated:YES];
}

- (void)playCorrectSong
{
    
    
    [Common playCorrectSound];
//    SystemSoundID bell;
//    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CORRECT.wav" ofType:nil]], &bell);
//    AudioServicesPlaySystemSound (bell);
    
    NSInteger whiteCount = [[UserDefaluts objectForKey:kCorrectCounter] integerValue]+1;
    [UserDefaluts setInteger:whiteCount forKey:kCorrectCounter];
    
    NSLog(@"CORRECT COUNTER >>>>>>>>>>>>> %@",[UserDefaluts objectForKey:kCorrectCounter]);

}

- (void)playIncorrectSong
{
    
    [Common playIncorrectSound];
//    SystemSoundID bell;
//    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"INCORRECT.wav" ofType:nil]], &bell);
//    AudioServicesPlaySystemSound (bell);

}


- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRetakeWhiteTestNotification object:nil];
    
    [self pauseTimer];
    [self setStrTestColor:nil];
    [self setStrTarget:nil];
    [self setStrCorrectAns:nil];
    [self setLblAnimation:nil];
    [self setIdArray:nil];
    [self setMainTimer:nil];
    [self setStrNative:nil];
    [self setLblTargetWord:nil];
    [self setBtnOption1:nil];
    [self setBtnOption2:nil];
    [self setBtnOption3:nil];
    [self setBtnOption4:nil];
    [self setBtnBucket1:nil];
    [self setBtnBucket2:nil];
    [self setBtnTotalQues:nil];
    [self setBtnTimer:nil];
    [self setPrgressBar:nil];
    /*
    UIImageView *imgOption1;
    UIImageView *imgOption2;
    UIImageView *imgOption3;
    UIImageView *imgOption4;
    */
    [self setTotalQuestLabel:nil];
    [super viewDidUnload];
}
@end
