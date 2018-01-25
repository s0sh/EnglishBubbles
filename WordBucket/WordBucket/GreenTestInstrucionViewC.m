//
//  GreenTestInstrucionViewC.m
//  WordBucket
//
//  Created by ashish on 3/19/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "GreenTestInstrucionViewC.h"
#import "GreenTestVCViewController.h"

@interface GreenTestInstrucionViewC ()

@end

@implementation GreenTestInstrucionViewC

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
    [_dragLabel setText:NSLocalizedString(@"Drag and drop words to play", nil)];
    [_turnLabel setText:NSLocalizedString(@"Turn your phone now", nil)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setLocalizedString];
    _counter = 0;
    _instrucionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(instrucionAction:) userInfo:nil repeats:YES];
    [_turnLabel setHidden:YES];
    [_dragLabel setHidden:NO];
    NSString *imageName = SharedAppDelegate.isPhone5 ? @"dragbg-iPhone5" : @"dragbg";
    [_bgImgView setImage:GetImage(imageName)];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Green Test Instruction Screen";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Common hideTabBar:self.tabBarController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)instrucionAction:(NSTimer *)timer
{
    _counter++;
    NSLog(@"counter valsue is %d",_counter);
    switch (_counter) {
        case 1:
            [_sixImgView setImage:GetImage(@"Blue6")];
            break;
        case 2:
            [_fiveImgView setImage:GetImage(@"Blue5")];
            break;
        case 3:
            [_fourImgView setImage:GetImage(@"Blue4")];
            break;
        case 4:{
            [_threeImgView setImage:GetImage(@"Blue3")];
            NSString *imageName = SharedAppDelegate.isPhone5 ? @"turnbg-iPhone5" : @"turnbg";
            [_bgImgView setImage:GetImage(imageName)];
            [_turnLabel setHidden:NO];
            [_dragLabel setHidden:YES];
        }
            break;
        case 5:
            [_twoImgView setImage:GetImage(@"Blue2")];
            break;
        case 6:
            [_oneImgView setImage:GetImage(@"Blue1")];
            break;
            
        default:
            break;
    }
    
    if (_counter >6) {
        
        // Invalidate timer
        [Common showTabBar:self.tabBarController];
        if ([_instrucionTimer isValid]) {[_instrucionTimer invalidate];_instrucionTimer=nil;}
        
        [self pushGreenTest];
    }
}

- (void)pushGreenTest
{
    NSString *nib = SharedAppDelegate.isPhone5 ? @"GreenTestVCViewController" : @"GreenTestVCViewControlleriPhone4";
    GreenTestVCViewController *greenTestObj = [[GreenTestVCViewController alloc] initWithNibName:nib bundle:nil];
    greenTestObj.actionString = @"(action = 'GreenTest' OR action = 'OrangeTest2' OR action = 'InDanger')";
    /*
    if(_isGreenTest)
        greenTestObj.actionString = @"(action = 'GreenTest' OR action = 'OrangeTest2' OR action = 'InDanger')";
    else
        greenTestObj.actionString = @"action = 'InDanger'";*/
    greenTestObj.isGreenTest = _isGreenTest;
    [self.navigationController pushViewController:greenTestObj animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    
    [self setInstrucionTimer:nil];
    [self setBgImgView:nil];
    [self setSixImgView:nil];
    [self setFiveImgView:nil];
    [self setFourImgView:nil];
    [self setThreeImgView:nil];
    [self setTwoImgView:nil];
    [self setOneImgView:nil];
    [self setTurnLabel:nil];
    [self setDragLabel:nil];
    [super viewDidUnload];
}

@end
