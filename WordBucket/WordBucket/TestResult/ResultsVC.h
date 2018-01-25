//
//  ResultsVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/20/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsVC : GAITrackedViewController

@property(nonatomic,retain) IBOutlet UITableView *tblResult;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblScore;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnHome;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *scoreTexLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTestAgain;

@property (nonatomic, retain) UIImage *bucketImage;
@property (nonatomic, retain) UIImage *redbucketImage;
@property (nonatomic, retain) UIImage *greenbucketImage;
@property (nonatomic,retain) NSMutableArray *arrTestWords;
@property (nonatomic, retain) NSMutableArray *resultIdArray;
@property (nonatomic, retain) NSMutableArray *inDangerCrrtIdArray;
@property (nonatomic,retain) NSString *lblColor;

- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)testAgain:(id)sender;
@end
