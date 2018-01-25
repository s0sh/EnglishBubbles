//
//  GreenTestVCViewController.m
//  WordBucket
//
//  Created by Mehak Bhutani on 1/22/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "GreenTestVCViewController.h"
#import "ResultsVC.h"
#import "PreGreenTestVC.h"

#define buttonFont [UIFont fontWithName:@"Helvetica-Bold" size:12.0]

@interface GreenTestVCViewController ()

@end

@implementation GreenTestVCViewController
@synthesize arrTargetWords,arrNativeWords;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void) getWords
{
    
    _pairCount++;
     NSString *idString = [Common getStringValueSeperatedByCommaWithArray:_qustIdArray];
    arrTargetWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = 'Green' and id NOT IN(%@) and %@ ORDER BY RANDOM() LIMIT %d",idString,_actionString,limit] withField:@"targetWord,id,nativeWord"];
    NSInteger wordCount = [_bucketLabel.text integerValue];
    [_bucketLabel setText:[NSString stringWithFormat:@"%d",wordCount+limit]];
    
    
}


- (void)animateButton:(UIButton*)button
{
    
    CGRect finalFrame = button.frame;
    [button setFrame:_firstFrame];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.8];
    [button setFrame:finalFrame];
    [UIView commitAnimations];
     
    
}

