//
//  InfoViewC.h
//  WordBucket
//
//  Created by ashish on 3/12/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewC : GAITrackedViewController

@property (nonatomic, assign) BOOL isFromLogin;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *crossButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titileLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *searchLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *saveLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *playLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *carefullLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *searchTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *saveTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *playTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnFindAndLear;



- (IBAction)crossButtonClicked:(id)sender;
- (IBAction)findNewWordButtonClicked:(id)sender;

@end
