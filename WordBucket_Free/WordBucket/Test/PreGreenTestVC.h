//
//  PreGreenTestVC.h
//  WordBucket
//
//  Created by ashish on 3/6/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreGreenTestVC : GAITrackedViewController

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *greenLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *indangerLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *indangeLabel2;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *indangeLabel3;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *indangeLabel4;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *prctiseGreenLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnAllGreenTest;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSaveInDanger;



- (IBAction)testAllGreenBtnClicked:(id)sender;
- (IBAction)saveIndangerBtnClicked:(id)sender;
- (IBAction)greenTestButtonClicked:(id)sender;
- (IBAction)indangerTestButtonClicked:(id)sender;

- (IBAction)homeButtonClicked:(id)sender;
@end