- (void)assignWordsOnAllView
{
    
    for (int k = 0; k < [arrTargetWords count]; k++) {
        
         NSArray *split = [[arrTargetWords objectAtIndex:k] componentsSeparatedByString:@"/|"];
        UIPanGestureRecognizer *targetPanGesturet = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        targetPanGesturet.delegate =self;
        UIButton *btntarget = (UIButton*)[self.view viewWithTag:(k+1)];
        [self animateButton:btntarget];
        [btntarget setTitle:[split objectAtIndex:0] forState:UIControlStateNormal];
        [btntarget setTitle:[split objectAtIndex:1] forState:UIControlStateSelected];
        [btntarget setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btntarget.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [btntarget addGestureRecognizer:targetPanGesturet];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate =self;
        UIButton *btnnative = (UIButton*)[self.view viewWithTag:(k+7)];
        [self animateButton:btnnative];
        [btnnative setTitle:[split objectAtIndex:2] forState:UIControlStateNormal];
        [btnnative setTitle:[split objectAtIndex:1] forState:UIControlStateSelected];
        [btnnative setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnnative.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [btnnative addGestureRecognizer:panGesture];
        
        [_qustIdArray addObject:[split objectAtIndex:1]];
    }
    
}


- (CGRect)getRandomRect
{
    
    NSMutableArray *btnRectArry = [[NSMutableArray alloc] init];
    for (int i = 1; i <=12 ; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        if (btn)
            [btnRectArry addObject:[NSValue valueWithCGRect:btn.frame]];
        
    }
    
    float randomX = arc4random()%(NSInteger)(self.view.frame.size.width);
    int randomY = arc4random()%(NSInteger)(self.view.frame.size.height);
    
    CGRect randomRect = CGRectMake(randomX, randomY,_isiPhone5 ? 125 : 100, 30);
    
    
    
    for (int k =0; k < [_rectArray count]; k++) {
        BOOL isSend = YES;
        CGRect btnRect = [[_rectArray objectAtIndex:k] CGRectValue];
        for (int i = 0; i < [btnRectArry count]; i++) {
            
            if (CGRectIntersectsRect(btnRect, [[btnRectArry objectAtIndex:i] CGRectValue])) {
                isSend = NO;
                //break;
            }
            
        }
        
        if (isSend) {
           // NSLog(@"btn rect %@",btnRectArry);
           // NSLog(@"random rect is %f %f",btnRect.origin.x,btnRect.origin.y);
                return btnRect;
        }
    }
    
    return randomRect;
    
}


- (void)addRestButtons
{
    limit = [_arrNativeTag count];
    [arrTargetWords removeAllObjects];arrTargetWords=nil;
    arrTargetWords = [[NSMutableArray alloc] init];
    [self getWords];
    
    NSLog(@"tag array is %@ %@",[Common getStringValueSeperatedByCommaWithArray:_arrTargetTag],[Common getStringValueSeperatedByCommaWithArray:_arrNativeTag]);
    for (int k = 0; k < [arrTargetWords count]; k++) {
        
        NSArray *split = [[arrTargetWords objectAtIndex:k] componentsSeparatedByString:@"/|"];
        UIPanGestureRecognizer *targetPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        targetPanGesture.delegate =self;
        UIButton *targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [targetBtn setBackgroundImage:GetImage(@"word3") forState:UIControlStateNormal];
        [targetBtn setBackgroundImage:GetImage(@"word3Pressed") forState:UIControlStateHighlighted];
        [targetBtn setTag:[[_arrTargetTag objectAtIndex:k] intValue]];
        [targetBtn setTitle:[split objectAtIndex:0] forState:UIControlStateNormal];
        [targetBtn setTitle:[split objectAtIndex:1] forState:UIControlStateSelected];
        [targetBtn setFrame:[self getRandomRect]];
        [targetBtn.titleLabel setFont:buttonFont];
        [targetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [targetBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self animateButton:targetBtn];
        [self.view addSubview:targetBtn];
        [targetBtn addGestureRecognizer:targetPanGesture];
        NSLog(@"taget tag and origin  %d %f %f",targetBtn.tag,targetBtn.frame.origin.x,targetBtn.frame.origin.y);
        
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate =self;
        UIButton *nativeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nativeBtn setBackgroundImage:GetImage(@"word3") forState:UIControlStateNormal];
        [nativeBtn setBackgroundImage:GetImage(@"word3Pressed") forState:UIControlStateHighlighted];
        [nativeBtn setTag:[[_arrNativeTag objectAtIndex:k] intValue]];
        [nativeBtn setTitle:[split objectAtIndex:2] forState:UIControlStateNormal];
        [nativeBtn setTitle:[split objectAtIndex:1] forState:UIControlStateSelected];
        [nativeBtn setFrame:[self getRandomRect]];
        [nativeBtn.titleLabel setFont:buttonFont];
        [nativeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nativeBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self animateButton:nativeBtn];
        [self.view addSubview:nativeBtn];
        [nativeBtn addGestureRecognizer:panGesture];
        NSLog(@"taget tag and origin  %d %f %f",nativeBtn.tag,nativeBtn.frame.origin.x,nativeBtn.frame.origin.y);

        
        [_qustIdArray addObject:[split objectAtIndex:1]];
    }
    
    
    [_arrNativeTag removeAllObjects];
    [_arrTargetTag removeAllObjects];
}

- (void)setLocalization
{
    [self.gamePausedLabel setText:NSLocalizedString(@"Game Paused!", nil)];
    [self.resumeLabel setText:NSLocalizedString(@"Resume", nil)];
    [self.restartLabel setText:NSLocalizedString(@"Restart", nil)];
    [self.quitLabel setText:NSLocalizedString(@"Quit", nil)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLocalization];
    [self.navigationController setNavigationBarHidden:YES];
    NSLog(@"self tab bar %@",self.tabBarController);
    [Common hideTabBar:self.tabBarController];
    _isiPhone5 = SharedAppDelegate.isPhone5;

    if (SharedAppDelegate.isPhone5) {
        
        _bgImageView.image = _isGreenTest ? GetImage(@"greenBg-5") : GetImage(@"backgroundHorizontal-iphone5");
    } else {
        _bgImageView.image = _isGreenTest ? GetImage(@"greenBg") : GetImage(@"backgroundHorizontal");
    }
    
    _pairCount = 0;
    _firstFrame = CGRectMake(15, 210, _isiPhone5?125:100, 30);
    
    if (_isiPhone5) {
        
        
        _rectArray = [[NSMutableArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(77, 10, 125, 30)],[NSValue valueWithCGRect:CGRectMake(178, 10, 125, 30)],[NSValue valueWithCGRect:CGRectMake(280, 10, 125, 30)],[NSValue valueWithCGRect:CGRectMake(77, 41, 125, 30)],[NSValue valueWithCGRect:CGRectMake(178, 41, 125, 30)],[NSValue valueWithCGRect:CGRectMake(280, 41, 125, 30)],[NSValue valueWithCGRect:CGRectMake(14, 72, 125, 30)],[NSValue valueWithCGRect:CGRectMake(114, 72, 125, 30)],[NSValue valueWithCGRect:CGRectMake(215, 72, 125, 30)],[NSValue valueWithCGRect:CGRectMake(315, 72, 125, 30)],[NSValue valueWithCGRect:CGRectMake(40, 102, 125, 30)],[NSValue valueWithCGRect:CGRectMake(140, 102, 125, 30)],[NSValue valueWithCGRect:CGRectMake(240, 102, 125, 30)],[NSValue valueWithCGRect:CGRectMake(340, 102, 125, 30)],[NSValue valueWithCGRect:CGRectMake(70, 133, 125, 30)],[NSValue valueWithCGRect:CGRectMake(170, 133, 125, 30)],[NSValue valueWithCGRect:CGRectMake(270, 133, 125, 30)],[NSValue valueWithCGRect:CGRectMake(370, 133, 125, 30)],[NSValue valueWithCGRect:CGRectMake(158, 165, 125, 30)],[NSValue valueWithCGRect:CGRectMake(260, 165, 125, 30)],[NSValue valueWithCGRect:CGRectMake(362, 165, 125, 30)],[NSValue valueWithCGRect:CGRectMake(145, 195, 125, 30)],[NSValue valueWithCGRect:CGRectMake(247, 195, 125, 30)],[NSValue valueWithCGRect:CGRectMake(349, 195, 125, 30)],[NSValue valueWithCGRect:CGRectMake(137, 225, 125, 30)],[NSValue valueWithCGRect:CGRectMake(239, 225, 125, 30)],[NSValue valueWithCGRect:CGRectMake(341, 225, 125, 30)],[NSValue valueWithCGRect:CGRectMake(160, 260, 125, 30)],[NSValue valueWithCGRect:CGRectMake(260, 260, 125, 30)],[NSValue valueWithCGRect:CGRectMake(360, 260, 125, 30)], nil];
        
    } else 
        _rectArray = [[NSMutableArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(77, 10, 100, 30)], [NSValue valueWithCGRect:CGRectMake(178, 10, 100, 30)],[NSValue valueWithCGRect:CGRectMake(280, 10, 100, 30)],[NSValue valueWithCGRect:CGRectMake(77, 41, 100, 30)],[NSValue valueWithCGRect:CGRectMake(178, 41, 100, 30)],[NSValue valueWithCGRect:CGRectMake(280, 41, 100, 30)],[NSValue valueWithCGRect:CGRectMake(14, 72, 100, 30)],[NSValue valueWithCGRect:CGRectMake(114, 72, 100, 30)],[NSValue valueWithCGRect:CGRectMake(215, 72, 100, 30)],[NSValue valueWithCGRect:CGRectMake(315, 72, 100, 30)],[NSValue valueWithCGRect:CGRectMake(40, 102, 100, 30)],[NSValue valueWithCGRect:CGRectMake(140, 102, 100, 30)],[NSValue valueWithCGRect:CGRectMake(240, 102, 100, 30)],[NSValue valueWithCGRect:CGRectMake(340, 102, 100, 30)],[NSValue valueWithCGRect:CGRectMake(70, 133, 100, 30)],[NSValue valueWithCGRect:CGRectMake(170, 133, 100, 30)],[NSValue valueWithCGRect:CGRectMake(270, 133, 100, 30)],[NSValue valueWithCGRect:CGRectMake(370, 133, 100, 30)],[NSValue valueWithCGRect:CGRectMake(158, 165, 100, 30)],[NSValue valueWithCGRect:CGRectMake(260, 165, 100, 30)],[NSValue valueWithCGRect:CGRectMake(362, 165, 100, 30)],[NSValue valueWithCGRect:CGRectMake(145, 195, 100, 30)],[NSValue valueWithCGRect:CGRectMake(247, 195, 100, 30)],[NSValue valueWithCGRect:CGRectMake(349, 195, 100, 30)],[NSValue valueWithCGRect:CGRectMake(137, 225, 100, 30)],[NSValue valueWithCGRect:CGRectMake(239, 225, 100, 30)],[NSValue valueWithCGRect:CGRectMake(341, 225, 100, 30)],[NSValue valueWithCGRect:CGRectMake(160, 260, 100, 30)],[NSValue valueWithCGRect:CGRectMake(260, 260, 100, 30)],[NSValue valueWithCGRect:CGRectMake(360, 260, 100, 30)], nil];
    
    [_rectArray shuffle];
    _qustIdArray = [[NSMutableArray alloc] init];
    _idArray = [[NSMutableArray alloc] init];
    _inDangerIdArray = [[NSMutableArray alloc] init];
    [self.view addSubview:_pauseView];
    [_pauseView setHidden:YES];
    [self playTheme];
    
    
     limit = 6;
     [self getWords];
    [self assignWordsOnAllView];
    // Do any additional setup after loading the view from its nib.
    
    [self showAlbum];
    _arrNativeTag = [[NSMutableArray alloc] init];
    _arrTargetTag = [[NSMutableArray alloc] init];
    _testDate = [NSDate date];
    [UserDefaluts setObject:_testDate forKey:@"CurrentTestDate"];
    _correctWordCount = [[UserDefaluts objectForKey:kCorrectCounter] intValue];
    
    
    
    _timeView = [[TimerView alloc] initWithFrame:CGRectMake(_isiPhone5 ? 497 : 410, 10, 60, 60)];
    _timeView.percent = 60;
    [self.view addSubview:_timeView];
    
    
    // Start timer
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Green Test Screen";
    [SharedAppDelegate.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Green_Test" action:@"Green_Test_Begin" label:@"WordBucket-Paid" value:nil] build]];
}


- (void)showAlbum {
    // check current orientation
    if ([[UIApplication sharedApplication] statusBarOrientation] != UIDeviceOrientationLandscapeRight) {
        // no, the orientation is wrong, we must rotate the UI
        self.navigationController.view.userInteractionEnabled = NO;
        [UIView beginAnimations:@"newAlbum" context:NULL];
        [UIView setAnimationDelegate:self];
        // when rotation is done, we can add new views, because UI orientation is OK
        [UIView setAnimationDidStopSelector:@selector(addAlbum)];
        // setup status bar
        [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:NO];
        // rotate main view, in this sample the view of navigation controller is the root view in main window
        [self.navigationController.view setTransform: CGAffineTransformMakeRotation(3*M_PI / 2)];
        // set size of view
        [self.navigationController.view setFrame:CGRectMake(0, 0, 320, _isiPhone5 ? 568 : 460)];
        [UIView commitAnimations];
    } 
    
}

- (void)addAlbum
{
    self.navigationController.view.userInteractionEnabled = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        return YES;
    }
    return NO;
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    [self.view bringSubviewToFront:recognizer.view];
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        //CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = 0 / 200;
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        
        finalPoint.x = MIN(MAX(finalPoint.x, 55), self.view.bounds.size.width-55);
        finalPoint.y = MIN(MAX(finalPoint.y, 20), self.view.bounds.size.height-20);
        
        
        UIButton *dragButton = (UIButton*)recognizer.view;
        //NSLog(@"drag button is %@",dragButton);
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
    
        
        for (int k =1; k<=12 ; k++) {
            
            UIButton *button = (UIButton*)[self.view viewWithTag:k];
            
            if (CGRectIntersectsRect(recognizer.view.frame, button.frame) && k != dragButton.tag) {
                
                CGRect btnRect = CGRectMake(button.frame.origin.x+25, button.frame.origin.y+7.5, 50, 15);
                if (CGRectContainsPoint(btnRect, dragButton.center)) {
                    
                    
                    if ((button.tag>6 && dragButton.tag > 6) || (button.tag<6 && dragButton.tag<6))
                        continue;
                    
                   
                    NSInteger whiteCount = [[UserDefaluts objectForKey:kGreenTestCount] integerValue]+1;
                    [UserDefaluts setInteger:whiteCount forKey:kGreenTestCount];
                    
                     //NSLog(@"final button is %@",button);
                    // Run query here -
                    NSString *nativeString = @"";
                    NSString *targetString = @"";
                    NSString *wrongQuery = nil;
                    
                    if (button.tag >6) 
                        nativeString = button.titleLabel.text;
                     else 
                        targetString = button.titleLabel.text;
                    
                    
                    if (dragButton.tag >6) {
                        nativeString = dragButton.titleLabel.text;
                        wrongQuery = [NSString stringWithFormat:@"nativeWord = \"%@\"",nativeString];
                    } else {
                        targetString = dragButton.titleLabel.text;
                        wrongQuery = [NSString stringWithFormat:@"targetWord = \"%@\"",targetString];
                    }
                    
                    NSString *dragBtnId = [dragButton titleForState:UIControlStateSelected];
                    NSString *buttonId = [button titleForState:UIControlStateSelected];
                    NSLog(@"drag id and button id %@ %@",dragBtnId,buttonId);
                    
                    if (targetString.length > 0 && nativeString.length > 0) {
                        
                        [self updateAverageTimeWithId:dragBtnId];
                        
                        NSString *queryString =  [NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Dictionary where targetWord = \"%@\" and nativeWord = \"%@\"",targetString,nativeString];
                        
                        if ( ([[DBHelper sharedDbInstance] getRowCountWithQuery:queryString]>0) || ([dragBtnId isEqualToString:buttonId])) {
                            // True
                            
                            [self playCorrectSong];
                            [_rightButton setTitle:dragButton.titleLabel.text forState:UIControlStateNormal];
                            [self.view addSubview:_rightButton];
                            [_rightButton setCenter:dragButton.center];
                            [self performSelector:@selector(removeWrongImgView:) withObject:_rightButton afterDelay:1.0];
                            NSString *queryString =  [NSString stringWithFormat:@"SELECT action FROM tbl_Dictionary where id = \"%@\"",dragBtnId];
                            NSString *action = [[DBHelper sharedDbInstance] getSingleStringWithQuery:queryString];
                            if ([action isEqualToString:@"InDanger"])
                            {
                                [_inDangerIdArray addObject:dragBtnId];
                            }
                            
                            [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Green', action = 'GreenTest',dateOfTest=\"%@\" WHERE targetWord = \"%@\" and nativeWord = \"%@\"",_testDate,targetString,nativeString]];
                            
                            NSLog(@"CORRENT ANSWER");
                            [self updateViewWithDragButtons:dragButton button:button];
                            
                        } else {
                            
                            [self playIncorrectSong];
                            [_wrongButton setTitle:dragButton.titleLabel.text forState:UIControlStateNormal];
                            [self.view addSubview:_wrongButton];
                            [_wrongButton setCenter:dragButton.center];
                            [self performSelector:@selector(removeWrongImgView:) withObject:_wrongButton afterDelay:1.0];
                            
                            NSString *queryString =  [NSString stringWithFormat:@"SELECT action FROM tbl_Dictionary where id = \"%@\"",dragBtnId];
                            NSString *action = [[DBHelper sharedDbInstance] getSingleStringWithQuery:queryString];
                            
                            
                            if ([action isEqualToString:@"InDanger"]) {
                                
                                [_inDangerIdArray addObject:dragBtnId];
                                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Red', action = 'GreenTest',dateOfTest=\"%@\" WHERE id = \"%@\"",_testDate,dragBtnId]];
                                
                            } else {
                                
                                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'Green', action = 'InDanger',dateOfTest=\"%@\" WHERE id = \"%@\"",_testDate,dragBtnId]];
                            }
                            
                            //NSString *correctquery = (dragButton.tag > 6) ? [NSString stringWithFormat:@"SELECT targetWord FROM tbl_Dictionary where %@",wrongQuery] : [NSString stringWithFormat:@"SELECT nativeWord FROM tbl_Dictionary where %@",wrongQuery];
                            NSMutableArray *ansArray = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary where %@",wrongQuery] withField:(dragButton.tag > 6 ? @"targetWord" : @"nativeWord")];
                            
                            UIButton *correctButton = nil;
                            for (int k = (dragButton.tag > 6) ? 1 : 7; k <=12; k++) {
                                
                                correctButton = (UIButton*)[self.view viewWithTag:k];
                                
                                 NSLog(@"drag id and button id %@ %@",dragBtnId,buttonId);
                                if (correctButton && [[correctButton titleForState:UIControlStateSelected] isEqualToString:[dragButton titleForState:UIControlStateSelected]])
                                        break;
                                if (correctButton &&[ansArray containsObject:correctButton.titleLabel.text])
                                    break;
                                
                            }
                            
                            ansArray=nil;
                            NSLog(@"WRONG ANSWER");
                            NSLog(@">>>> CORRENT BUTTON ID IS and tag = %@ %d",[correctButton titleForState:UIControlStateSelected],correctButton.tag);
                            [self updateViewWithDragButtons:dragButton button:correctButton];
                            
                        }
                        
                    }
                    
                    break;
                }
                
            }
        }
    
    }
    
}


