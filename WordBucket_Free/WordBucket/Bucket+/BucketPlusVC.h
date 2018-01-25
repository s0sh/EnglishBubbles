//
//  BucketPlusVC.h
//  WordBucket
//
//  Created by Amit Garg on 12/31/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketPlusVC : GAITrackedViewController


@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSkype;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnFacebook;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnWordOfWeek;
@property (weak, nonatomic) IBOutlet UILabel *learnEnglishLabel;
@property (weak, nonatomic) IBOutlet UILabel *withEnglishLabel;

- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)wordOfWeekBtnClicked:(id)sender;
- (IBAction)skypeButtonClicked:(id)sender;
- (IBAction)fbGames:(id)sender;

@end
