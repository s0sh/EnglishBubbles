//
//  WordOfWeekViewC.h
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordOfWeekViewC : GAITrackedViewController<UITextViewDelegate>
- (IBAction)homeButtonClicked:(id)sender;

@property (strong, nonatomic) NSString *htmlurlString;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *wordListTable;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fivewordLabel;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) NSMutableArray *descArray;
@property (strong, nonatomic) NSMutableArray *imgArray;
@property (strong, nonatomic) NSMutableArray *cachesImagesArray;


@end