- (void)updateViewWithDragButtons:(UIButton*)dragButton button:(UIButton*)button
{
    
    
    NSString *dragBtnId = [dragButton titleForState:UIControlStateSelected];
    NSString *buttonId =  [button titleForState:UIControlStateSelected];
    NSLog(@"IDES ARE %@ %@",dragBtnId,buttonId);
    if(dragBtnId)
    [_idArray addObject:dragBtnId];
    if(buttonId)
    [_idArray addObject:buttonId];
    
    if (dragButton.tag >6) {
        [_arrNativeTag addObject:[NSString stringWithFormat:@"%d",dragButton.tag]];
        [_arrTargetTag addObject:[NSString stringWithFormat:@"%d",button.tag]];
    } else {
        [_arrNativeTag addObject:[NSString stringWithFormat:@"%d",button.tag]];
        [_arrTargetTag addObject:[NSString stringWithFormat:@"%d",dragButton.tag]];
    }
    
    
    [dragButton removeFromSuperview];
    [button removeFromSuperview];
    
    if ((_idArray.count%6==0) && _pairCount<3) {
        [self addRestButtons];
    } else if (_idArray.count>=6)
        [self checkWhetherWordIsRemaining];
}

- (void)updateAverageTimeWithId:(NSString*)idString
{
    NSString *queryString =  [NSString stringWithFormat:@"SELECT dateOfTest FROM tbl_Dictionary where id = \"%@\"",idString];
    NSString *action = [[DBHelper sharedDbInstance] getSingleStringWithQuery:queryString];
    NSDate *olderDate = [Common dateFromString:action];
    if (olderDate) {
     NSInteger timediff = [[NSDate date] timeIntervalSinceDate:olderDate];
    NSLog(@"time in sec and min %d  %d",timediff,timediff/60);
    [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Average_Time set Counter = Counter + 1, Time = Time+%d where id = '3'",timediff/60]];
    }
}

- (void)removeWrongImgView:(UIButton*)imageView
{
    [imageView removeFromSuperview];
}

- (void)checkWhetherWordIsRemaining
{
    BOOL isFinish = YES;
    for (int k =1; k<12 ; k++) {
        UIButton *button = (UIButton*)[self.view viewWithTag:k];
        if(button){
            isFinish = NO;
            break;
        }
    }
    
    if(isFinish)[self gameOver];
}

- (IBAction)backButtonClicked:(id)sender {
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
    // rotate main view, in this sample the view of navigation controller is the root view in main window
    [self.navigationController.view setTransform: CGAffineTransformMakeRotation(0)];
    // set size of view
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, _isiPhone5 ? 568 : 460)];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateTimer:(NSTimer *)timer {
    
    
    if (_timeView.percent > 0) {
        _timeView.percent = _timeView.percent - 1;
        [_timeView setNeedsDisplay];
    } else {
        [_mainTimer invalidate];
        _mainTimer = nil;
        [self gameOver];
    }
    

    
}



