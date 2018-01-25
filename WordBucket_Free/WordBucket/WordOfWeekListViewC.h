//
//  WordOfWeekListViewC.h
//  WordBucket
//
//  Created by ashish on 4/12/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordOfWeekListViewC : GAITrackedViewController

@property (nonatomic, retain) NSMutableArray *weekListArray;
@property (nonatomic, retain) NSMutableArray *linkListArray;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *weekListTable;

- (IBAction)backButtonClicked:(id)sender;

@end