- (void)setUserInteractionEnable:(BOOL)isEnable
{
    for (id view in self.view.subviews)
        [view setUserInteractionEnabled:isEnable];
    _btnPause.userInteractionEnabled=YES;
}

- (void)gameOver
{
    if(_mainTimer){[_mainTimer invalidate];_mainTimer=nil;}
    NSString *title = nil;
    NSString *messageString = NSLocalizedString(@"Finished", nil) ;
    if ([[UserDefaluts objectForKey:kCorrectCounter] intValue] - _correctWordCount >= 12) {
        title = NSLocalizedString(@"Congratulations!", nil);
        messageString = NSLocalizedString(@"Perfect game! You scored 12 out of 12.", nil);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messageString delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)setScreenOnPortait
{
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer stop];
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
    // rotate main view, in this sample the view of navigation controller is the root view in main window
    [self.navigationController.view setTransform: CGAffineTransformMakeRotation(0)];
    // set size of view
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, _isiPhone5 ? 568 : 460)];
    [Common showTabBar:self.tabBarController];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self setScreenOnPortait];
    NSString *nib = SharedAppDelegate.isPhone5 ? @"ResultsVC" : @"ResultsVCiPhone4";
    ResultsVC *test = [[ResultsVC alloc] initWithNibName:nib bundle:nil];
    test.lblColor = _isGreenTest ? @"Green" : @"InDanger";
    [_idArray removeDublicateObjects];
    test.resultIdArray = _idArray;
    test.inDangerCrrtIdArray = _inDangerIdArray;
    //self.tabBarController.tabBar.hidden = NO;
    [self.navigationController pushViewController:test animated:YES];
    
}

- (IBAction)pauseClicked:(UIButton*)sender {
    
    if ([_mainTimer isValid]) {
        
        //Pause Screen
        [_mainTimer invalidate];_mainTimer=nil;
        //[self setUserInteractionEnable:NO];
        [_btnPause setSelected:YES];
        [_pauseView setHidden:NO];
        [self.view bringSubviewToFront:_pauseView];
        
    } else {
        
        // Resume screen
        [_btnPause setSelected:NO];
        [_pauseView setHidden:YES];
        //[self setUserInteractionEnable:YES];
        _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        
    }
}

- (IBAction)pauseScreenButtonClicked:(id)sender {
    
    switch ([sender tag]) {
        case 100:
            // Resume
            [self pauseClicked:nil];
            break;
        case 101:
            // Restart
            [self restartGame];
            break;
        case 102:
            // Restart
            //[_pauseView setHidden:NO];
            //[self gameOver];
            [self setScreenOnPortait];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
            break;
            
        default:
            break;
    }
}

- (void)restartGame
{
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:_isGreenTest ? @"Green" : @"InDanger" forKey:kBucketColor];
    
    if (_isGreenTest) {
        
        NSString *greenWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT count(*) FROM tbl_Dictionary where bucketColor = 'Green'"]];
        if ([greenWord integerValue] >= 12) {
            [self popToPreGreenTest];
            //[self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetakeGreenTestNotification object:nil userInfo:userInfo];
            
        } else
            [self showAlert];
        
    } else {
        
        NSString *greenWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT count(*) FROM tbl_Dictionary where bucketColor = 'Green''"]];
        if ([greenWord integerValue] >= 12) {
            
            [self popToPreGreenTest];
            //[self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetakeGreenTestNotification object:nil userInfo:userInfo];
            
        } else
            [self showAlert];
        
    }
}


- (void)showAlert
{
     NSString *messageString = _isGreenTest ?  [NSString stringWithFormat:NSLocalizedString(@"Sorry! You need at least 12 words in your Green Bucket to do a test. Do more Orange Bucket tests!", nil)] : [NSString stringWithFormat:NSLocalizedString(@"Good work! You don't have enough words (12) in danger to play. Only words you get wrong in the Green Game go here", nil)];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"" message:messageString delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)popToPreGreenTest
{
    NSArray *arr = [self.navigationController viewControllers];
    PreGreenTestVC *Obj;
    for (int i = 0; i< arr.count ; i++)
    {
        UIViewController *aviewCont = [arr objectAtIndex:i];
        if ([aviewCont isKindOfClass:[PreGreenTestVC class]])
        {
            Obj = [arr objectAtIndex:i];
            break;
        }
    }
    
    [self setScreenOnPortait];
    [self.navigationController popToViewController:Obj animated:NO];
    
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

- (void)playTheme
{
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/GreenTheme.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer setDelegate:self];
    if (_audioPlayer == nil) {
        NSLog(@"%@", [error description]);
    } else {
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        
    }
    /*
    SystemSoundID bell;
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GreenTheme.wav" ofType:nil]], &bell);
    AudioServicesPlaySystemSound (bell);
     */
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self playTheme];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    
    [self setAudioPlayer:nil];
    [self setIdArray:nil];
    [self setActionString:nil];
    [self setBtn1:nil];
    [self setBtn2:nil];
    [self setBtn3:nil];
    [self setBtn4:nil];
    [self setBtn5:nil];
    [self setBtn6:nil];
    [self setBtn7:nil];
    [self setBtn8:nil];
    [self setBtn9:nil];
    [self setBtn10:nil];
    [self setBtn11:nil];
    [self setBtn12:nil];
    [self setBtnPause:nil];
    [self setTestDate:nil];
    [self setRectArray:nil];
    [self setMainTimer:nil];
    [self setTimeLabel:nil];
    [self setQustIdArray:nil];
    [self setWrongImgView:nil];
    [self setBgImageView:nil];
    [self setBucketLabel:nil];
    [self setRightImageView:nil];
    [self setPauseView:nil];
    [self setRightButton:nil];
    [self setWrongButton:nil];
    [self setResumeButton:nil];
    [self setRestartButton:nil];
    [self setQuitButton:nil];
    [self setGamePausedLabel:nil];
    [self setResumeLabel:nil];
    [self setRestartLabel:nil];
    [self setQuitLabel:nil];
    [self setInDangerIdArray:nil];
    [super viewDidUnload];
}



@end
